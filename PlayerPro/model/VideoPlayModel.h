//
//  VideoPlayModel.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPlayModel : NSObject
@property(nonatomic,strong) NSString *baseurl;
@property(nonatomic,strong) NSString *videoTitle;
@property(nonatomic,strong) NSString *videoUrl;
@property(nonatomic,strong) NSString *searchUrlWord;
@property(nonatomic,strong) NSString *searchUrlPage;
@property(nonatomic,strong) NSString *searchUrlhouzui;
@property(nonatomic,strong) NSString *topUrl;
@property(nonatomic,assign) int vdieoMaxIndex;
@property(nonatomic,assign) BOOL isPron;
@end
