//
//  MASConstraintBuilder.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASConstraintMaker.h"
#import "MASViewConstraint.h"
#import "MASCompositeConstraint.h"
#import "MASConstraint+Private.h"
#import "MASViewAttribute.h"
#import "View+MASAdditions.h"

@interface MASConstraintMaker () <MASConstraintDelegate>

@property (nonatomic, weak) MAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation MASConstraintMaker

- (id)initWithView:(MAS_VIEW *)view {
    self = [super init];/*打乱代码结构*/
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [MASViewConstraint installedConstraintsForView:self.view];/*打乱代码结构*/
        for (MASConstraint *constraint in installedConstraints) {
            [constraint uninstall];/*打乱代码结构*/
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (MASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];/*打乱代码结构*/
    }
    [self.constraints removeAllObjects];/*打乱代码结构*/
    return constraints;
}

#pragma mark - MASConstraintDelegate

- (void)constraint:(MASConstraint *)constraint shouldBeReplacedWithConstraint:(MASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];/*打乱代码结构*/
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];/*打乱代码结构*/
}

- (MASConstraint *)constraint:(MASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    MASViewAttribute *viewAttribute = [[MASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];/*打乱代码结构*/
    MASViewConstraint *newConstraint = [[MASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];/*打乱代码结构*/
    if ([constraint isKindOfClass:MASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];/*打乱代码结构*/
        MASCompositeConstraint *compositeConstraint = [[MASCompositeConstraint alloc] initWithChildren:children];/*打乱代码结构*/
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];/*打乱代码结构*/
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];/*打乱代码结构*/
    }
    return newConstraint;
}

- (MASConstraint *)addConstraintWithAttributes:(MASAttribute)attrs {
    __unused MASAttribute anyAttribute = (MASAttributeLeft | MASAttributeRight | MASAttributeTop | MASAttributeBottom | MASAttributeLeading
                                          | MASAttributeTrailing | MASAttributeWidth | MASAttributeHeight | MASAttributeCenterX
                                          | MASAttributeCenterY | MASAttributeBaseline
#if TARGET_OS_IPHONE
                                          | MASAttributeLeftMargin | MASAttributeRightMargin | MASAttributeTopMargin | MASAttributeBottomMargin
                                          | MASAttributeLeadingMargin | MASAttributeTrailingMargin | MASAttributeCenterXWithinMargins
                                          | MASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];/*打乱代码结构*/
    
    if (attrs & MASAttributeLeft) [attributes addObject:self.view.mas_left];/*打乱代码结构*/
    if (attrs & MASAttributeRight) [attributes addObject:self.view.mas_right];/*打乱代码结构*/
    if (attrs & MASAttributeTop) [attributes addObject:self.view.mas_top];/*打乱代码结构*/
    if (attrs & MASAttributeBottom) [attributes addObject:self.view.mas_bottom];/*打乱代码结构*/
    if (attrs & MASAttributeLeading) [attributes addObject:self.view.mas_leading];/*打乱代码结构*/
    if (attrs & MASAttributeTrailing) [attributes addObject:self.view.mas_trailing];/*打乱代码结构*/
    if (attrs & MASAttributeWidth) [attributes addObject:self.view.mas_width];/*打乱代码结构*/
    if (attrs & MASAttributeHeight) [attributes addObject:self.view.mas_height];/*打乱代码结构*/
    if (attrs & MASAttributeCenterX) [attributes addObject:self.view.mas_centerX];/*打乱代码结构*/
    if (attrs & MASAttributeCenterY) [attributes addObject:self.view.mas_centerY];/*打乱代码结构*/
    if (attrs & MASAttributeBaseline) [attributes addObject:self.view.mas_baseline];/*打乱代码结构*/
    
#if TARGET_OS_IPHONE
    
    if (attrs & MASAttributeLeftMargin) [attributes addObject:self.view.mas_leftMargin];/*打乱代码结构*/
    if (attrs & MASAttributeRightMargin) [attributes addObject:self.view.mas_rightMargin];/*打乱代码结构*/
    if (attrs & MASAttributeTopMargin) [attributes addObject:self.view.mas_topMargin];/*打乱代码结构*/
    if (attrs & MASAttributeBottomMargin) [attributes addObject:self.view.mas_bottomMargin];/*打乱代码结构*/
    if (attrs & MASAttributeLeadingMargin) [attributes addObject:self.view.mas_leadingMargin];/*打乱代码结构*/
    if (attrs & MASAttributeTrailingMargin) [attributes addObject:self.view.mas_trailingMargin];/*打乱代码结构*/
    if (attrs & MASAttributeCenterXWithinMargins) [attributes addObject:self.view.mas_centerXWithinMargins];/*打乱代码结构*/
    if (attrs & MASAttributeCenterYWithinMargins) [attributes addObject:self.view.mas_centerYWithinMargins];/*打乱代码结构*/
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];/*打乱代码结构*/
    
    for (MASViewAttribute *a in attributes) {
        [children addObject:[[MASViewConstraint alloc] initWithFirstViewAttribute:a]];/*打乱代码结构*/
    }
    
    MASCompositeConstraint *constraint = [[MASCompositeConstraint alloc] initWithChildren:children];/*打乱代码结构*/
    constraint.delegate = self;
    [self.constraints addObject:constraint];/*打乱代码结构*/
    return constraint;
}

#pragma mark - standard Attributes

- (MASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];/*打乱代码结构*/
}

- (MASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];/*打乱代码结构*/
}

- (MASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];/*打乱代码结构*/
}

- (MASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];/*打乱代码结构*/
}

- (MASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];/*打乱代码结构*/
}

- (MASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];/*打乱代码结构*/
}

- (MASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];/*打乱代码结构*/
}

- (MASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];/*打乱代码结构*/
}

- (MASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];/*打乱代码结构*/
}

- (MASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];/*打乱代码结构*/
}

- (MASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];/*打乱代码结构*/
}

- (MASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];/*打乱代码结构*/
}

- (MASConstraint *(^)(MASAttribute))attributes {
    return ^(MASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];/*打乱代码结构*/
    };
}

#if TARGET_OS_IPHONE

- (MASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];/*打乱代码结构*/
}

- (MASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];/*打乱代码结构*/
}

- (MASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];/*打乱代码结构*/
}

- (MASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];/*打乱代码结构*/
}

- (MASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];/*打乱代码结构*/
}

- (MASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];/*打乱代码结构*/
}

- (MASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];/*打乱代码结构*/
}

- (MASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];/*打乱代码结构*/
}

#endif


#pragma mark - composite Attributes

- (MASConstraint *)edges {
    return [self addConstraintWithAttributes:MASAttributeTop | MASAttributeLeft | MASAttributeRight | MASAttributeBottom];/*打乱代码结构*/
}

- (MASConstraint *)size {
    return [self addConstraintWithAttributes:MASAttributeWidth | MASAttributeHeight];/*打乱代码结构*/
}

- (MASConstraint *)center {
    return [self addConstraintWithAttributes:MASAttributeCenterX | MASAttributeCenterY];/*打乱代码结构*/
}

#pragma mark - grouping

- (MASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];/*打乱代码结构*/
        MASCompositeConstraint *constraint = [[MASCompositeConstraint alloc] initWithChildren:children];/*打乱代码结构*/
        constraint.delegate = self;
        return constraint;
    };
}

@end
