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
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSString *titleSring;
@property (nonatomic, assign) BOOL isShowCollect;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isShowWeb;
@property (nonatomic, strong) VideoModel *videoModel;
@end
