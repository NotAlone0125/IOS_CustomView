//
//  CollectionViewCell.m
//  YYH_LeftCollection
//
//  Created by 杨昱航 on 2017/6/6.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor colorWithRed:251/255.0 green:74/255.0 blue:71/255.0 alpha:1];
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        self.layer.borderColor=[UIColor lightTextColor].CGColor;
        self.layer.borderWidth=0.5;
        
        [self createSubView];
    }
    return self;
}
-(void)createSubView
{
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.textAlignment=1;
    _titleLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
}
@end
