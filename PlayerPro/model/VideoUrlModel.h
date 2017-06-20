//
//  VideoUrlModel.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatModel.h"
@interface VideoUrlModel : NSObject

@property(nonatomic,strong) NSString *url;
@property(nonatomic,assign) int ggintegral;
@property(nonatomic,assign) int wkintegral;
@property(nonatomic,assign) int firstintegral;
@property(nonatomic,assign) int refreshIndex;
@property(nonatomic,assign) int refreshintegral;
@property(nonatomic,assign) int downloadintegral;
@property(nonatomic,assign) int collectintegral;
@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSMutableArray *videoArray;
@end
