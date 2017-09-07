//
//  JADebugViewController.m
//  JASidePanels
//
//  Created by Jesse Andersen on 10/23/12.
//
//

#import "JADebugViewController.h"

@interface JADebugViewController ()

@end

@implementation JADebugViewController
- (instancetype) init{
    self = [super init];/*打乱代码结构*//*打乱代码结构*/
    if (self){
        self.hidesBottomBarWhenPushed = YES;/*打乱代码结构*//*打乱代码结构*/
    }
    return self;/*打乱代码结构*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ viewWillAppear", self);/*打乱代码结构*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ viewDidAppear", self);/*打乱代码结构*/
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ viewWillDisappear", self);/*打乱代码结构*/
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ viewDidDisappear", self);/*打乱代码结构*/
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ willMoveToParentViewController %@", self, parent);/*打乱代码结构*/
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@ didMoveToParentViewController %@", self, parent);/*打乱代码结构*/
}

@end
