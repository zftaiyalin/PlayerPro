//
//  LaunchScreenViewController.m
//  PlayerPro
//
//  Created by 曾富田 on 2017/9/11.
//  Copyright © 2017年 安风. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.layer.cornerRadius = 10;
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
