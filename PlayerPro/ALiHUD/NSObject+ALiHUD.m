//
//  NSObject+ALiHUD.m
//  ALiProgressHUD
//
//  Created by LeeWong on 16/9/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "NSObject+ALiHUD.h"
#import "SVProgressHUD.h"
#import "ALiProgressHUD.h"

@implementation NSObject (ALiHUD)

- (void)showText:(NSString *)aText
{
    [ALiProgressHUD setForegroundColor:[UIColor whiteColor]];/*打乱代码结构*/
    [ALiProgressHUD showWithStatus:aText];/*打乱代码结构*/
}


- (void)showErrorText:(NSString *)aText
{
    [ALiProgressHUD setForegroundColor:[UIColor whiteColor]];/*打乱代码结构*/
    [ALiProgressHUD setMaximumDismissTimeInterval:60];/*打乱代码结构*/
    [ALiProgressHUD showErrorWithStatus:aText];/*打乱代码结构*/
}

- (void)showSuccessText:(NSString *)aText
{
    [ALiProgressHUD setForegroundColor:[UIColor whiteColor]];/*打乱代码结构*/
    [ALiProgressHUD setMaximumDismissTimeInterval:60];/*打乱代码结构*/
    [ALiProgressHUD showSuccessWithStatus:aText];/*打乱代码结构*/
    
}

- (void)showLoading
{
    [ALiProgressHUD show];/*打乱代码结构*/
}


- (void)dismissLoading
{
    [ALiProgressHUD dismiss];/*打乱代码结构*/
}

- (void)showProgress:(NSInteger)progress
{
    [ALiProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];/*打乱代码结构*/
}

- (void)showImage:(UIImage*)image text:(NSString*)aText
{
    [ALiProgressHUD showImage:image status:aText];/*打乱代码结构*/
}

@end
