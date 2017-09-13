//
//  ViewController.m
//  YYH_LeftCollection
//
//  Created by 杨昱航 on 2017/6/6.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "CollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property(nonatomic,strong)NSArray * allTextArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];

    [self initData];
    
    [self createMainView];
}
/*
 虚拟数据
 */
-(void)initData
{
    _allTextArr = @[@"19朵玫瑰礼盒", @"19朵红玫瑰礼盒+百合", @"33朵红玫瑰礼盒", @"33朵红玫瑰礼盒(三世情缘)", @"33朵香槟玫瑰礼盒(生日推荐)", @"38朵红玫瑰心连心礼盒(一见倾心)", @"19朵红玫瑰礼盒(热卖推荐)", @"19朵粉玫瑰礼盒(热卖推荐)", @"19朵混色玫瑰礼盒"];
}
/*
 创建视图
 */
-(void)createMainView{
    UICollectionViewLeftAlignedLayout * leftAlignedLayout=[[UICollectionViewLeftAlignedLayout alloc]init];
    leftAlignedLayout.minimumLineSpacing = 10;                          //最小行间距
    leftAlignedLayout.minimumInteritemSpacing = 10;                     //最小列间距
    leftAlignedLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);  //网格上左下右间距
    
    
    //网格
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:leftAlignedLayout];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    mainCollectionView.dataSource = self;
    mainCollectionView.delegate = self;
    [self.view addSubview:mainCollectionView];
    [mainCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
#pragma mark -UICollectionViewDataSource
//item内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [_allTextArr objectAtIndex:indexPath.row]];
    return cell;
}

//Section中item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allTextArr.count;
}

#pragma mark -UICollectionViewDelegate
//点击item触发方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -UICollectionViewDelegateFlowLayout
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textString = [_allTextArr objectAtIndex:indexPath.row];
    CGFloat cell_width = [self settingCollectionViewItemWidthBoundingWithText:textString];
    return CGSizeMake(cell_width, 30);
}

//计算文字宽度
- (CGFloat)settingCollectionViewItemWidthBoundingWithText:(NSString *)text{
    //1,设置内容大小  其中高度一定要与item一致,宽度度尽量设置大值
    CGSize size = CGSizeMake(MAXFLOAT, 30);
    //2,设置计算方式
    //3,设置字体大小属性   字体大小必须要与label设置的字体大小一致
    NSDictionary *attributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGRect frame = [text boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    //4.添加左右间距
    return frame.size.width + 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






