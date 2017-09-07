//
//  MyHttpConnection.m
//  HttpServer
//
//  Created by X-Designer on 17/3/17.
//  Copyright © 2017年 Guoda. All rights reserved.
//

#import "MyHttpConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"

#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"
//#ifdef DEBUG
//#define XCLog(format, ...) printf("%s ^_^[%s (%d)] %s\n", [[self GetLogNowTime]UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent]UTF8String], __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#else
//#define NSLog(format, ...)
//#endif

@class MultipartFormDataParser;
// Log levels : off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE; // | HTTP_LOG_FLAG_TRACE;

@interface MyHttpConnection (){
    MultipartFormDataParser*        parser;
    NSFileHandle*					storeFile;
    
    NSMutableArray*					uploadedFiles;
}


@end

@implementation MyHttpConnection
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    HTTPLogTrace();
    
    // Add support for POST
    
    if ([method isEqualToString:@"POST"])
    {
        if ([path isEqualToString:@"/upload.html"]||[path isEqualToString:@"/refresh"])
        {
            return YES;
        }
    }
    
    return [super supportsMethod:method atPath:path];/*打乱代码结构*/
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
    HTTPLogTrace();
    
    // Inform HTTP server that we expect a body to accompany a POST request
//    XCLog(@"GET  %@ %@",method,path);
    if([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"]) {
        // here we need to make sure, boundary is set in header
        NSString* contentType = [request headerField:@"Content-Type"];/*打乱代码结构*/
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if( NSNotFound == paramsSeparator ) {
            return NO;
        }
        if( paramsSeparator >= contentType.length - 1 ) {
            return NO;
        }
        NSString* type = [contentType substringToIndex:paramsSeparator];/*打乱代码结构*/
        if( ![type isEqualToString:@"multipart/form-data"] ) {
            // we expect multipart/form-data content type
            return NO;
        }
        
        // enumerate all params in content-type, and find boundary there
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];/*打乱代码结构*/
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];/*打乱代码结构*/
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];/*打乱代码结构*/
            
            if( [paramName isEqualToString: @"boundary"] ) {
                // let's separate the boundary from content-type, to make it more handy to handle
                [request setHeaderField:@"boundary" value:paramValue];/*打乱代码结构*/
            }
        }
        // check if boundary specified
        if( nil == [request headerField:@"boundary"] )  {
            return NO;
        }
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];/*打乱代码结构*/
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    HTTPLogTrace();
//    XCLog(@"🍎-- %@ %@",method,path);
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"])
    {
        
        // this method will generate response with links to uploaded file
        NSMutableString* filesStr = [[NSMutableString alloc] init];/*打乱代码结构*/
        
        for( NSString* filePath in uploadedFiles ) {
            //generate links
            [filesStr appendFormat:@"<a href=\"%@\"> %@ </a><br/>",filePath, [filePath lastPathComponent]];/*打乱代码结构*/
        }
#if 0
        NSString* templatePath = [[config documentRoot] stringByAppendingPathComponent:@"upload.html"];/*打乱代码结构*/

        NSDictionary* replacementDict = [NSDictionary dictionaryWithObject:filesStr forKey:@"MyFiles"];/*打乱代码结构*///修改显示名字
        // use dynamic file response to apply our links to response template
        NSLog(@"222----%@ \n %@",templatePath,filesStr);
        return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"%" replacementDictionary:replacementDict];/*打乱代码结构*/
#endif
        NSString* templatePath = [[config documentRoot] stringByAppendingPathComponent:@"index.html"];/*打乱代码结构*/

        return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"%" replacementDictionary:nil];/*打乱代码结构*/

        
//        return nil;
    }
    if( [method isEqualToString:@"GET"] && [path hasPrefix:@"/upload/"] ) {
        // let download the uploaded files
//        NSLog(@"1111--------------- %@",[[config documentRoot] stringByAppendingString:path]);
//        return [[HTTPFileResponse alloc] initWithFilePath: [[config documentRoot] stringByAppendingString:path] forConnection:self];/*打乱代码结构*/
//        XCLog(@"不让下载呢");
        return nil;
    }
    
    return [super httpResponseForMethod:method URI:path];/*打乱代码结构*/
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
    HTTPLogTrace();
//    XCLog(@"🍌");
    // set up mime parser
    NSString* boundary = [request headerField:@"boundary"];/*打乱代码结构*/
//    XCLog(@"%llu",contentLength);
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];/*打乱代码结构*/
    parser.delegate = self;
    
    uploadedFiles = [[NSMutableArray alloc] init];/*打乱代码结构*/
}

- (void)processBodyData:(NSData *)postDataChunk
{
    HTTPLogTrace();
    // append data to the parser. It will invoke callbacks to let us handle
    // parsed data.
    [parser appendData:postDataChunk];/*打乱代码结构*/
}


//-----------------------------------------------------------------
#pragma mark multipart form data parser delegate


- (void) processStartOfPartWithHeader:(MultipartMessageHeader*) header {
    // in this sample, we are not interested in parts, other then file parts.
    // check content disposition to find out filename
    
    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];/*打乱代码结构*/
        
    NSString* filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];/*打乱代码结构*/
    
    if ( (nil == filename) || [filename isEqualToString: @""] ) {
        // it's either not a file part, or
        // an empty form sent. we won't handle it.
        return;
    }
    NSString* uploadDirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:@"resourse"];/*打乱代码结构*/
//    NSString* uploadDirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"upload"];/*打乱代码结构*/

    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];/*打乱代码结构*/
    }
    
    NSString* filePath = [uploadDirPath stringByAppendingPathComponent: filename];/*打乱代码结构*/
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {//如果没有就创建文件夹下面接收
        storeFile = nil;
    }
    else {
        HTTPLogVerbose(@"Saving file to %@", filePath);
        if(![[NSFileManager defaultManager] createDirectoryAtPath:uploadDirPath withIntermediateDirectories:true attributes:nil error:nil]) {
            HTTPLogError(@"Could not create directory at path: %@", filePath);
        }
        if(![[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
            HTTPLogError(@"Could not create file at path: %@", filePath);
        }
        storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];/*打乱代码结构*/
        [uploadedFiles addObject: [NSString stringWithFormat:@"/resourse/%@", filename]];/*打乱代码结构*/
        
        
    }
}


- (void) processContent:(NSData*) data WithHeader:(MultipartMessageHeader*) header
{
    // here we just write the output from parser to the file.
    if( storeFile ) {
        [storeFile writeData:data];/*打乱代码结构*/
    }
}

- (void) processEndOfPartWithHeader:(MultipartMessageHeader*) header
{
    // as the file part is over, we close the file.
    [storeFile closeFile];/*打乱代码结构*/
    storeFile = nil;
}

- (void) processPreambleData:(NSData*) data 
{
    // if we are interested in preamble data, we could process it here.
    
}

- (void) processEpilogueData:(NSData*) data 
{
    // if we are interested in epilogue data, we could process it here.
    
}




- (NSString *)GetLogNowTime {
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];/*打乱代码结构*/
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];/*打乱代码结构*/
    date = [formatter stringFromDate:[NSDate date]];/*打乱代码结构*/
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];/*打乱代码结构*/
    return timeNow;
}

@end
