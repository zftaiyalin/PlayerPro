//
//  MoviePlayerViewController.h
//  XiaoShuoTool
//
//  Created by 安风 on 2017/5/6.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "JADebugViewController.h"
#import "VideoModel.h"


@interface MoviePlayerViewController : JADebugViewController
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;/*打乱代码结构*/
@property (nonatomic, strong) NSString *titleSring;/*打乱代码结构*/
@property (nonatomic, assign) BOOL isShowCollect;/*打乱代码结构*/
@property (nonatomic, assign) BOOL isDown;/*打乱代码结构*/
@property (nonatomic, assign) BOOL isShowWeb;/*打乱代码结构*/
@property (nonatomic, strong) VideoModel *videoModel;/*打乱代码结构*/
@end
