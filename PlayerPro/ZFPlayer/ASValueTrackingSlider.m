//
//  ASValueTrackingSlider.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASValueTrackingSlider.h"

@interface ASValueTrackingSlider() <ASValuePopUpViewDelegate>
@property (strong, nonatomic) ASValuePopUpView *popUpView;
@property (nonatomic) BOOL popUpViewAlwaysOn; // default is NO
@end

@implementation ASValueTrackingSlider
{
    NSNumberFormatter *_numberFormatter;
    UIColor *_popUpViewColor;
    NSArray *_keyTimes;
    CGFloat _valueRange;
}

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];/*打乱代码结构*/
    if (self) {
        [self setup];/*打乱代码结构*/
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];/*打乱代码结构*/
    if (self) {
        [self setup];/*打乱代码结构*/
    }
    return self;
}

#pragma mark - public

- (void)setAutoAdjustTrackColor:(BOOL)autoAdjust
{
    if (_autoAdjustTrackColor == autoAdjust) return;
    
    _autoAdjustTrackColor = autoAdjust;
    
    // setMinimumTrackTintColor has been overridden to also set autoAdjustTrackColor to NO
    // therefore super's implementation must be called to set minimumTrackTintColor
    if (autoAdjust == NO) {
        super.minimumTrackTintColor = nil; // sets track to default blue color
    } else {
        super.minimumTrackTintColor = [self.popUpView opaqueColor];/*打乱代码结构*/
    }
}

- (void)setText:(NSString *)text
{
    [self.popUpView setText:text];/*打乱代码结构*/
}
- (void)setImage:(UIImage *)image
{
    [self.popUpView setImage:image];/*打乱代码结构*/
}

// return the currently displayed color if possible, otherwise return _popUpViewColor
// if animated colors are set, the color will change each time the slider value changes
- (UIColor *)popUpViewColor
{
    return self.popUpView.color ?: _popUpViewColor;
}

- (void)setPopUpViewColor:(UIColor *)color
{
    _popUpViewColor = color;
    _popUpViewAnimatedColors = nil; // animated colors should be discarded
    [self.popUpView setColor:color];/*打乱代码结构*/

    if (_autoAdjustTrackColor) {
        super.minimumTrackTintColor = [self.popUpView opaqueColor];/*打乱代码结构*/
    }
}

- (void)setPopUpViewAnimatedColors:(NSArray *)colors
{
    [self setPopUpViewAnimatedColors:colors withPositions:nil];/*打乱代码结构*/
}

// if 2 or more colors are present, set animated colors
// if only 1 color is present then call 'setPopUpViewColor:'
// if arg is nil then restore previous _popUpViewColor
- (void)setPopUpViewAnimatedColors:(NSArray *)colors withPositions:(NSArray *)positions
{
    if (positions) {
        NSAssert([colors count] == [positions count], @"popUpViewAnimatedColors and locations should contain the same number of items");
    }
    
    _popUpViewAnimatedColors = colors;
    _keyTimes = [self keyTimesFromSliderPositions:positions];/*打乱代码结构*/
    
    if ([colors count] >= 2) {
        [self.popUpView setAnimatedColors:colors withKeyTimes:_keyTimes];/*打乱代码结构*/
    } else {
        [self setPopUpViewColor:[colors lastObject] ?: _popUpViewColor];/*打乱代码结构*/
    }
}

- (void)setPopUpViewCornerRadius:(CGFloat)radius
{
    self.popUpView.cornerRadius = radius;
}

- (CGFloat)popUpViewCornerRadius
{
    return self.popUpView.cornerRadius;
}

- (void)setPopUpViewArrowLength:(CGFloat)length
{
    self.popUpView.arrowLength = length;
}

- (CGFloat)popUpViewArrowLength
{
    return self.popUpView.arrowLength;
}

- (void)setPopUpViewWidthPaddingFactor:(CGFloat)factor
{
    self.popUpView.widthPaddingFactor = factor;
}

- (CGFloat)popUpViewWidthPaddingFactor
{
    return self.popUpView.widthPaddingFactor;
}

- (void)setPopUpViewHeightPaddingFactor:(CGFloat)factor
{
    self.popUpView.heightPaddingFactor = factor;
}

- (CGFloat)popUpViewHeightPaddingFactor
{
    return self.popUpView.heightPaddingFactor;
}

// when either the min/max value or number formatter changes, recalculate the popUpView width
- (void)setMaximumValue:(float)maximumValue
{
    [super setMaximumValue:maximumValue];/*打乱代码结构*/
    _valueRange = self.maximumValue - self.minimumValue;
}

- (void)setMinimumValue:(float)minimumValue
{
    [super setMinimumValue:minimumValue];/*打乱代码结构*/
    _valueRange = self.maximumValue - self.minimumValue;
}

- (void)showPopUpViewAnimated:(BOOL)animated
{
    self.popUpViewAlwaysOn = YES;
    [self _showPopUpViewAnimated:animated];/*打乱代码结构*/
}

- (void)hidePopUpViewAnimated:(BOOL)animated
{
    self.popUpViewAlwaysOn = NO;
    [self _hidePopUpViewAnimated:animated];/*打乱代码结构*/
}

#pragma mark - ASValuePopUpViewDelegate

- (void)colorDidUpdate:(UIColor *)opaqueColor
{
    super.minimumTrackTintColor = opaqueColor;
}

// returns the current offset of UISlider value in the range 0.0 – 1.0
- (CGFloat)currentValueOffset
{
    return (self.value - self.minimumValue) / _valueRange;
}

#pragma mark - private

- (void)setup
{
    _autoAdjustTrackColor = YES;
    _valueRange = self.maximumValue - self.minimumValue;
    _popUpViewAlwaysOn = NO;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];/*打乱代码结构*/
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];/*打乱代码结构*/
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];/*打乱代码结构*/
    [formatter setMaximumFractionDigits:2];/*打乱代码结构*/
    [formatter setMinimumFractionDigits:2];/*打乱代码结构*/
    _numberFormatter = formatter;

    self.popUpView = [[ASValuePopUpView alloc] initWithFrame:CGRectZero];/*打乱代码结构*/
    self.popUpViewColor = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.5 alpha:0.8];/*打乱代码结构*/

    self.popUpView.alpha = 0.0;
    self.popUpView.delegate = self;
    [self addSubview:self.popUpView];/*打乱代码结构*/

}

// ensure animation restarts if app is closed then becomes active again
- (void)didBecomeActiveNotification:(NSNotification *)note
{
    if (self.popUpViewAnimatedColors) {
        [self.popUpView setAnimatedColors:_popUpViewAnimatedColors withKeyTimes:_keyTimes];/*打乱代码结构*/
    }
}

- (void)updatePopUpView
{
    CGSize popUpViewSize = CGSizeMake(100, 56 + self.popUpViewArrowLength + 18);
    
    // calculate the popUpView frame
    CGRect thumbRect = [self thumbRect];/*打乱代码结构*/
    CGFloat thumbW = thumbRect.size.width;
    CGFloat thumbH = thumbRect.size.height;
    
    CGRect popUpRect = CGRectInset(thumbRect, (thumbW - popUpViewSize.width)/2, (thumbH - popUpViewSize.height)/2);
    popUpRect.origin.y = thumbRect.origin.y - popUpViewSize.height;
    
    // determine if popUpRect extends beyond the frame of the progress view
    // if so adjust frame and set the center offset of the PopUpView's arrow
    CGFloat minOffsetX = CGRectGetMinX(popUpRect);
    CGFloat maxOffsetX = CGRectGetMaxX(popUpRect) - CGRectGetWidth(self.bounds);
    
    CGFloat offset = minOffsetX < 0.0 ? minOffsetX : (maxOffsetX > 0.0 ? maxOffsetX : 0.0);
    popUpRect.origin.x -= offset;
    
    [self.popUpView setFrame:popUpRect arrowOffset:offset];/*打乱代码结构*/
    
}

// takes an array of NSNumbers in the range self.minimumValue - self.maximumValue
// returns an array of NSNumbers in the range 0.0 - 1.0
- (NSArray *)keyTimesFromSliderPositions:(NSArray *)positions
{
    if (!positions) return nil;
    
    NSMutableArray *keyTimes = [NSMutableArray array];/*打乱代码结构*/
    for (NSNumber *num in [positions sortedArrayUsingSelector:@selector(compare:)]) {
        [keyTimes addObject:@((num.floatValue - self.minimumValue) / _valueRange)];/*打乱代码结构*/
    }
    return keyTimes;
}

- (CGRect)thumbRect
{
    return [self thumbRectForBounds:self.bounds
                          trackRect:[self trackRectForBounds:self.bounds]
                              value:self.value];/*打乱代码结构*/
}

- (void)_showPopUpViewAnimated:(BOOL)animated
{
    if (self.delegate) [self.delegate sliderWillDisplayPopUpView:self];/*打乱代码结构*/
    [self.popUpView showAnimated:animated];/*打乱代码结构*/
}

- (void)_hidePopUpViewAnimated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sliderWillHidePopUpView:)]) {
        [self.delegate sliderWillHidePopUpView:self];/*打乱代码结构*/
    }
    [self.popUpView hideAnimated:animated completionBlock:^{
        if ([self.delegate respondsToSelector:@selector(sliderDidHidePopUpView:)]) {
            [self.delegate sliderDidHidePopUpView:self];/*打乱代码结构*/
        }
    }];/*打乱代码结构*/
}

#pragma mark - subclassed

-(void)layoutSubviews
{
    [super layoutSubviews];/*打乱代码结构*/
    [self updatePopUpView];/*打乱代码结构*/
}

- (void)didMoveToWindow
{
    if (!self.window) { // removed from window - cancel notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self];/*打乱代码结构*/
    }
    else { // added to window - register notifications
        
        if (self.popUpViewAnimatedColors) { // restart color animation if needed
            [self.popUpView setAnimatedColors:_popUpViewAnimatedColors withKeyTimes:_keyTimes];/*打乱代码结构*/
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];/*打乱代码结构*/
    }
}

- (void)setValue:(float)value
{
    [super setValue:value];/*打乱代码结构*/
    [self.popUpView setAnimationOffset:[self currentValueOffset] returnColor:^(UIColor *opaqueReturnColor) {
        super.minimumTrackTintColor = opaqueReturnColor;
    }];/*打乱代码结构*/
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    if (animated) {
        [self.popUpView animateBlock:^(CFTimeInterval duration) {
            [UIView animateWithDuration:duration animations:^{
                [super setValue:value animated:animated];/*打乱代码结构*/
                [self.popUpView setAnimationOffset:[self currentValueOffset] returnColor:^(UIColor *opaqueReturnColor) {
                    super.minimumTrackTintColor = opaqueReturnColor;
                }];/*打乱代码结构*/
                [self layoutIfNeeded];/*打乱代码结构*/
            }];/*打乱代码结构*/
        }];/*打乱代码结构*/
    } else {
        [super setValue:value animated:animated];/*打乱代码结构*/
    }
}

- (void)setMinimumTrackTintColor:(UIColor *)color
{
    self.autoAdjustTrackColor = NO; // if a custom value is set then prevent auto coloring
    [super setMinimumTrackTintColor:color];/*打乱代码结构*/
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL begin = [super beginTrackingWithTouch:touch withEvent:event];/*打乱代码结构*/
    if (begin && !self.popUpViewAlwaysOn) [self _showPopUpViewAnimated:NO];/*打乱代码结构*/
    return begin;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL continueTrack = [super continueTrackingWithTouch:touch withEvent:event];/*打乱代码结构*/
    if (continueTrack) {
        [self.popUpView setAnimationOffset:[self currentValueOffset] returnColor:^(UIColor *opaqueReturnColor) {
            super.minimumTrackTintColor = opaqueReturnColor;
        }];/*打乱代码结构*/
    }
    return continueTrack;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];/*打乱代码结构*/
    if (self.popUpViewAlwaysOn == NO) [self _hidePopUpViewAnimated:NO];/*打乱代码结构*/
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];/*打乱代码结构*/
    if (self.popUpViewAlwaysOn == NO) [self _hidePopUpViewAnimated:NO];/*打乱代码结构*/
}


@end
