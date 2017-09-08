//
//  PassWordViewController.h
//  PlayerPro
//
//  Created by 曾富田 on 2017/9/8.
//  Copyright © 2017年 安风. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassWordDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)passWordSuccess;


@end

@interface PassWordViewController : UIViewController

@property (nonatomic,assign) BOOL isTop;
/** 设置代理 */
@property (nonatomic, weak) id<PassWordDelegate>      delegate;

@end
