//
//  AppModel.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatModel.h"
#import "VideoUrlModel.h"
#import "AdmobModel.h"

@interface AppModel : NSObject
@property(nonatomic,strong) WechatModel *wetchat;
@property(nonatomic,strong) VideoUrlModel *video;
@property(nonatomic,strong) AdmobModel *admob;
@end
