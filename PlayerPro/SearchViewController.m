//
//  SearchViewController.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/9.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "SearchViewController.h"
#import "MJRefresh.h"
#import "VideoPlayModel.h"
@interface SearchViewController ()<UISearchBarDelegate,UIWebViewDelegate>{

    BOOL theBool;
    //IBOutlet means you can place the progressView in Interface Builder and connect it to your code
    UIProgressView* myProgressView;
    NSTimer *myTimer;
    UIButton *leftBtu;
    UIButton *rightBtu;
    UIButton *refreshBtu;
    UISearchBar* _searchBar;
}


@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    // Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 30, 30)];
    
    // 设置没有输入时的提示占位符
    [_searchBar setPlaceholder:@"人物名/作品名/番号"];
    // 显示Cancel按钮
    _searchBar.showsCancelButton = true;
    // 设置代理
    _searchBar.delegate = self;
    
    [_searchBar setShowsCancelButton:NO];// 是否显示取消按钮

    
    self.navigationItem.titleView = _searchBar;
    
    self.view.backgroundColor = [UIColor whiteColor];

    
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:xcfURL];
//    
//    NSString *ssss = [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"=========%@", ssss);

    
    _webView = [[UIWebView alloc]init];
    _webView.opaque = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];


    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.height.equalTo(self.view).offset(-44);
    }];

    // 仿微信进度条
    CGFloat progressBarHeight = 2.f;
    
    myProgressView = [[UIProgressView alloc] init];
    myProgressView.trackTintColor = [UIColor whiteColor];
    myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.view addSubview:myProgressView];
    
    
    [myProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_webView);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(progressBarHeight);
    }];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    leftBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];
    [leftBtu addTarget:self action:@selector(gowebBack) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:leftBtu];
    
    [leftBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView);
        make.top.and.bottom.equalTo(_bottomView);
        make.width.mas_equalTo(66);
    }];
    
    
    rightBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];
    [rightBtu addTarget:self action:@selector(gowebgoForward) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:rightBtu];
    
    [rightBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtu.mas_right);
        make.top.and.bottom.equalTo(_bottomView);
        make.width.mas_equalTo(66);
    }];
    
    refreshBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtu setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];
    [refreshBtu addTarget:self action:@selector(gorefresh) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:refreshBtu];
    
    [refreshBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView);
        make.top.and.bottom.equalTo(_bottomView);
        make.width.mas_equalTo(66);
    }];

    
}

-(void)gowebgoForward{
    
    if (_webView.canGoForward) {
        [rightBtu setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    }else{
        [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];
    }
    
    [_webView goForward];
}

-(void)gowebBack{
    if (_webView.canGoBack) {
         [leftBtu setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    }else{
         [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];
    }

    [_webView goBack];
}


-(void)gorefresh{

    [_webView reload];

}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    myProgressView.hidden = NO;
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    theBool = true;
    if (_webView.canGoForward) {
        [rightBtu setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    }else{
        [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];
    }

    if (_webView.canGoBack) {
        [leftBtu setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    }else{
        [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];
    }
    
}
-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _webView.hidden = NO;
    myProgressView.hidden = NO;
    _bottomView.hidden = NO;

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

        _webView.hidden = NO;
        myProgressView.hidden = NO;
        
        _bottomView.hidden = NO;

        NSString *wstring;


        wstring = [NSString stringWithFormat:@"http://v.baidu.com/v?word=%@",[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];




    NSURL* url = [NSURL URLWithString:wstring];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    
    
}
#pragma mark - 初始化控件



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
