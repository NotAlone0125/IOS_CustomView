//
//  UITextView+YYHPlaceHolder.m
//  YYH_LimitCountAndPlaceholderTextView
//
//  Created by 杨昱航 on 2017/6/13.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "UITextView+YYHPlaceHolder.h"
#import <objc/runtime.h>
static const void *YYH_placeHolderKey;

@implementation UITextView (YYHPlaceHolder)

+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(YYHPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(YYHPlaceHolder_swizzled_dealloc)));
}


#pragma mark - swizzled
- (void)YYHPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self YYHPlaceHolder_swizzled_dealloc];
}
- (void)YYHPlaceHolder_swizzling_layoutSubviews {
    if (self.YYH_placeHolder) {
        //计算上self.textContainerInset，是考虑到使用者会重新复赋值
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.YYH_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.YYH_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self YYHPlaceHolder_swizzling_layoutSubviews];
}
#pragma mark set方法
//关于runtime：http://www.jianshu.com/c/dc947eab6af3
-(NSString *)YYH_placeHolder//类别不能添加属性，因此需要使用runtime动态添加
{
    return objc_getAssociatedObject(self, &YYH_placeHolderKey);
}
-(void)setYYH_placeHolder:(NSString *)YYH_placeHolder
{
    objc_setAssociatedObject(self, &YYH_placeHolderKey, YYH_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}

-(UIColor *)YYH_placeHolderColor
{
    return self.YYH_placeHolderLabel.textColor;
}
-(void)setYYH_placeHolderColor:(UIColor *)YYH_placeHolderColor
{
    self.YYH_placeHolderLabel.textColor = YYH_placeHolderColor;
}

- (void)updatePlaceHolder{
    if(self.text.length)//如果输入了文字，立马移除PlaceHolderLabel
    {
        [self.YYH_placeHolderLabel removeFromSuperview];
        return;
    }
    self.YYH_placeHolderLabel.font=self.font?self.font:[self cacutDefaultFont];
    self.YYH_placeHolderLabel.textAlignment=self.textAlignment;
    self.YYH_placeHolderLabel.text=self.YYH_placeHolder;
    [self insertSubview:self.YYH_placeHolderLabel atIndex:0];
}

-(UILabel *)YYH_placeHolderLabel
{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(YYH_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(YYH_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}


- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}

@end
