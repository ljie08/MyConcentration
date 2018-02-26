//
//  JJSLGuideView.m
//  JJSL
//
//  Revised by ljie on 2017/4/17 Version1.0.1.
//  Created by zhouqixin on 16/3/30.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import "JJSLGuideView.h"

@interface JJSLGuideView ()

//读出颜色的值
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorMutArr;

@end

@implementation JJSLGuideView

+ (instancetype)shareInstance {
    JJSLGuideView *guideView = [[JJSLGuideView alloc] init];
    return guideView;
}

#pragma mark - overwrite method
- (instancetype)init {
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    _circleArr = [NSMutableArray array];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.frame = [UIScreen mainScreen].bounds;
    _circleArr = [NSMutableArray array];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.frame = [UIScreen mainScreen].bounds;
    _circleArr = [NSMutableArray array];
    return self;
}

- (void)setColors:(NSArray *)colors {
    _colors = colors;
    //执行操作
    [self toDoList];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
}

//guideview执行列表
- (void)toDoList {
    //如果读取不到颜色，返回
    if (![self readColors]) {
        return;
    }
    
    //设置scrollview属性
    [self setScrollViewParams];
    
    //设置颜色view
    [self setScrollViewColors];
    
    //设置pageControl
    [self setScrollViewPageControl];
}

//设置scrollview属性
- (void)setScrollViewParams {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    self.scrollsToTop = NO;
    
    self.contentSize = CGSizeMake(self.bounds.size.width * self.colorMutArr.count, Screen_Height);
    
    self.pagingEnabled = YES;
    //监听offset
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

//监听scrollview的contentoffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *pointValue = [change objectForKey:@"new"];
        CGPoint point;
        [pointValue getValue:&point];
        [self setCurrentPage:point];
        NSLog(@"%ld",self.pageIndex);
    }
}

//设置pageControl当前的页码
- (void)setCurrentPage:(CGPoint)point{
    NSInteger index = fabs(point.x) / self.bounds.size.width;
    
    if (self.pageIndex != index) {
        self.pageIndex = index;
        for (int i = 0; i < self.colorMutArr.count; i++) {
            UIImageView *pageImageView = (UIImageView *)[self.pageControl viewWithTag:1000 + i];
            if (pageImageView.tag == self.pageIndex + 1000) {
                pageImageView.backgroundColor = MyColor;
            } else {
                pageImageView.backgroundColor = WhiteAlphaColor;
            }
        }
    }
}

//设置带有颜色的透明视图
- (void)setScrollViewColors {
    CGFloat width = 240.0*Width_Scale;
    for (int i = 0; i < self.colorMutArr.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectOffset(self.bounds, self.bounds.size.width * i, 0);
        view.backgroundColor = [self.colorMutArr[i] colorWithAlphaComponent:0.3];
        
        self.circleview = [[CircleProgressView alloc] initWithFrame:CGRectMake((Screen_Width-width)/2, 115*Heigt_Scale, width, width) title:self.titles[i]];
        
        [view addSubview:self.circleview];
        [self.circleArr addObject:self.circleview];
        [self addSubview:view];
    }
}

//设置pageControl
- (void)setScrollViewPageControl {
    //(240-40)/2+40+10
    self.pageIndex = 0;
    self.pageControl = [[UIView alloc] init];
    if (self.bounds.size.width - self.colorMutArr.count * 20 > 0) {//根据图片的个数来改变宽度，目前最大支持12张图片
        self.pageControl.frame = CGRectMake((self.bounds.size.width - self.colorMutArr.count * 20 + 10) / 2, CGRectGetMaxY(self.circleview.frame)+40*Heigt_Scale, self.colorMutArr.count * 20 - 10, 10);
    } else {
        self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 50*Heigt_Scale, self.bounds.size.width, 10);
    }
    
    [self.superview addSubview:self.pageControl];
    for (int i = 0; i < self.colorMutArr.count; i++) {
        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * i, 0, 10, 10)];
        pageImageView.layer.cornerRadius = 5;
        pageImageView.layer.masksToBounds = YES;
        pageImageView.tag = 1000 + i;
        if (i == 0) {
            pageImageView.backgroundColor = MyColor;
        } else {
            pageImageView.backgroundColor = WhiteAlphaColor;
        }
        [self.pageControl addSubview:pageImageView];
    }
}

//根据颜色获得颜色数组
- (BOOL)readColors {
    if (!self.colors || ![self.colors isKindOfClass:[NSArray class]]) {
        return NO;
    } else if (self.colors.count == 0) {
        return NO;
    } else {
        self.colorMutArr = [NSMutableArray arrayWithCapacity:self.colors.count];
        for (NSString *str in self.colors) {
            UIColor *color = [LJUtil hexStringToColor:str];
            if (str.length > 0) {
                [self.colorMutArr addObject:color];
            }
        }
        if (self.colorMutArr.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
