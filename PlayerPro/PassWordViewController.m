//
//  PassWordViewController.m
//  PlayerPro
//
//  Created by 曾富田 on 2017/9/8.
//  Copyright © 2017年 安风. All rights reserved.
//

#import "PassWordViewController.h"
#import "CLLockVC.h"
@interface PassWordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;/*打乱代码结构*/

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";/*打乱代码结构*/
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];/*打乱代码结构*//*打乱代码结构*/
    
    if (self.isTop) {
         [self performSelector:@selector(pushLock) withObject:nil afterDelay:0.0];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];/*打乱代码结构*//*打乱代码结构*/
        self.tableView.dataSource = self;/*打乱代码结构*/
        self.tableView.delegate = self;/*打乱代码结构*/
        self.tableView.allowsSelection=YES;/*打乱代码结构*/
        self.tableView.showsHorizontalScrollIndicator = NO;/*打乱代码结构*/
        self.tableView.showsVerticalScrollIndicator = NO;/*打乱代码结构*/
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;/*打乱代码结构*/
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];/*打乱代码结构*//*打乱代码结构*/
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];/*打乱代码结构*//*打乱代码结构*/
        [self.view addSubview:_tableView];/*打乱代码结构*//*打乱代码结构*/
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.bottom.equalTo(self.view);/*打乱代码结构*/
            make.top.equalTo(self.view.mas_top);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
    }
    
    
}
-(void)pushLock{

    
    [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
        NSLog(@"忘记密码");
    } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        [self performSelector:@selector(pushMain) withObject:nil afterDelay:1.0];
        [lockVC dismiss:1.0f];
    }];

}
-(void)pushMain{
    
    if ([self.delegate respondsToSelector:@selector(passWordSuccess)]) { [self.delegate passWordSuccess];/*打乱代码结构*/ }
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;/*打乱代码结构*/
    
    //收藏 清楚缓存 赏个好评 下载
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;/*打乱代码结构*/
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;/*打乱代码结构*/
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;/*打乱代码结构*/
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];/*打乱代码结构*//*打乱代码结构*/
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;/*打乱代码结构*/
    
 
    if (indexPath.section == 0) {
            
            
            cell.textLabel.text = @"设置手势密码";/*打乱代码结构*/
            
            UIView *line = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
            line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];/*打乱代码结构*//*打乱代码结构*/
            [cell addSubview:line];/*打乱代码结构*//*打乱代码结构*/
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.top.equalTo(cell);/*打乱代码结构*/
                make.height.mas_equalTo(0.25);/*打乱代码结构*/
            }];/*打乱代码结构*//*打乱代码结构*/
            
    }else{
            
            cell.textLabel.text = @"修改手势密码";/*打乱代码结构*/
            UIView *line = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
            line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];/*打乱代码结构*//*打乱代码结构*/
            [cell addSubview:line];/*打乱代码结构*//*打乱代码结构*/
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.top.equalTo(cell);/*打乱代码结构*/
                make.height.mas_equalTo(0.25);/*打乱代码结构*/
            }];/*打乱代码结构*//*打乱代码结构*/
            
    }
    
    
    return cell;/*打乱代码结构*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];/*打乱代码结构*//*打乱代码结构*/
  
    if (indexPath.section == 0) {
        /*打乱代码结构*//*打乱代码结构*/
       /*打乱代码结构*//*打乱代码结构*/
        
        BOOL hasPwd = [CLLockVC hasPwd];
        hasPwd = NO;
        if(hasPwd){
            
            NSLog(@"已经设置过密码了，你可以验证或者修改密码");
        }else{
            
            [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                NSLog(@"密码设置成功");
                [lockVC dismiss:1.0f];
            }];
        }
    }else{
        
        BOOL hasPwd = [CLLockVC hasPwd];
        
        if(!hasPwd){
            
            NSLog(@"你还没有设置密码，请先设置密码");
            
        }else {
            
            [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                [lockVC dismiss:.5f];
            }];
        }
    }
    
}

@end
