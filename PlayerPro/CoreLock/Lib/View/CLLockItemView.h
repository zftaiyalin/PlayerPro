//
//  CLLockItemView.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    //正上
    LockItemViewDirecTop=1,
    
    //右上
    LockItemViewDirecRightTop,
    
    //右
    LockItemViewDirecRight,
    
    //右下
    LockItemViewDiretRightBottom,
    
    //下
    LockItemViewDirecBottom,
    
    //左下
    LockItemViewDirecLeftBottom,
    
    //左
    LockItemViewDirecLeft,
    
    //左上
    LockItemViewDirecLeftTop,

}LockItemViewDirect;




@interface CLLockItemView : UIView




/** 是否选中 */
@property (nonatomic,assign) BOOL selected;



/** 方向 */
@property (nonatomic,assign) LockItemViewDirect direct;




@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com