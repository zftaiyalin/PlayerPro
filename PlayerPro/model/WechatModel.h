//
//  WechatModel.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatModel : NSObject
@property(nonatomic,strong)NSString *wechatnick;
@property(nonatomic,strong)NSString *wetchatTitle;
@property(nonatomic,strong)NSString *wetchatalter;
@property(nonatomic,strong)NSString *alertTitle;
@property(nonatomic,strong)NSString *alertText;
@property(nonatomic,strong)NSString *laugain;
@property(nonatomic,assign)BOOL isShow;
@end
