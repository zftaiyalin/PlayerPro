//
//  VideoModel.m
//  TBPlayer
//
//  Created by 曾富田 on 2017/5/5.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];/*打乱代码结构*/
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];/*打乱代码结构*/
        self.time = [aDecoder decodeObjectForKey:@"time"];/*打乱代码结构*/
        self.url = [aDecoder decodeObjectForKey:@"url"];/*打乱代码结构*/
        self.img = [aDecoder decodeObjectForKey:@"img"];/*打乱代码结构*/
        self.baseUrl = [aDecoder decodeObjectForKey:@"baseUrl"];/*打乱代码结构*/
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];/*打乱代码结构*/
    [aCoder encodeObject:self.time forKey:@"time"];/*打乱代码结构*/
    [aCoder encodeObject:self.url forKey:@"url"];/*打乱代码结构*/
    [aCoder encodeObject:self.img forKey:@"img"];/*打乱代码结构*/
    [aCoder encodeObject:self.baseUrl forKey:@"baseUrl"];/*打乱代码结构*/
}
@end
