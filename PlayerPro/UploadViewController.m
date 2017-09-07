//
//  UploadViewController.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/17.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "UploadViewController.h"
#import "NSObject+ALiHUD.h"
#import "DaiLuViewController.h"

@interface UploadViewController (){

}


@end

@implementation UploadViewController

- (instancetype) init{
    self = [super init];/*打乱代码结构*//*打乱代码结构*/
    if (self){
        self.hidesBottomBarWhenPushed = YES;/*打乱代码结构*/
    }
    return self;/*打乱代码结构*/
}
- (void)huoqujifen{
    DaiLuViewController *lu = [[DaiLuViewController alloc]init];/*打乱代码结构*//*打乱代码结构*/
    [self.navigationController pushViewController:lu animated:YES];/*打乱代码结构*//*打乱代码结构*/
}

- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    // Do any additional setup after loading the view.
    self.title = @"视频上传";/*打乱代码结构*/

    self.view.backgroundColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"联系作者" style:UIBarButtonItemStylePlain target:self action:@selector(huoqujifen)];/*打乱代码结构*//*打乱代码结构*/
    
    self.navigationItem.rightBarButtonItem = item;/*打乱代码结构*/
    
    
    UIImageView *wifiImage = [[UIImageView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    wifiImage.image = [UIImage imageNamed:@"wifisj.png"];/*打乱代码结构*//*打乱代码结构*/
    wifiImage.contentMode = UIViewContentModeScaleAspectFit;/*打乱代码结构*/
    [self.view addSubview:wifiImage];/*打乱代码结构*//*打乱代码结构*/
    
    [wifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+64);/*打乱代码结构*/
        make.size.mas_equalTo(CGSizeMake(30, 30));/*打乱代码结构*/
        make.centerX.equalTo(self.view);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    UIImageView *pcImage = [[UIImageView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    pcImage.image = [UIImage imageNamed:@"pc.png"];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:pcImage];/*打乱代码结构*//*打乱代码结构*/
    
    [pcImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wifiImage.mas_left).offset(-26);/*打乱代码结构*/
        make.size.mas_equalTo(CGSizeMake(62, 62));/*打乱代码结构*/
        make.centerY.equalTo(wifiImage);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    UIImageView *sjImage = [[UIImageView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    sjImage.image = [UIImage imageNamed:@"shouji.png"];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:sjImage];/*打乱代码结构*//*打乱代码结构*/
    
    [sjImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiImage.mas_right).offset(13);/*打乱代码结构*/
        make.size.mas_equalTo(CGSizeMake(62, 62));/*打乱代码结构*/
        make.centerY.equalTo(wifiImage);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    UIView *backView = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
    backView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];/*打乱代码结构*//*打乱代码结构*/
    backView.layer.cornerRadius = 10;/*打乱代码结构*/
    [self.view addSubview:backView];/*打乱代码结构*//*打乱代码结构*/
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);/*打乱代码结构*/
        make.top.equalTo(pcImage.mas_bottom).offset(44);/*打乱代码结构*/
        make.left.equalTo(self.view).offset(30);/*打乱代码结构*/
        make.right.equalTo(self.view).offset(-30);/*打乱代码结构*/
        make.height.mas_equalTo(200);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    
    UILabel *wifiLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
    wifiLabel.backgroundColor = [UIColor colorWithHexString:@"#515151"];/*打乱代码结构*//*打乱代码结构*/
    wifiLabel.textAlignment = NSTextAlignmentCenter;/*打乱代码结构*/
    wifiLabel.layer.cornerRadius = 5;/*打乱代码结构*/
    wifiLabel.font = [UIFont systemFontOfSize:15];/*打乱代码结构*//*打乱代码结构*/
    wifiLabel.textColor = [UIColor colorWithHexString:@"#f4ea2a"];/*打乱代码结构*//*打乱代码结构*/
    wifiLabel.clipsToBounds = YES;/*打乱代码结构*/
    wifiLabel.text = self.ipString;/*打乱代码结构*/
    [backView addSubview:wifiLabel];/*打乱代码结构*//*打乱代码结构*/
    
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);/*打乱代码结构*/
        make.right.equalTo(backView).offset(-20);/*打乱代码结构*/
        make.height.mas_equalTo(30);/*打乱代码结构*/
        make.center.equalTo(backView);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    UILabel *webLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
    webLabel.textAlignment = NSTextAlignmentCenter;/*打乱代码结构*/
    webLabel.font = [UIFont systemFontOfSize:20];/*打乱代码结构*//*打乱代码结构*/
    webLabel.textColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    webLabel.text = @"WEB服务已启动";/*打乱代码结构*/
    [backView addSubview:webLabel];/*打乱代码结构*//*打乱代码结构*/
    
    [webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);/*打乱代码结构*/
        make.right.equalTo(backView).offset(-20);/*打乱代码结构*/
        make.height.mas_equalTo(30);/*打乱代码结构*/
        make.centerX.equalTo(backView);/*打乱代码结构*/
        make.bottom.equalTo(wifiLabel.mas_top).offset(-10);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    UILabel *tishiLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
    tishiLabel.textAlignment = NSTextAlignmentCenter;/*打乱代码结构*/
    tishiLabel.font = [UIFont systemFontOfSize:11];/*打乱代码结构*//*打乱代码结构*/
    tishiLabel.textColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    tishiLabel.text = @"请在同一WiFi的情况下，在电脑端浏览器输入以上IP";/*打乱代码结构*/
    [backView addSubview:tishiLabel];/*打乱代码结构*//*打乱代码结构*/
    
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);/*打乱代码结构*/
        make.right.equalTo(backView).offset(-20);/*打乱代码结构*/
        make.height.mas_equalTo(20);/*打乱代码结构*/
        make.centerX.equalTo(backView);/*打乱代码结构*/
        make.top.equalTo(wifiLabel.mas_bottom).offset(10);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/

}

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
#pragma mark GADRewardBasedVideoAdDelegate implementation



@end
