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

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection=YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
    }];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"] && [AppUnitl sharedManager].model.wetchat.isAlertShow) {
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:[AppUnitl sharedManager].model.wetchat.alertTitle message:[AppUnitl sharedManager].model.wetchat.alertText delegate:self   cancelButtonTitle:@"取消" otherButtonTitles:@"去评论",nil];
        [infoAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *str = [NSString stringWithFormat:
                         @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",
                         @"1239455471"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pinglun"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
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
    return 2;
    
    //收藏 清楚缓存 赏个好评 下载
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return 1;

   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

        if (indexPath.section == 0) {
            
        
                cell.textLabel.text = @"联系老司机";
            
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
                [cell addSubview:line];
            
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.and.top.equalTo(cell);
                    make.height.mas_equalTo(0.25);
                }];
           
            }else{

                    cell.textLabel.text = @"赏个好评";
                    UIView *line = [[UIView alloc]init];
                    line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
                    [cell addSubview:line];
                    
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.and.right.and.top.equalTo(cell);
                        make.height.mas_equalTo(0.25);
                    }];
                
            }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        if (indexPath.section == 0) {
            DaiLuViewController *lu = [[DaiLuViewController alloc]init];
            [self.navigationController pushViewController:lu animated:YES];
        }else{
            [self pushPinglun];
        }
  
}

-(void)pushPinglun{
    NSString *str = [NSString stringWithFormat:
                     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",
                     @"1239455471"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
