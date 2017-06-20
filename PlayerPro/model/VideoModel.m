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
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.baseUrl = [aDecoder decodeObjectForKey:@"baseUrl"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.baseUrl forKey:@"baseUrl"];
}
@end
