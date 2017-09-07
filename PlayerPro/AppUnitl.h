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

@property(nonatomic,strong) AppModel *model;/*打乱代码结构*/
@property(nonatomic,assign) _Bool isDownLoad;/*打乱代码结构*/
+ (AppUnitl *)sharedManager;/*打乱代码结构*/
- (NSDate *)getInternetDate;/*打乱代码结构*/
+(UIImage *)getImage:(NSString *)videoURL;/*打乱代码结构*/
+(NSString *)getTime:(NSString *)videoURL;/*打乱代码结构*/
-(NSString *)getStringToDate:(NSDate *)date;/*打乱代码结构*/
-(NSDate *)getDateToString:(NSString *)date;/*打乱代码结构*/
+ (long long) fileSizeAtPath:(NSString*) filePath;/*打乱代码结构*/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;/*打乱代码结构*/
+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;/*打乱代码结构*/
-(BOOL)getWatchQuanxian:(int)jian;/*打乱代码结构*/
-(void)addMyintegral:(int) jifen;/*打乱代码结构*/
-(int)getMyintegral;/*打乱代码结构*/
+(BOOL)addCodeToJifen:(NSArray *)dateArray;/*打乱代码结构*/
+(BOOL)getBoolMiMa;/*打乱代码结构*/
+(void)addStringMiMa:(NSString *)text;/*打乱代码结构*/
+(BOOL)getBOOLStringMiMa:(NSString *)text;/*打乱代码结构*/
@end
