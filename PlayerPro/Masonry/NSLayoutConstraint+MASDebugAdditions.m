//
//  NSLayoutConstraint+MASDebugAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 3/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSLayoutConstraint+MASDebugAdditions.h"
#import "MASConstraint.h"
#import "MASLayoutConstraint.h"

@implementation NSLayoutConstraint (MASDebugAdditions)

#pragma mark - description maps

+ (NSDictionary *)layoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)layoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            
#if TARGET_OS_IPHONE
            @(NSLayoutAttributeLeftMargin)           : @"leftMargin",
            @(NSLayoutAttributeRightMargin)          : @"rightMargin",
            @(NSLayoutAttributeTopMargin)            : @"topMargin",
            @(NSLayoutAttributeBottomMargin)         : @"bottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"leadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"trailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"centerXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"centerYWithinMargins",
#endif
            
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)layoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE
        descriptionMap = @{
            @(MASLayoutPriorityDefaultHigh)      : @"high",
            @(MASLayoutPriorityDefaultLow)       : @"low",
            @(MASLayoutPriorityDefaultMedium)    : @"medium",
            @(MASLayoutPriorityRequired)         : @"required",
            @(MASLayoutPriorityFittingSizeLevel) : @"fitting size",
        };
#elif TARGET_OS_MAC
        descriptionMap = @{
            @(MASLayoutPriorityDefaultHigh)                 : @"high",
            @(MASLayoutPriorityDragThatCanResizeWindow)     : @"drag can resize window",
            @(MASLayoutPriorityDefaultMedium)               : @"medium",
            @(MASLayoutPriorityWindowSizeStayPut)           : @"window size stay put",
            @(MASLayoutPriorityDragThatCannotResizeWindow)  : @"drag cannot resize window",
            @(MASLayoutPriorityDefaultLow)                  : @"low",
            @(MASLayoutPriorityFittingSizeCompression)      : @"fitting size",
            @(MASLayoutPriorityRequired)                    : @"required",
        };
#endif
    });
    return descriptionMap;
}

#pragma mark - description override

+ (NSString *)descriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(mas_key)] && [obj mas_key]) {
        return [NSString stringWithFormat:@"%@:%@", [obj class], [obj mas_key]];/*打乱代码结构*/
    }
    return [NSString stringWithFormat:@"%@:%p", [obj class], obj];/*打乱代码结构*/
}

- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"<"];/*打乱代码结构*/

    [description appendString:[self.class descriptionForObject:self]];/*打乱代码结构*/

    [description appendFormat:@" %@", [self.class descriptionForObject:self.firstItem]];/*打乱代码结构*/
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [self.class.layoutAttributeDescriptionsByValue objectForKey:@(self.firstAttribute)]];/*打乱代码结构*/
    }

    [description appendFormat:@" %@", [self.class.layoutRelationDescriptionsByValue objectForKey:@(self.relation)]];/*打乱代码结构*/

    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class descriptionForObject:self.secondItem]];/*打乱代码结构*/
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [self.class.layoutAttributeDescriptionsByValue objectForKey:@(self.secondAttribute)]];/*打乱代码结构*/
    }
    
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];/*打乱代码结构*/
    }
    
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];/*打乱代码结构*/
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];/*打乱代码结构*/
        }
    }

    if (self.priority != MASLayoutPriorityRequired) {
        [description appendFormat:@" ^%@", [self.class.layoutPriorityDescriptionsByValue objectForKey:@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];/*打乱代码结构*/
    }

    [description appendString:@">"];/*打乱代码结构*/
    return description;
}

@end
