//
//  UITextView+YYHLimitCount.h
//  YYH_LimitCountAndPlaceholderTextView
//
//  Created by 杨昱航 on 2017/6/13.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (YYHLimitCount)
/** 限制字数*/
@property (nonatomic, assign) NSInteger YYH_limitCount;
/** lab的右边距(默认10)*/
@property (nonatomic, assign) CGFloat YYH_labMargin;
/** lab的高度(默认20)*/
@property (nonatomic, assign) CGFloat YYH_labHeight;
/** 统计限制字数Label*/
@property (nonatomic, readonly) UILabel *YYH_inputLimitLabel;
@end
