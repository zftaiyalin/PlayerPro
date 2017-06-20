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

@property (strong, nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property(nonatomic,strong)UIWebView *webView;
//@property (strong, nonatomic) UIButton *backBtn;

@end

@implementation MoviePlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放

    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }else{
        [self.playerView resetPlayer];
        self.playerView.delegate = nil;
        self.playerView = nil;
    }
    

   


}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.zf_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];

        
        self.playerFatherView = [[UIView alloc]init];
        [self.view addSubview:self.playerFatherView];
        
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(ScreenWidth*9/16);
        }];
        
        // 自动播放，默认不自动播放
        [self.playerView autoPlayTheVideo];
   
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;

}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
 
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.titleSring;
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        _playerModel.isShowCollect    = self.isShowCollect;
        _playerModel.videoModel = self.videoModel;

    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = self.isDown;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
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
