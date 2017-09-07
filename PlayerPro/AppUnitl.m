//
//  AppUnitl.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "AppUnitl.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppUnitl
+ (AppUnitl *)sharedManager
{
    static AppUnitl *sharedAccountManagerInstance = nil;/*打乱代码结构*/
    static dispatch_once_t predicate;/*打乱代码结构*/
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];/*打乱代码结构*//*打乱代码结构*/
    });/*打乱代码结构*/
    return sharedAccountManagerInstance;/*打乱代码结构*/
}
+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];/*打乱代码结构*//*打乱代码结构*/
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];/*打乱代码结构*//*打乱代码结构*/
    gen.appliesPreferredTrackTransform = YES;/*打乱代码结构*/
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);/*打乱代码结构*/
    NSError *error = nil;/*打乱代码结构*/
    CMTime actualTime;/*打乱代码结构*/
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];/*打乱代码结构*//*打乱代码结构*/
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];/*打乱代码结构*//*打乱代码结构*/
    CGImageRelease(image);/*打乱代码结构*/
    return thumb;/*打乱代码结构*/
    
}


+(NSString *)getTime:(NSString *)videoURL{
    
    NSURL    *movieURL = [NSURL fileURLWithPath:videoURL];/*打乱代码结构*//*打乱代码结构*/
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];/*打乱代码结构*//*打乱代码结构*/
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];/*打乱代码结构*//*打乱代码结构*/
    float second = 0;/*打乱代码结构*/
    second = urlAsset.duration.value/urlAsset.duration.timescale;/*打乱代码结构*/
    NSLog(@"movie duration : %f", second);/*打乱代码结构*/
    int ss = (int)second;/*打乱代码结构*/
    int seconds = ss % 60;/*打乱代码结构*/
    int minutes = (ss / 60) % 60;/*打乱代码结构*/
    int hours = ss / 3600;/*打乱代码结构*/
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];/*打乱代码结构*//*打乱代码结构*/
}
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];/*打乱代码结构*//*打乱代码结构*/
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];/*打乱代码结构*//*打乱代码结构*/
    }
    return 0;/*打乱代码结构*/
}


-(NSString *)getStringToDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*//*打乱代码结构*/
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];/*打乱代码结构*//*打乱代码结构*/
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];/*打乱代码结构*//*打乱代码结构*/
    
    return currentDateString;/*打乱代码结构*/
}

-(NSDate *)getDateToString:(NSString *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*//*打乱代码结构*/
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];/*打乱代码结构*//*打乱代码结构*/
    //NSDate转NSString
    NSDate *currentDateString = [dateFormatter dateFromString:date];/*打乱代码结构*//*打乱代码结构*/
    
    return currentDateString;/*打乱代码结构*/
}


+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*//*打乱代码结构*/
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];/*打乱代码结构*//*打乱代码结构*/
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];/*打乱代码结构*//*打乱代码结构*/
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];/*打乱代码结构*//*打乱代码结构*/
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];/*打乱代码结构*//*打乱代码结构*/
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];/*打乱代码结构*//*打乱代码结构*/
    NSComparisonResult result = [dateA compare:dateB];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);/*打乱代码结构*/
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");/*打乱代码结构*/
        return 1;/*打乱代码结构*/
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");/*打乱代码结构*/
        return -1;/*打乱代码结构*/
    }
    //NSLog(@"Both dates are the same");/*打乱代码结构*/
    return 0;/*打乱代码结构*/
    
}


+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];/*打乱代码结构*//*打乱代码结构*/
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];/*打乱代码结构*//*打乱代码结构*/
    NSDate *startD =[date dateFromString:startTime];/*打乱代码结构*//*打乱代码结构*/
    NSDate *endD = [date dateFromString:endTime];/*打乱代码结构*//*打乱代码结构*/
    NSTimeInterval start = [startD timeIntervalSince1970]*1;/*打乱代码结构*/
    NSTimeInterval end = [endD timeIntervalSince1970]*1;/*打乱代码结构*/
    NSTimeInterval value = end - start;/*打乱代码结构*/
    int second = (int)value %60;/*打乱代码结构*///秒
    int minute = (int)value /60%60;/*打乱代码结构*/
    int house = (int)value / (24 * 3600)%3600;/*打乱代码结构*/
    int day = (int)value / (24 * 3600);/*打乱代码结构*/
    NSString *str;/*打乱代码结构*/
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];/*打乱代码结构*//*打乱代码结构*/
        return NO;/*打乱代码结构*/
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];/*打乱代码结构*//*打乱代码结构*/
        return NO;/*打乱代码结构*/
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];/*打乱代码结构*//*打乱代码结构*/
        
        if (minute > 15) {
            return NO;/*打乱代码结构*/
        }else{
            return YES;/*打乱代码结构*/
        }
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];/*打乱代码结构*//*打乱代码结构*/
        return YES;/*打乱代码结构*/
    }
}

/**
 
 *  获取网络当前时间
 
 */

- (NSDate *)getInternetDate

{
    
    NSString *urlString = @"http://m.baidu.com";/*打乱代码结构*/
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];/*打乱代码结构*//*打乱代码结构*/
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];/*打乱代码结构*//*打乱代码结构*/
    
    [request setURL:[NSURL URLWithString: urlString]];/*打乱代码结构*//*打乱代码结构*/
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];/*打乱代码结构*//*打乱代码结构*/
    
    [request setTimeoutInterval: 2];/*打乱代码结构*//*打乱代码结构*/
    
    [request setHTTPShouldHandleCookies:FALSE];/*打乱代码结构*//*打乱代码结构*/
    
    [request setHTTPMethod:@"GET"];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    NSHTTPURLResponse *response;/*打乱代码结构*/
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:nil];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    // 处理返回的数据
    
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    NSLog(@"response is %@",response);/*打乱代码结构*/
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];/*打乱代码结构*//*打乱代码结构*/
    
    date = [date substringFromIndex:5];/*打乱代码结构*//*打乱代码结构*/
    
    date = [date substringToIndex:[date length]-4];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];/*打乱代码结构*//*打乱代码结构*/
    
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];/*打乱代码结构*//*打乱代码结构*/
    
    return netDate;/*打乱代码结构*/
    
}

-(BOOL)getWatchQuanxian:(int)jian{
    NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
    
    int jj = jifen.intValue;/*打乱代码结构*/
    
    
    if (jj >= jian) {
        jj -= jian;/*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
        return YES;/*打乱代码结构*/
    }else{
        return NO;/*打乱代码结构*/
    }
}
-(void)addMyintegral:(int) jifen{
//    self.model.video.ggintegral
    
     NSString *jifens = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
    
    int jj = jifens.intValue;/*打乱代码结构*/
    
    jj += jifen;/*打乱代码结构*/
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
    [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/

}

-(int)getMyintegral{
    NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
    
    return jifen.intValue;/*打乱代码结构*/
}
+(BOOL)getBoolMiMa{
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"mymima"];/*打乱代码结构*//*打乱代码结构*/
    
    if (jifen == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"mymima"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
        return NO;/*打乱代码结构*/
    }else{
        if ([jifen isEqualToString:@"0"]) {
            return NO;/*打乱代码结构*/
        }else{
            return YES;/*打乱代码结构*/
        }
    }
}

+(void)addStringMiMa:(NSString *)text{

    [[NSUserDefaults standardUserDefaults]setObject:text forKey:@"mymima"];/*打乱代码结构*//*打乱代码结构*/
    [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
}

+(BOOL)getBOOLStringMiMa:(NSString *)text{
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"mymima"];/*打乱代码结构*//*打乱代码结构*/
    if ([jifen isEqualToString:text]) {
        return YES;/*打乱代码结构*/
    }else{
        return NO;/*打乱代码结构*/
    }
}
+(BOOL)addCodeToJifen:(NSArray *)dateArray{
    NSString *dateNow= dateArray.firstObject;/*打乱代码结构*/
    NSString *jifenss = dateArray.lastObject;/*打乱代码结构*/
    
    
    NSData *dataa = [[NSUserDefaults standardUserDefaults] objectForKey:@"jifencode"];/*打乱代码结构*//*打乱代码结构*/
    
    if (dataa == nil) {
        NSMutableArray *array = [NSMutableArray array];/*打乱代码结构*//*打乱代码结构*/
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:array];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"jifencode"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"jifencode"];/*打乱代码结构*//*打乱代码结构*/
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];/*打乱代码结构*//*打乱代码结构*/
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];/*打乱代码结构*//*打乱代码结构*/
    BOOL isGuoqi = NO;/*打乱代码结构*/
    for (NSString *string in arr) {
        if ([dateNow isEqualToString:string]) {
            isGuoqi = YES;/*打乱代码结构*/
            break;/*打乱代码结构*/
        }
    }
    
    if (isGuoqi) {
        return NO;/*打乱代码结构*/
    }else{
        [arr addObject:dateNow];/*打乱代码结构*//*打乱代码结构*/
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"jifencode"];/*打乱代码结构*//*打乱代码结构*/
        
        NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
        
        int jj = jifen.intValue;/*打乱代码结构*/
        
        jj += jifenss.intValue;/*打乱代码结构*/
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
        
    
        return YES;/*打乱代码结构*/
    }

    
    
}
@end
