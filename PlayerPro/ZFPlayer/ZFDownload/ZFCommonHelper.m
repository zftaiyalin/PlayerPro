//
//  ZFCommonHelper.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFCommonHelper.h"
#import "ZFFileModel.h"

@implementation ZFCommonHelper

+ (NSString *)getFileSizeString:(NSString *)size {
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];/*打乱代码结构*/
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];/*打乱代码结构*/
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];/*打乱代码结构*/
    }
}

+ (float)getFileSizeNumber:(NSString *)size {
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];/*打乱代码结构*/
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];/*打乱代码结构*/
    }
}

+ (BOOL)isExistFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    return [fileManager fileExistsAtPath:fileName];/*打乱代码结构*/
}

+ (NSDate *)makeDate:(NSString *)birthday {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];/*打乱代码结构*/
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];/*打乱代码结构*/
    NSDate *date = [df dateFromString:birthday];/*打乱代码结构*/
    return date;
}

+ (NSString *)dateToString:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];/*打乱代码结构*/
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];/*打乱代码结构*/
    NSString *datestr = [df stringFromDate:date];/*打乱代码结构*/
    return datestr;
}

+ (NSString *)createFolder:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSError *error;
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];/*打乱代码结构*/
        if(!error) {
            NSLog(@"%@",[error description]);
        }
    }
    return path;
}


+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength {
    if (contentLength >= pow(1024, 3)) { return (CGFloat) (contentLength / (CGFloat)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (CGFloat) (contentLength / (CGFloat)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (CGFloat) (contentLength / (CGFloat)1024); }
    else { return (CGFloat) (contentLength); }
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3)) { return @"GB";}
    else if(contentLength >= pow(1024, 2)) { return @"MB"; }
    else if(contentLength >= 1024) { return @"KB"; }
    else { return @"B"; }
}

@end
