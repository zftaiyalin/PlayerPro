//
//  VideoUrlModel.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/11.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "VideoUrlModel.h"
#import "VideoPlayModel.h"

@implementation VideoUrlModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"videoArray" : [VideoPlayModel class] };
}

@end
