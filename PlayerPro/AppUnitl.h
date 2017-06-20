//
//  AppUnitl.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"
@interface AppUnitl : NSObject

@property(nonatomic,strong) AppModel *model;
@property(nonatomic,assign) _Bool isDownLoad;
+ (AppUnitl *)sharedManager;
- (NSDate *)getInternetDate;
+(UIImage *)getImage:(NSString *)videoURL;
+(NSString *)getTime:(NSString *)videoURL;
-(NSString *)getStringToDate:(NSDate *)date;
-(NSDate *)getDateToString:(NSString *)date;
+ (long long) fileSizeAtPath:(NSString*) filePath;
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
-(BOOL)getWatchQuanxian:(int)jian;
-(void)addMyintegral:(int) jifen;
-(int)getMyintegral;
+(BOOL)addCodeToJifen:(NSArray *)dateArray;
+(BOOL)getBoolMiMa;
+(void)addStringMiMa:(NSString *)text;
+(BOOL)getBOOLStringMiMa:(NSString *)text;
@end
