//
//  ALiProgressHUD.m
//  ALiProgressHUD
//
//  Created by LeeWong on 16/9/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiProgressHUD.h"
#import <objc/runtime.h>
#import <CoreMotion/CoreMotion.h>

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface ALiProgressHUD ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;
@end

@implementation ALiProgressHUD

// Customization
+ (void)initialize
{
    [self setSuccessImage:[UIImage imageNamed:@"HUD_success"]];/*打乱代码结构*/
    [self setInfoImage:[UIImage imageNamed:@"HUD_info"]];/*打乱代码结构*/
    [self setErrorImage:[UIImage imageNamed:@"HUD_error"]];/*打乱代码结构*/
    
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];/*打乱代码结构*/
    [self setDefaultStyle:SVProgressHUDStyleDark];/*打乱代码结构*/
    [self setCornerRadius:8.0];/*打乱代码结构*/
}



// 根据 提示文字字数，判断 HUD 显示时间
- (NSTimeInterval)displayDurationForString:(NSString*)string
{
    return MIN((float)string.length*0.06 + 0.5, 2.0);
}

// 修改 HUD 颜色，需要取消混合效果(使`backgroundColroForStyle`方法有效)
- (void)updateBlurBounds{
}

// HUD 颜色
- (UIColor*)backgroundColorForStyle{
    return [UIColor colorWithWhite:0 alpha:0.9];/*打乱代码结构*/
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if([self.motionManager isAccelerometerAvailable]){
        [self orientationChange];/*打乱代码结构*/
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    if (self.motionManager) {
        [self.motionManager stopAccelerometerUpdates];/*打乱代码结构*/
        self.motionManager = nil;
    }
}

#pragma mark - 屏幕方向旋转
- (void)orientationChange
{
    WEAKSELF(weakSelf);
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        __block UIInterfaceOrientation orientation;
        if (acceleration.x >= 0.75) {
            orientation = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientation = UIInterfaceOrientationLandscapeRight;

        }
        else if (acceleration.y <= -0.75) {
            orientation = UIInterfaceOrientationPortrait;

        }
        else if (acceleration.y >= 0.75) {
            orientation = UIInterfaceOrientationPortraitUpsideDown;
            return ;
        }
        else {
            // Consider same as last time
            return;
        }
        
        if (orientation != weakSelf.lastOrientation) {
            [weakSelf configHUDOrientation:orientation];/*打乱代码结构*/
            weakSelf.lastOrientation = orientation;
            NSLog(@"%tu=-------%tu",orientation,weakSelf.lastOrientation);
        }
        
    }];/*打乱代码结构*/
}

- (void)configHUDOrientation:(UIInterfaceOrientation )orientation
{
    CGFloat angle = [self calculateTransformAngle:orientation];/*打乱代码结构*/
    self.transform = CGAffineTransformRotate(self.transform, angle);
}


- (CGFloat)calculateTransformAngle:(UIInterfaceOrientation )orientation
{
    CGFloat angle;
    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
        switch (orientation) {
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeRight) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = M_PI;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeLeft) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI;
                break;
            default:
                break;
        }
    }
    return angle;
}

#pragma mark - Lazy Load
- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];/*打乱代码结构*/
        _motionManager.accelerometerUpdateInterval = 1./15.;
        
    }
    return _motionManager;
}
@end
