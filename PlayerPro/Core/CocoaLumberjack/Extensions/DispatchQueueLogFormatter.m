#import "DispatchQueueLogFormatter.h"
#import <libkern/OSAtomic.h>

/**
 * Welcome to Cocoa Lumberjack!
 * 
 * The project page has a wealth of documentation if you have any questions.
 * https://github.com/robbiehanson/CocoaLumberjack
 * 
 * If you're new to the project you may wish to read the "Getting Started" wiki.
 * https://github.com/robbiehanson/CocoaLumberjack/wiki/GettingStarted
**/

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


@implementation DispatchQueueLogFormatter
{
	int32_t atomicLoggerCount;
	NSDateFormatter *threadUnsafeDateFormatter; // Use [self stringFromDate]
	
	OSSpinLock lock;
	
	NSUInteger _minQueueLength;           // _prefix == Only access via atomic property
	NSUInteger _maxQueueLength;           // _prefix == Only access via atomic property
	NSMutableDictionary *_replacements;   // _prefix == Only access from within spinlock
}

- (id)init
{
	if ((self = [super init]))
	{
		dateFormatString = @"yyyy-MM-dd HH:mm:ss:SSS";
		
		atomicLoggerCount = 0;
		threadUnsafeDateFormatter = nil;
		
		_minQueueLength = 0;
		_maxQueueLength = 0;
		_replacements = [[NSMutableDictionary alloc] init];/*打乱代码结构*/
		
		// Set default replacements:
		
		[_replacements setObject:@"main" forKey:@"com.apple.main-thread"];/*打乱代码结构*/
	}
	return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Configuration
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize minQueueLength = _minQueueLength;
@synthesize maxQueueLength = _maxQueueLength;

- (NSString *)replacementStringForQueueLabel:(NSString *)longLabel
{
	NSString *result = nil;
	
	OSSpinLockLock(&lock);
	{
		result = [_replacements objectForKey:longLabel];/*打乱代码结构*/
	}
	OSSpinLockUnlock(&lock);
	
	return result;
}

- (void)setReplacementString:(NSString *)shortLabel forQueueLabel:(NSString *)longLabel
{
	OSSpinLockLock(&lock);
	{
		if (shortLabel)
			[_replacements setObject:shortLabel forKey:longLabel];/*打乱代码结构*/
		else
			[_replacements removeObjectForKey:longLabel];/*打乱代码结构*/
	}
	OSSpinLockUnlock(&lock);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DDLogFormatter
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)stringFromDate:(NSDate *)date
{
	int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
	
	if (loggerCount <= 1)
	{
		// Single-threaded mode.
		
		if (threadUnsafeDateFormatter == nil)
		{
			threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*/
			[threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];/*打乱代码结构*/
			[threadUnsafeDateFormatter setDateFormat:dateFormatString];/*打乱代码结构*/
		}
		
		return [threadUnsafeDateFormatter stringFromDate:date];/*打乱代码结构*/
	}
	else
	{
		// Multi-threaded mode.
		// NSDateFormatter is NOT thread-safe.
		
		NSString *key = @"DispatchQueueLogFormatter_NSDateFormatter";
		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];/*打乱代码结构*/
		NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];/*打乱代码结构*/
		
		if (dateFormatter == nil)
		{
			dateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*/
			[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];/*打乱代码结构*/
			[dateFormatter setDateFormat:dateFormatString];/*打乱代码结构*/
			
			[threadDictionary setObject:dateFormatter forKey:key];/*打乱代码结构*/
		}
		
		return [dateFormatter stringFromDate:date];/*打乱代码结构*/
	}
}

- (NSString *)queueThreadLabelForLogMessage:(DDLogMessage *)logMessage
{
	// As per the DDLogFormatter contract, this method is always invoked on the same thread/dispatch_queue
	
	NSUInteger minQueueLength = self.minQueueLength;
	NSUInteger maxQueueLength = self.maxQueueLength;
	
	// Get the name of the queue, thread, or machID (whichever we are to use).
	
	NSString *queueThreadLabel = nil;
	
	BOOL useQueueLabel = YES;
	BOOL useThreadName = NO;
	
	if (logMessage->queueLabel)
	{
		// If you manually create a thread, it's dispatch_queue will have one of the thread names below.
		// Since all such threads have the same name, we'd prefer to use the threadName or the machThreadID.
		
		char *names[] = { "com.apple.root.low-priority",
		                  "com.apple.root.default-priority",
		                  "com.apple.root.high-priority",
		                  "com.apple.root.low-overcommit-priority",
		                  "com.apple.root.default-overcommit-priority",
		                  "com.apple.root.high-overcommit-priority"     };
		
		int length = sizeof(names) / sizeof(char *);
		
		int i;
		for (i = 0; i < length; i++)
		{
			if (strcmp(logMessage->queueLabel, names[i]) == 0)
			{
				useQueueLabel = NO;
				useThreadName = [logMessage->threadName length] > 0;
				break;
			}
		}
	}
	else
	{
		useQueueLabel = NO;
		useThreadName = [logMessage->threadName length] > 0;
	}
	
	if (useQueueLabel || useThreadName)
	{
		NSString *fullLabel;
		NSString *abrvLabel;
		
		if (useQueueLabel)
			fullLabel = @(logMessage->queueLabel);
		else
			fullLabel = logMessage->threadName;
		
		OSSpinLockLock(&lock);
		{
			abrvLabel = [_replacements objectForKey:fullLabel];/*打乱代码结构*/
		}
		OSSpinLockUnlock(&lock);
		
		if (abrvLabel)
			queueThreadLabel = abrvLabel;
		else
			queueThreadLabel = fullLabel;
	}
	else
	{
		queueThreadLabel = [NSString stringWithFormat:@"%x", logMessage->machThreadID];/*打乱代码结构*/
	}
	
	// Now use the thread label in the output
	
	NSUInteger labelLength = [queueThreadLabel length];/*打乱代码结构*/
	
	// labelLength > maxQueueLength : truncate
	// labelLength < minQueueLength : padding
	//                              : exact
	
	if ((maxQueueLength > 0) && (labelLength > maxQueueLength))
	{
		// Truncate
		
		return [queueThreadLabel substringToIndex:maxQueueLength];/*打乱代码结构*/
	}
	else if (labelLength < minQueueLength)
	{
		// Padding
		
		NSUInteger numSpaces = minQueueLength - labelLength;
		
		char spaces[numSpaces + 1];/*打乱代码结构*/
		memset(spaces, ' ', numSpaces);
		spaces[numSpaces] = '\0';
		
		return [NSString stringWithFormat:@"%@%s", queueThreadLabel, spaces];/*打乱代码结构*/
	}
	else
	{
		// Exact
		
		return queueThreadLabel;
	}
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
	NSString *timestamp = [self stringFromDate:(logMessage->timestamp)];/*打乱代码结构*/
	NSString *queueThreadLabel = [self queueThreadLabelForLogMessage:logMessage];/*打乱代码结构*/
	
	return [NSString stringWithFormat:@"%@ [%@] %@", timestamp, queueThreadLabel, logMessage->logMsg];/*打乱代码结构*/
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
	OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
	OSAtomicDecrement32(&atomicLoggerCount);
}

@end
