//
//  DaiLuViewController.m
//  XiaoShuoTool
//
//  Created by 安风 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "DaiLuViewController.h"
#import "NSObject+ALiHUD.h"


@interface DaiLuViewController (){
   
}

@property(nonatomic,strong) UIButton *wechatBtu;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIButton *tijiaoBtu;
@property(nonatomic,strong) UILabel *jgLabel;
@end

@implementation DaiLuViewController



-(void)dealloc{
    NSLog(@"释放控制器");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"带路党";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"获取积分" style:UIBarButtonItemStylePlain target:self action:@selector(huoqujifen)];
    
    self.navigationItem.rightBarButtonItem = item;

    _wechatBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatBtu.backgroundColor = [UIColor whiteColor];
    [_wechatBtu addTarget:self action:@selector(copyWechat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatBtu];
    
    [_wechatBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+65);
        make.height.mas_equalTo(44);
    }];
    
    
    UILabel *label = [[UILabel alloc]init];
    if ([AppUnitl sharedManager].model.wetchat.isWetchat) {
        label.text = [AppUnitl sharedManager].model.wetchat.wechatnick;
    }else{
        label.text = @"老司机带路群，加群，你懂得😉";
    }
    
    label.textColor = [UIColor colorWithHexString:@"#FF6A6A"];
    [_wechatBtu addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(_wechatBtu).insets(UIEdgeInsetsMake(0, 13, 0, 13));
    }];
    
    
}




-(void)copyWechat{
    
    if ([AppUnitl sharedManager].model.wetchat.isWetchat) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [AppUnitl sharedManager].model.wetchat.wechatnick;
        
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"已复制老司机微信号，是否前往寻找老司机？" delegate:self   cancelButtonTitle:@"待会儿" otherButtonTitles:@"前往",nil];
        [infoAlert show];
  
    }else{
    [self joinGroup:[AppUnitl sharedManager].model.wetchat.groupUin key:[AppUnitl sharedManager].model.wetchat.key];
    }
    

}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    [MobClick event:@"添加qq群"];
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"643483053",@"3633e772ddb30b8b125efc2d1368fc8de0aec864e100b7a352b337c547bb7877"];
    NSURL *url = [NSURL URLWithString:urlStr];
//    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
//    }
//    else return NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        
        NSString *str = @"weixin:/";
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    }
}

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
