//
//  ZFPlayerControlView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "NSObject+ALiHUD.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat ZFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZFPlayerControlView () <UIGestureRecognizerDelegate>

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;

/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray                 *resolutionArray;

/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;

@end

@implementation ZFPlayerControlView

- (instancetype)init {
    self = [super init];/*打乱代码结构*/
    if (self) {

        [self addSubview:self.placeholderImageView];/*打乱代码结构*/
        [self addSubview:self.topImageView];/*打乱代码结构*/
        [self addSubview:self.bottomImageView];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.startBtn];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.currentTimeLabel];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.progressView];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.videoSlider];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.fullScreenBtn];/*打乱代码结构*/
        [self.bottomImageView addSubview:self.totalTimeLabel];/*打乱代码结构*/
        
        [self.topImageView addSubview:self.downLoadBtn];/*打乱代码结构*/
//        [self.topImageView addSubview:self.collectBtn];/*打乱代码结构*/
        [self addSubview:self.lockBtn];/*打乱代码结构*/
        [self.topImageView addSubview:self.backBtn];/*打乱代码结构*/
        [self addSubview:self.activity];/*打乱代码结构*/
        [self addSubview:self.repeatBtn];/*打乱代码结构*/
        [self addSubview:self.playeBtn];/*打乱代码结构*/
        [self addSubview:self.failBtn];/*打乱代码结构*/
        
        [self addSubview:self.fastView];/*打乱代码结构*/
        [self.fastView addSubview:self.fastImageView];/*打乱代码结构*/
        [self.fastView addSubview:self.fastTimeLabel];/*打乱代码结构*/
        [self.fastView addSubview:self.fastProgressView];/*打乱代码结构*/
        
        [self.topImageView addSubview:self.resolutionBtn];/*打乱代码结构*/
        [self.topImageView addSubview:self.titleLabel];/*打乱代码结构*/
        [self addSubview:self.closeBtn];/*打乱代码结构*/
        [self addSubview:self.bottomProgressView];/*打乱代码结构*/
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];/*打乱代码结构*/
        
        self.downLoadBtn.hidden     = YES;
        self.resolutionBtn.hidden   = YES;
        // 初始化时重置controlView
        [self zf_playerResetControlView];/*打乱代码结构*/
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];/*打乱代码结构*/
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];/*打乱代码结构*/

        [self listeningRotating];/*打乱代码结构*/
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];/*打乱代码结构*/
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];/*打乱代码结构*/
}

- (void)makeSubViewsConstraints {
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];/*打乱代码结构*/
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
    }];/*打乱代码结构*/
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(50);
    }];/*打乱代码结构*/
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.width.height.mas_equalTo(40);
    }];/*打乱代码结构*/

    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];/*打乱代码结构*/
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.right.equalTo(self.downLoadBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];/*打乱代码结构*/

    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
        make.trailing.equalTo(self.downLoadBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];/*打乱代码结构*/
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.trailing.equalTo(self.resolutionBtn.mas_leading).offset(-10);
    }];/*打乱代码结构*/
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];/*打乱代码结构*/
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];/*打乱代码结构*/
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];/*打乱代码结构*/
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];/*打乱代码结构*/
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];/*打乱代码结构*/
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];/*打乱代码结构*/
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];/*打乱代码结构*/
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];/*打乱代码结构*/
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self);
    }];/*打乱代码结构*/
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];/*打乱代码结构*/
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];/*打乱代码结构*/
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];/*打乱代码结构*/
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];/*打乱代码结构*/
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];/*打乱代码结构*/
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];/*打乱代码结构*/
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];/*打乱代码结构*/
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];/*打乱代码结构*/
}

- (void)layoutSubviews {
    [super layoutSubviews];/*打乱代码结构*/
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];/*打乱代码结构*/
    } else {
        [self setOrientationLandscapeConstraint];/*打乱代码结构*/
    }
}

#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    sender.selected = YES;
    if (sender.isSelected) {
        sender.backgroundColor = RGBA(86, 143, 232, 1);
    } else {
        sender.backgroundColor = [UIColor clearColor];/*打乱代码结构*/
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];/*打乱代码结构*/
    self.resoultionCurrentBtn = sender;
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];/*打乱代码结构*/
    if ([self.delegate respondsToSelector:@selector(zf_controlView:resolutionAction:)]) {
        [self.delegate zf_controlView:self resolutionAction:sender];/*打乱代码结构*/
    }
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];/*打乱代码结构*/
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
            [self.delegate zf_controlView:self progressSliderTap:tapValue];/*打乱代码结构*/
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)backBtnClick:(UIButton *)sender {
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
            [self.delegate zf_controlView:self closeAction:sender];/*打乱代码结构*/
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
            [self.delegate zf_controlView:self backAction:sender];/*打乱代码结构*/
        }
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showing = NO;
    [self zf_playerShowControlView];/*打乱代码结构*/
    if ([self.delegate respondsToSelector:@selector(zf_controlView:lockScreenAction:)]) {
        [self.delegate zf_controlView:self lockScreenAction:sender];/*打乱代码结构*/
    }
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:sender];/*打乱代码结构*/
    }
}

- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
        [self.delegate zf_controlView:self closeAction:sender];/*打乱代码结构*/
    }
}

-(void)collectBtnClick:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(zf_controlView:collectAction:)]) {
//        [self.delegate zf_controlView:self collectAction:sender];/*打乱代码结构*/
//    }
    
//    if ([[AppUnitl sharedManager] getWatchQuanxian:[AppUnitl sharedManager].model.video.collectintegral]) {
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"mycollection"];/*打乱代码结构*/
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];/*打乱代码结构*/
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];/*打乱代码结构*/
        if (self.isCollect) {
            int index = 0;
            for (VideoModel *model in arr) {
                if ([model.url isEqualToString:self.videoModel.url]) {
                    break;
                }
                index ++;
            }
            
            [arr removeObjectAtIndex:index];/*打乱代码结构*/
            [self.collectBtn setImage:[UIImage imageNamed:@"unsoucang.png"] forState:UIControlStateNormal];/*打乱代码结构*/
        }else{
            [arr addObject:self.videoModel];/*打乱代码结构*/
            [self.collectBtn setImage:[UIImage imageNamed:@"soucang.png"] forState:UIControlStateNormal];/*打乱代码结构*/
        }
        
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];/*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"mycollection"];/*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*/
        [MobClick event:@"收藏视频"];/*打乱代码结构*/
//        [self showSuccessText:[NSString stringWithFormat:@"收藏成功,扣除%d积分",[AppUnitl sharedManager].model.video.collectintegral]];/*打乱代码结构*/
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissLoading];/*打乱代码结构*/
        });
//    }else{
//        
//        [self showErrorText:[NSString stringWithFormat:@"收藏失败,需要%d积分",[AppUnitl sharedManager].model.video.collectintegral]];/*打乱代码结构*/
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismissLoading];/*打乱代码结构*/
//        });
//    
//    }
    
    
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:fullScreenAction:)]) {
        [self.delegate zf_controlView:self fullScreenAction:sender];/*打乱代码结构*/
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self zf_playerResetControlView];/*打乱代码结构*/
    [self zf_playerShowControlView];/*打乱代码结构*/
    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
        [self.delegate zf_controlView:self repeatPlayAction:sender];/*打乱代码结构*/
    }
}

- (void)downloadBtnClick:(UIButton *)sender {
    
    if (AppUnitl.sharedManager.isDownLoad) {
        [MobClick event:@"下载视频"];/*打乱代码结构*/
        if ([self.delegate respondsToSelector:@selector(zf_controlView:downloadVideoAction:)]) {
            [self.delegate zf_controlView:self downloadVideoAction:sender];/*打乱代码结构*/
        }
    }else{
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"您的版本不是VIP版本，下载VIP版可提供下载功能，尽享免广告观看!" delegate:self   cancelButtonTitle:@"取消" otherButtonTitles:@"下载",nil];/*打乱代码结构*/
        [infoAlert show];/*打乱代码结构*/
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MobClick event:@"前往微信"];/*打乱代码结构*/
        
        NSString *str = @"weixin:/";
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];/*打乱代码结构*/
    }
}
- (void)resolutionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
}

- (void)centerPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:cneterPlayAction:)]) {
        [self.delegate zf_controlView:self cneterPlayAction:sender];/*打乱代码结构*/
    }
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:failAction:)]) {
        [self.delegate zf_controlView:self failAction:sender];/*打乱代码结构*/
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];/*打乱代码结构*/
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];/*打乱代码结构*/
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];/*打乱代码结构*/
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];/*打乱代码结构*/
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    [self zf_playerCancelAutoFadeOutControlView];/*打乱代码结构*/
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    if (!self.isShrink) { [self zf_playerShowControlView];/*打乱代码结构*/ }
}

- (void)playerPlayDidEnd {
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zf_playerShowControlView];/*打乱代码结构*/
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (ZFPlayerShared.isLockScreen) { return; }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (!self.isShrink && !self.isPlayEnd && !self.showing) {
        // 显示、隐藏控制层
        [self zf_playerShowOrHideControlView];/*打乱代码结构*/
    }
}

- (void)setOrientationLandscapeConstraint {
    if (self.isCellVideo) {
        self.shrink             = NO;
    }
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];/*打乱代码结构*/
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(23);
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.width.height.mas_equalTo(40);
    }];/*打乱代码结构*/
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.width.height.mas_equalTo(40);
    }];/*打乱代码结构*/

    if (self.isCellVideo) {
        [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];/*打乱代码结构*/
    }
}

#pragma mark - Private Method

- (void)showControlView {
    self.showing = YES;
    if (self.lockBtn.isSelected) {
        self.topImageView.alpha    = 0;
        self.bottomImageView.alpha = 0;
    } else {
        self.topImageView.alpha    = 1;
        self.bottomImageView.alpha = 1;
    }
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
    if (self.isCellVideo) {
        self.shrink                = NO;
    }
    self.bottomProgressView.alpha  = 0;
    ZFPlayerShared.isStatusBarHidden = NO;
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.lockBtn.alpha            = 0;
    self.bottomProgressView.alpha = 1;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionBtnClick:self.resolutionBtn];/*打乱代码结构*/
    if (self.isFullScreen && !self.playeEnd && !self.isShrink) {
        ZFPlayerShared.isStatusBarHidden = YES;
    }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];/*打乱代码结构*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];/*打乱代码结构*/
}


- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_playerHideControlView) object:nil];/*打乱代码结构*/
    [self performSelector:@selector(zf_playerHideControlView) withObject:nil afterDelay:ZFPlayerAnimationTimeInterval];/*打乱代码结构*/
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];/*打乱代码结构*/
}

#pragma mark - setter

- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.closeBtn.hidden = !shrink;
    self.bottomProgressView.hidden = shrink;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    ZFPlayerShared.isLandscape = fullScreen;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];/*打乱代码结构*/
        _titleLabel.textColor = [UIColor whiteColor];/*打乱代码结构*/
        _titleLabel.font = [UIFont systemFontOfSize:15.0];/*打乱代码结构*/
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];/*打乱代码结构*/
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];/*打乱代码结构*/
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 0;
        _topImageView.image                  = ZFPlayerImage(@"ZFPlayer_top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];/*打乱代码结构*/
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 0;
        _bottomImageView.image                  = ZFPlayerImage(@"ZFPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];/*打乱代码结构*/
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];/*打乱代码结构*/
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/

    }
    return _lockBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_startBtn setImage:ZFPlayerImage(@"ZFPlayer_play") forState:UIControlStateNormal];/*打乱代码结构*/
        [_startBtn setImage:ZFPlayerImage(@"ZFPlayer_pause") forState:UIControlStateSelected];/*打乱代码结构*/
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _startBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_closeBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];/*打乱代码结构*/
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _closeBtn;
}


- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_collectBtn setImage:[UIImage imageNamed:@"unsoucang.png"] forState:UIControlStateNormal];/*打乱代码结构*/
        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _collectBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];/*打乱代码结构*/
        _currentTimeLabel.textColor     = [UIColor whiteColor];/*打乱代码结构*/
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];/*打乱代码结构*/
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];/*打乱代码结构*/
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];/*打乱代码结构*/
        _progressView.trackTintColor    = [UIColor clearColor];/*打乱代码结构*/
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];/*打乱代码结构*/
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;

        [_videoSlider setThumbImage:ZFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];/*打乱代码结构*/
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];/*打乱代码结构*/
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];/*打乱代码结构*/
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];/*打乱代码结构*/
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];/*打乱代码结构*/
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];/*打乱代码结构*/
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];/*打乱代码结构*/
        [_videoSlider addGestureRecognizer:sliderTap];/*打乱代码结构*/
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];/*打乱代码结构*/
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];/*打乱代码结构*/
        [panRecognizer setDelaysTouchesBegan:YES];/*打乱代码结构*/
        [panRecognizer setDelaysTouchesEnded:YES];/*打乱代码结构*/
        [panRecognizer setCancelsTouchesInView:YES];/*打乱代码结构*/
        [_videoSlider addGestureRecognizer:panRecognizer];/*打乱代码结构*/
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];/*打乱代码结构*/
        _totalTimeLabel.textColor     = [UIColor whiteColor];/*打乱代码结构*/
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];/*打乱代码结构*/
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_fullScreenBtn setImage:ZFPlayerImage(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];/*打乱代码结构*/
        [_fullScreenBtn setImage:ZFPlayerImage(@"ZFPlayer_shrinkscreen") forState:UIControlStateSelected];/*打乱代码结构*/
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _fullScreenBtn;
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];/*打乱代码结构*/
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];/*打乱代码结构*/
    }
    return _activity;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_repeatBtn setImage:ZFPlayerImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];/*打乱代码结构*/
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _repeatBtn;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_downLoadBtn setImage:ZFPlayerImage(@"ZFPlayer_download") forState:UIControlStateNormal];/*打乱代码结构*/
        [_downLoadBtn setImage:ZFPlayerImage(@"ZFPlayer_not_download") forState:UIControlStateDisabled];/*打乱代码结构*/
        [_downLoadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _downLoadBtn;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];/*打乱代码结构*/
        _resolutionBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _resolutionBtn;
}

- (UIButton *)playeBtn {
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        [_playeBtn setImage:ZFPlayerImage(@"ZFPlayer_play_btn") forState:UIControlStateNormal];/*打乱代码结构*/
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _playeBtn;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];/*打乱代码结构*/
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];/*打乱代码结构*/
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];/*打乱代码结构*/
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];/*打乱代码结构*/
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
    return _failBtn;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];/*打乱代码结构*/
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];/*打乱代码结构*/
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];/*打乱代码结构*/
        _fastTimeLabel.textColor     = [UIColor whiteColor];/*打乱代码结构*/
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];/*打乱代码结构*/
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];/*打乱代码结构*/
        _fastProgressView.progressTintColor = [UIColor whiteColor];/*打乱代码结构*/
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];/*打乱代码结构*/
    }
    return _fastProgressView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];/*打乱代码结构*/
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView                   = [[UIProgressView alloc] init];/*打乱代码结构*/
        _bottomProgressView.progressTintColor = [UIColor whiteColor];/*打乱代码结构*/
        _bottomProgressView.trackTintColor    = [UIColor clearColor];/*打乱代码结构*/
    }
    return _bottomProgressView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];/*打乱代码结构*/
    CGPoint point = [touch locationInView:self.videoSlider];/*打乱代码结构*/
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView {
    [self.activity stopAnimating];/*打乱代码结构*/
    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];/*打乱代码结构*/
    self.downLoadBtn.enabled         = YES;
    self.collectBtn.enabled         = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = !self.isFullScreen;
    self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
    [self hideControlView];/*打乱代码结构*/
}

- (void)zf_playerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.repeatBtn.hidden       = YES;
    self.resolutionView.hidden  = YES;
    self.playeBtn.hidden        = YES;
    self.downLoadBtn.enabled    = YES;
    self.collectBtn.enabled         = YES;
    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];/*打乱代码结构*/
    self.shrink                 = NO;
    self.showing                = NO;
    self.playeEnd               = NO;
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];/*打乱代码结构*/
}

/** 设置播放模型 */
- (void)zf_playerModel:(ZFPlayerModel *)playerModel {

    if (playerModel.title) { self.titleLabel.text = playerModel.title; }
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        [self.placeholderImageView setImageWithURLString:playerModel.placeholderImageURLString placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];/*打乱代码结构*/
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
    if (playerModel.resolutionDic) {
        [self zf_playerResolutionArray:[playerModel.resolutionDic allKeys]];/*打乱代码结构*/
    }
}

/** 正在播放（隐藏placeholderImageView） */
- (void)zf_playerItemPlaying {
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];/*打乱代码结构*/
}

- (void)zf_playerShowOrHideControlView {
    if (self.isShowing) {
        [self zf_playerHideControlView];/*打乱代码结构*/
    } else {
        [self zf_playerShowControlView];/*打乱代码结构*/
    }
}
/**
 *  显示控制层
 */
- (void)zf_playerShowControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillShow:isFullscreen:)]) {
        [self.delegate zf_controlViewWillShow:self isFullscreen:self.isFullScreen];/*打乱代码结构*/
    }
    [self zf_playerCancelAutoFadeOutControlView];/*打乱代码结构*/
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];/*打乱代码结构*/
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];/*打乱代码结构*/
    }];/*打乱代码结构*/
}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillHidden:isFullscreen:)]) {
        [self.delegate zf_controlViewWillHidden:self isFullscreen:self.isFullScreen];/*打乱代码结构*/
    }
    [self zf_playerCancelAutoFadeOutControlView];/*打乱代码结构*/
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];/*打乱代码结构*/
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];/*打乱代码结构*/
}

/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay {
    self.shrink = YES;
    [self hideControlView];/*打乱代码结构*/
}

/** 在cell播放 */
- (void)zf_playerCellPlay {
    self.cellVideo = YES;
    self.shrink    = NO;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];/*打乱代码结构*/
}

- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];/*打乱代码结构*/
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];/*打乱代码结构*/
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];/*打乱代码结构*/
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];/*打乱代码结构*/
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];/*打乱代码结构*/
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];/*打乱代码结构*/
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_backward");
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;

}

- (void)zf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];/*打乱代码结构*/
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];/*打乱代码结构*/
    [self.videoSlider setImage:image];/*打乱代码结构*/
    [self.videoSlider setText:currentTimeStr];/*打乱代码结构*/
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)zf_playerSetProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:NO];/*打乱代码结构*/
}

/** 视频加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];/*打乱代码结构*/
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];/*打乱代码结构*/
    }
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];/*打乱代码结构*/
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    ZFPlayerShared.isStatusBarHidden = NO;
    self.bottomProgressView.alpha = 0;
}

/** 
 是否有下载功能 
 */
- (void)zf_playerHasDownloadFunction:(BOOL)sender {
    self.downLoadBtn.hidden = !sender;
}

/**
 是否有切换分辨率功能
 */
- (void)zf_playerResolutionArray:(NSArray *)resolutionArray {
    self.resolutionBtn.hidden = NO;
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];/*打乱代码结构*/
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];/*打乱代码结构*/
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.7);
    [self addSubview:self.resolutionView];/*打乱代码结构*/
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom).offset(0);
    }];/*打乱代码结构*/
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*/
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 25*i, 40, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];/*打乱代码结构*/
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];/*打乱代码结构*/
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = RGBA(86, 143, 232, 1);
        }
        [self.resolutionView addSubview:btn];/*打乱代码结构*/
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*/
    }
}

/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
}

/** 锁定屏幕方向按钮状态 */
- (void)zf_playerLockBtnState:(BOOL)state {
    self.lockBtn.selected = state;
}

/** 下载按钮状态 */
- (void)zf_playerDownloadBtnState:(BOOL)state {
    self.downLoadBtn.enabled = state;
}

#pragma clang diagnostic pop

@end
