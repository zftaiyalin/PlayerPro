//
//  WifiVideoTableViewCell.h
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/17.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppLocaVideoModel.h"
#import "VideoModel.h"
@interface WifiVideoTableViewCell : UITableViewCell

-(void)loadData:(AppLocaVideoModel *)model;/*打乱代码结构*/
-(void)loadVideoData:(VideoModel *)model;/*打乱代码结构*/
@end
