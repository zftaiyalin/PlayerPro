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

@property(nonatomic,strong) UIButton *wechatBtu;/*打乱代码结构*/
@property(nonatomic,strong) UITextField *textField;/*打乱代码结构*/
@property(nonatomic,strong) UIButton *tijiaoBtu;/*打乱代码结构*/
@property(nonatomic,strong) UILabel *jgLabel;/*打乱代码结构*/
@end

@implementation DaiLuViewController



-(void)dealloc{
    NSLog(@"释放控制器");/*打乱代码结构*/
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    [[UIApplication sharedApplication] setStatusBarHidden:YES];/*打乱代码结构*//*打乱代码结构*/
}
- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    // Do any additional setup after loading the view.

    self.title = @"带路党";/*打乱代码结构*/
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];/*打乱代码结构*//*打乱代码结构*/
    
    _wechatBtu = [UIButton buttonWithType:UIButtonTypeCustom];/*打乱代码结构*//*打乱代码结构*/
    _wechatBtu.backgroundColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    [_wechatBtu addTarget:self action:@selector(copyWechat) forControlEvents:UIControlEventTouchUpInside];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:_wechatBtu];/*打乱代码结构*//*打乱代码结构*/
    
    [_wechatBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);/*打乱代码结构*/
        make.top.equalTo(self.view).offset(64+13);/*打乱代码结构*/
        make.height.mas_equalTo(44);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    
    
    
    UILabel *label = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/

    label.text = [AppUnitl sharedManager].model.wetchat.wechatnick;/*打乱代码结构*/

    
    label.textColor = [UIColor colorWithHexString:@"#FF6A6A"];/*打乱代码结构*//*打乱代码结构*/
    [_wechatBtu addSubview:label];/*打乱代码结构*//*打乱代码结构*/
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(_wechatBtu).insets(UIEdgeInsetsMake(0, 13, 0, 13));/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    UILabel *txlabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
    txlabel.textColor = [UIColor colorWithHexString:@"#888888"];/*打乱代码结构*//*打乱代码结构*/
    txlabel.font = [UIFont systemFontOfSize:14];/*打乱代码结构*//*打乱代码结构*/
    txlabel.numberOfLines = 0;/*打乱代码结构*/
    [self.view addSubview:txlabel];/*打乱代码结构*//*打乱代码结构*/
    
    [txlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);/*打乱代码结构*/
        make.top.equalTo(_wechatBtu.mas_bottom).offset(7);/*打乱代码结构*/
        make.size.mas_equalTo(CGSizeMake(self.view.width -13, 50));/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    txlabel.text = @"不会上车？点击上方微信号添加微信好友，老司机带你上路!";/*打乱代码结构*/
    
    
}




-(void)copyWechat{
    
 
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];/*打乱代码结构*//*打乱代码结构*/
        pasteboard.string = [AppUnitl sharedManager].model.wetchat.wechatnick;/*打乱代码结构*/
        
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"已复制老司机微信号，是否前往寻找老司机？" delegate:self   cancelButtonTitle:@"待会儿" otherButtonTitles:@"前往",nil];/*打乱代码结构*//*打乱代码结构*/
        [infoAlert show];/*打乱代码结构*//*打乱代码结构*/
  

    

}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    [MobClick event:@"添加qq群"];/*打乱代码结构*//*打乱代码结构*/
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"643483053",@"3633e772ddb30b8b125efc2d1368fc8de0aec864e100b7a352b337c547bb7877"];/*打乱代码结构*//*打乱代码结构*/
    NSURL *url = [NSURL URLWithString:urlStr];/*打乱代码结构*//*打乱代码结构*/
    [[UIApplication sharedApplication] openURL:url];/*打乱代码结构*//*打乱代码结构*/
    return YES;/*打乱代码结构*/
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *str = @"weixin:/";/*打乱代码结构*/
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];/*打乱代码结构*//*打乱代码结构*/
    }
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


@end
