//
//  MoviePlayerViewController.m
//  XiaoShuoTool
//
//  Created by 安风 on 2017/5/6.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoModel.h"
#import "ZFDownloadManager.h"
#import "ZFPlayer.h"
#import "UINavigationController+ZFFullscreenPopGesture.h"

@interface MoviePlayerViewController ()<ZFPlayerDelegate>

@property (strong, nonatomic) UIView *playerFatherView;/*打乱代码结构*/
@property (strong, nonatomic) ZFPlayerView *playerView;/*打乱代码结构*/
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;/*打乱代码结构*/
@property (nonatomic, strong) ZFPlayerModel *playerModel;/*打乱代码结构*/
@property (nonatomic, strong) UIView *bottomView;/*打乱代码结构*/
@property(nonatomic,strong)UIWebView *webView;/*打乱代码结构*/
//@property (strong, nonatomic) UIButton *backBtn;/*打乱代码结构*/

@end

@implementation MoviePlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);/*打乱代码结构*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    // pop回来时候是否自动播放

    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;/*打乱代码结构*/
        self.playerView.playerPushedOrPresented = NO;/*打乱代码结构*/
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];/*打乱代码结构*//*打乱代码结构*/
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;/*打乱代码结构*/
        [self.playerView pause];/*打乱代码结构*//*打乱代码结构*/
        self.playerView.playerPushedOrPresented = YES;/*打乱代码结构*/
    }else{
        [self.playerView resetPlayer];/*打乱代码结构*//*打乱代码结构*/
        self.playerView.delegate = nil;/*打乱代码结构*/
        self.playerView = nil;/*打乱代码结构*/
    }
    

   


}


- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    // Do any additional setup after loading the view.
    self.zf_prefersNavigationBarHidden = YES;/*打乱代码结构*/
    self.view.backgroundColor = [UIColor blackColor];/*打乱代码结构*//*打乱代码结构*/

        
        self.playerFatherView = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
        [self.view addSubview:self.playerFatherView];/*打乱代码结构*//*打乱代码结构*/
        
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);/*打乱代码结构*/
            make.left.equalTo(self.view);/*打乱代码结构*/
            make.width.equalTo(self.view);/*打乱代码结构*/
            make.height.mas_equalTo(ScreenWidth*9/16);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
        
        // 自动播放，默认不自动播放
        [self.playerView autoPlayTheVideo];/*打乱代码结构*//*打乱代码结构*/
   
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];/*打乱代码结构*//*打乱代码结构*/
    // Dispose of any resources that can be recreated.
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;/*打乱代码结构*/
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;/*打乱代码结构*/
    // }
    return UIStatusBarStyleLightContent;/*打乱代码结构*/
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;/*打乱代码结构*/
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:NO];/*打乱代码结构*//*打乱代码结构*/
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];/*打乱代码结构*//*打乱代码结构*/
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];/*打乱代码结构*//*打乱代码结构*/
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;/*打乱代码结构*/
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;/*打乱代码结构*/

}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;/*打乱代码结构*/
 
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];/*打乱代码结构*//*打乱代码结构*/
        _playerModel.title            = self.titleSring;/*打乱代码结构*/
        _playerModel.videoURL         = self.videoURL;/*打乱代码结构*/
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];/*打乱代码结构*//*打乱代码结构*/
        _playerModel.fatherView       = self.playerFatherView;/*打乱代码结构*/
        _playerModel.isShowCollect    = self.isShowCollect;/*打乱代码结构*/
        _playerModel.videoModel = self.videoModel;/*打乱代码结构*/

    }
    return _playerModel;/*打乱代码结构*/
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];/*打乱代码结构*//*打乱代码结构*/
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];/*打乱代码结构*//*打乱代码结构*/
        
        // 设置代理
        _playerView.delegate = self;/*打乱代码结构*/
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;/*打乱代码结构*/
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = self.isDown;/*打乱代码结构*/
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;/*打乱代码结构*/
        
    }
    return _playerView;/*打乱代码结构*/
}

#pragma mark - Action




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
