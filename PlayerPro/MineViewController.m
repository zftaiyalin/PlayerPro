//
//  MineViewController.m
//  XiaoShuoTool
//
//  Created by 安风 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "MineViewController.h"
#import "DaiLuViewController.h"
#import "SDImageCache.h"
#import "NSObject+ALiHUD.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;/*打乱代码结构*/

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    // Do any additional setup after loading the view.
    self.title = @"我的";/*打乱代码结构*/
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];/*打乱代码结构*//*打乱代码结构*/
    

    
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
    
    
    NSString *sss = [AppUnitl getPreferredLanguage];
    
//    zh-Hans-CN
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"] && [AppUnitl sharedManager].model.wetchat.isShow && [sss isEqualToString:[AppUnitl sharedManager].model.wetchat.laugain]) {
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:[AppUnitl sharedManager].model.wetchat.alertTitle message:[AppUnitl sharedManager].model.wetchat.alertText delegate:self   cancelButtonTitle:@"取消" otherButtonTitles:@"去评论",nil];/*打乱代码结构*//*打乱代码结构*/
        [infoAlert show];/*打乱代码结构*//*打乱代码结构*/
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *str = [NSString stringWithFormat:
                         @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",
                         @"1239455471"];/*打乱代码结构*//*打乱代码结构*/
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pinglun"];/*打乱代码结构*//*打乱代码结构*/
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];/*打乱代码结构*//*打乱代码结构*/
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    [_tableView reloadData];/*打乱代码结构*//*打乱代码结构*/
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
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"] ? 2:1;/*打乱代码结构*/
    
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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"]) {
        if (indexPath.section == 0) {
            
            
            cell.textLabel.text = @"联系老司机";/*打乱代码结构*/
            
            UIView *line = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
            line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];/*打乱代码结构*//*打乱代码结构*/
            [cell addSubview:line];/*打乱代码结构*//*打乱代码结构*/
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.top.equalTo(cell);/*打乱代码结构*/
                make.height.mas_equalTo(0.25);/*打乱代码结构*/
            }];/*打乱代码结构*//*打乱代码结构*/
            
        }else{
            
            cell.textLabel.text = @"赏个好评";/*打乱代码结构*/
            UIView *line = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
            line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];/*打乱代码结构*//*打乱代码结构*/
            [cell addSubview:line];/*打乱代码结构*//*打乱代码结构*/
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.top.equalTo(cell);/*打乱代码结构*/
                make.height.mas_equalTo(0.25);/*打乱代码结构*/
            }];/*打乱代码结构*//*打乱代码结构*/
            
        }
    }else{
        cell.textLabel.text = @"赏个好评";/*打乱代码结构*/
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"]) {
        if (indexPath.section == 0) {
            DaiLuViewController *lu = [[DaiLuViewController alloc]init];/*打乱代码结构*//*打乱代码结构*/
            [self.navigationController pushViewController:lu animated:YES];/*打乱代码结构*//*打乱代码结构*/
        }else{
            [self pushPinglun];/*打乱代码结构*//*打乱代码结构*/
        }
    }else{
        [self pushPinglun];/*打乱代码结构*//*打乱代码结构*/
    }
  
}

-(void)pushPinglun{
    NSString *str = [NSString stringWithFormat:
                     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",
                     @"1239455471"];/*打乱代码结构*//*打乱代码结构*/
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];/*打乱代码结构*//*打乱代码结构*/
}


@end
