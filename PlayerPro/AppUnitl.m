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
    static AppUnitl *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}


+(NSString *)getTime:(NSString *)videoURL{
    
    NSURL    *movieURL = [NSURL fileURLWithPath:videoURL];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    NSLog(@"movie duration : %f", second);
    int ss = (int)second;
    int seconds = ss % 60;
    int minutes = (ss / 60) % 60;
    int hours = ss / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


-(NSString *)getStringToDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

-(NSDate *)getDateToString:(NSString *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSDate转NSString
    NSDate *currentDateString = [dateFormatter dateFromString:date];
    
    return currentDateString;
}


+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        return NO;
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
        return NO;
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
        
        if (minute > 15) {
            return NO;
        }else{
            return YES;
        }
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
        return YES;
    }
}

/**
 
 *  获取网络当前时间
 
 */

- (NSDate *)getInternetDate

{
    
    NSString *urlString = @"http://m.baidu.com";
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:nil];
    
    
    
    // 处理返回的数据
    
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    
    NSLog(@"response is %@",response);
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    
    date = [date substringToIndex:[date length]-4];
    
    
    
    
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    
    
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    return netDate;
    
}

-(BOOL)getWatchQuanxian:(int)jian{
    NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];
    
    int jj = jifen.intValue;
    
    
    if (jj >= jian) {
        jj -= jian;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
-(void)addMyintegral:(int) jifen{
//    self.model.video.ggintegral
    
     NSString *jifens = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];
    
    int jj = jifens.intValue;
    
    jj += jifen;
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(int)getMyintegral{
    NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];
    
    return jifen.intValue;
}
+(BOOL)getBoolMiMa{
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"mymima"];
    
    if (jifen == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"mymima"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }else{
        if ([jifen isEqualToString:@"0"]) {
            return NO;
        }else{
            return YES;
        }
    }
}

+(void)addStringMiMa:(NSString *)text{

    [[NSUserDefaults standardUserDefaults]setObject:text forKey:@"mymima"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBOOLStringMiMa:(NSString *)text{
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"mymima"];
    if ([jifen isEqualToString:text]) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)addCodeToJifen:(NSArray *)dateArray{
    NSString *dateNow= dateArray.firstObject;
    NSString *jifenss = dateArray.lastObject;
    
    
    NSData *dataa = [[NSUserDefaults standardUserDefaults] objectForKey:@"jifencode"];
    
    if (dataa == nil) {
        NSMutableArray *array = [NSMutableArray array];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"jifencode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"jifencode"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    BOOL isGuoqi = NO;
    for (NSString *string in arr) {
        if ([dateNow isEqualToString:string]) {
            isGuoqi = YES;
            break;
        }
    }
    
    if (isGuoqi) {
        return NO;
    }else{
        [arr addObject:dateNow];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"jifencode"];
        
        NSString *jifen = [[NSUserDefaults standardUserDefaults]objectForKey:@"myintegral"];
        
        int jj = jifen.intValue;
        
        jj += jifenss.intValue;
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",jj] forKey:@"myintegral"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    
        return YES;
    }

    
    
}
@end
