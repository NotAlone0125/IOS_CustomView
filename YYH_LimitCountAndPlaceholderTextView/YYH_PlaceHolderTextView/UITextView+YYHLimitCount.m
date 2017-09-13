//
//  UITextView+YYHLimitCount.m
//  YYH_LimitCountAndPlaceholderTextView
//
//  Created by 杨昱航 on 2017/6/13.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "UITextView+YYHLimitCount.h"


#import <objc/runtime.h>
static char limitCountKey;
static char labMarginKey;
static char labHeightKey;
@implementation UITextView (YYHLimitCount)

+ (void)load {
    [super load];
    //替换实现，如果两个扩展类中都出现layoutSubviews方法，则会被覆盖。
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(YYHlimitCounter_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(YYHlimitCounter_swizzled_dealloc)));
}
#pragma mark - swizzled
- (void)YYHlimitCounter_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self YYHlimitCounter_swizzled_dealloc];
}
- (void)YYHlimitCounter_swizzling_layoutSubviews {
    [self YYHlimitCounter_swizzling_layoutSubviews];
    if (self.YYH_limitCount) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        textContainerInset.bottom = self.YYH_labHeight;
        self.contentInset = textContainerInset;
        CGFloat x = CGRectGetMinX(self.frame)+self.layer.borderWidth;
        CGFloat y = CGRectGetMaxY(self.frame)-self.contentInset.bottom-self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds)-self.layer.borderWidth*2;
        CGFloat height = self.YYH_labHeight;
        self.YYH_inputLimitLabel.frame = CGRectMake(x, y, width, height);
        if ([self.superview.subviews containsObject:self.YYH_inputLimitLabel]) {
            return;
        }
        [self.superview insertSubview:self.YYH_inputLimitLabel aboveSubview:self];
    }
}
#pragma mark - associated
-(NSInteger)YYH_limitCount{
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}
- (void)setYYH_limitCount:(NSInteger)YYH_limitCount{
    objc_setAssociatedObject(self, &limitCountKey, @(YYH_limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(CGFloat)YYH_labMargin{
    return [objc_getAssociatedObject(self, &labMarginKey) floatValue];
}
-(void)setYYH_labMargin:(CGFloat)YYH_labMargin{
    objc_setAssociatedObject(self, &labMarginKey, @(YYH_labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(CGFloat)YYH_labHeight{
    return [objc_getAssociatedObject(self, &labHeightKey) floatValue];
}
-(void)setYYH_labHeight:(CGFloat)YYH_labHeight{
    objc_setAssociatedObject(self, &labHeightKey, @(YYH_labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
#pragma mark -config
- (void)configTextView{
    self.YYH_labHeight = 20;
    self.YYH_labMargin = 10;
}
#pragma mark - update
- (void)updateLimitCount{
    if (self.text.length>self.YYH_limitCount) {
        self.text = [self.text substringToIndex:self.YYH_limitCount];
    }
    NSString *showText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.YYH_limitCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                              alloc] initWithString:showText];
    NSUInteger length = [showText length];
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.tailIndent = -self.YYH_labMargin; //设置与尾部的距离
    style.alignment = NSTextAlignmentRight;//靠右显示
    [attrString addAttribute:NSParagraphStyleAttributeName value:style
                       range:NSMakeRange(0, length)];
    self.YYH_inputLimitLabel.attributedText = attrString;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"layer.borderWidth"]) {
        [self updateLimitCount];
    }
}
#pragma mark - lazzing
-(UILabel *)YYH_inputLimitLabel{
    UILabel *label = objc_getAssociatedObject(self, @selector(YYH_inputLimitLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        objc_setAssociatedObject(self, @selector(YYH_inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLimitCount)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [self addObserver:self forKeyPath:@"layer.borderWidth" options:NSKeyValueObservingOptionNew context:nil];
        [self configTextView];
    }
    return label;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
