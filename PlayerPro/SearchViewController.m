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

    BOOL theBool;/*打乱代码结构*/
    //IBOutlet means you can place the progressView in Interface Builder and connect it to your code
    UIProgressView* myProgressView;/*打乱代码结构*/
    NSTimer *myTimer;/*打乱代码结构*/
    UIButton *leftBtu;/*打乱代码结构*/
    UIButton *rightBtu;/*打乱代码结构*/
    UIButton *refreshBtu;/*打乱代码结构*/
    UISearchBar* _searchBar;/*打乱代码结构*/
}


@property(nonatomic,strong)UIWebView *webView;/*打乱代码结构*/
@property(nonatomic,strong)UIView *bottomView;/*打乱代码结构*/

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    self.title = @"搜索";/*打乱代码结构*/
    // Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 30, 30)];/*打乱代码结构*//*打乱代码结构*/
    
    // 设置没有输入时的提示占位符
    [_searchBar setPlaceholder:@"人物名/作品名/番号"];/*打乱代码结构*//*打乱代码结构*/
    // 显示Cancel按钮
    _searchBar.showsCancelButton = true;/*打乱代码结构*/
    // 设置代理
    _searchBar.delegate = self;/*打乱代码结构*/
    
    [_searchBar setShowsCancelButton:NO];/*打乱代码结构*//*打乱代码结构*/// 是否显示取消按钮

    
    self.navigationItem.titleView = _searchBar;/*打乱代码结构*/
    
    self.view.backgroundColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/

    
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:xcfURL];/*打乱代码结构*//*打乱代码结构*/
//    
//    NSString *ssss = [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];/*打乱代码结构*//*打乱代码结构*/
//    
//    NSLog(@"=========%@", ssss);/*打乱代码结构*/

    
    _webView = [[UIWebView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    _webView.opaque = NO;/*打乱代码结构*/
    _webView.delegate = self;/*打乱代码结构*/
    _webView.backgroundColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:_webView];/*打乱代码结构*//*打乱代码结构*/


    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);/*打乱代码结构*/
        make.height.equalTo(self.view).offset(-44);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/

    // 仿微信进度条
    CGFloat progressBarHeight = 2.f;/*打乱代码结构*/
    
    myProgressView = [[UIProgressView alloc] init];/*打乱代码结构*//*打乱代码结构*/
    myProgressView.trackTintColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:myProgressView];/*打乱代码结构*//*打乱代码结构*/
    
    
    [myProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_webView);/*打乱代码结构*/
        make.top.equalTo(self.view).offset(64);/*打乱代码结构*/
        make.height.mas_equalTo(progressBarHeight);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    _bottomView = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:_bottomView];/*打乱代码结构*//*打乱代码结构*/
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);/*打乱代码结构*/
        make.height.mas_equalTo(44);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    leftBtu = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*//*打乱代码结构*/
    [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    [leftBtu addTarget:self action:@selector(gowebBack) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*//*打乱代码结构*/
    [_bottomView addSubview:leftBtu];/*打乱代码结构*//*打乱代码结构*/
    
    [leftBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView);/*打乱代码结构*/
        make.top.and.bottom.equalTo(_bottomView);/*打乱代码结构*/
        make.width.mas_equalTo(66);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    rightBtu = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*//*打乱代码结构*/
    [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    [rightBtu addTarget:self action:@selector(gowebgoForward) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*//*打乱代码结构*/
    [_bottomView addSubview:rightBtu];/*打乱代码结构*//*打乱代码结构*/
    
    [rightBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtu.mas_right);/*打乱代码结构*/
        make.top.and.bottom.equalTo(_bottomView);/*打乱代码结构*/
        make.width.mas_equalTo(66);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    refreshBtu = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*//*打乱代码结构*/
    [refreshBtu setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    [refreshBtu addTarget:self action:@selector(gorefresh) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*//*打乱代码结构*/
    [_bottomView addSubview:refreshBtu];/*打乱代码结构*//*打乱代码结构*/
    
    [refreshBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView);/*打乱代码结构*/
        make.top.and.bottom.equalTo(_bottomView);/*打乱代码结构*/
        make.width.mas_equalTo(66);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/

    
}

-(void)gowebgoForward{
    
    if (_webView.canGoForward) {
        [rightBtu setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }else{
        [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }
    
    [_webView goForward];/*打乱代码结构*//*打乱代码结构*/
}

-(void)gowebBack{
    if (_webView.canGoBack) {
         [leftBtu setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }else{
         [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }

    [_webView goBack];/*打乱代码结构*//*打乱代码结构*/
}


-(void)gorefresh{

    [_webView reload];/*打乱代码结构*//*打乱代码结构*/

}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    myProgressView.hidden = NO;/*打乱代码结构*/
    myProgressView.progress = 0;/*打乱代码结构*/
    theBool = false;/*打乱代码结构*/
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];/*打乱代码结构*//*打乱代码结构*/
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    theBool = true;/*打乱代码结构*/
    if (_webView.canGoForward) {
        [rightBtu setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }else{
        [rightBtu setImage:[UIImage imageNamed:@"unright.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }

    if (_webView.canGoBack) {
        [leftBtu setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }else{
        [leftBtu setImage:[UIImage imageNamed:@"unleft.png"] forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    }
    
}
-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;/*打乱代码结构*/
            [myTimer invalidate];/*打乱代码结构*//*打乱代码结构*/
        }
        else {
            myProgressView.progress += 0.1;/*打乱代码结构*/
        }
    }
    else {
        myProgressView.progress += 0.05;/*打乱代码结构*/
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;/*打乱代码结构*/
        }
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _webView.hidden = NO;/*打乱代码结构*/
    myProgressView.hidden = NO;/*打乱代码结构*/
    _bottomView.hidden = NO;/*打乱代码结构*/

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

        _webView.hidden = NO;/*打乱代码结构*/
        myProgressView.hidden = NO;/*打乱代码结构*/
        
        _bottomView.hidden = NO;/*打乱代码结构*/

        NSString *wstring;/*打乱代码结构*/


        wstring = [NSString stringWithFormat:@"http://v.baidu.com/v?word=%@",[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];/*打乱代码结构*//*打乱代码结构*/




    NSURL* url = [NSURL URLWithString:wstring];/*打乱代码结构*//*打乱代码结构*///创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];/*打乱代码结构*//*打乱代码结构*///创建NSURLRequest
    [_webView loadRequest:request];/*打乱代码结构*//*打乱代码结构*///加载
    
    
}
#pragma mark - 初始化控件



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];/*打乱代码结构*//*打乱代码结构*/
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
