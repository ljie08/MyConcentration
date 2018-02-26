//
//  JJSLGuideView.h
//  JJSL
//
//  Created by zhouqixin on 16/3/30.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"

//上一次翻到第几页的key
#define GuideViewLastRead @"JJSLGuideViewLastReadPage"



@interface JJSLGuideView : UIScrollView

//需要展示的图片名字
@property (nonatomic, strong) NSArray *titles;

//需要展示的view的背景颜色值
@property (nonatomic, strong, getter=getColors) NSArray<NSString *> *colors;

//进度条
@property (nonatomic, strong) CircleProgressView *circleview;

//进度view数组
@property (nonatomic, strong) NSMutableArray *circleArr;

//判断当前第几页
@property (nonatomic, assign) NSInteger pageIndex;

//自定义pageControl
@property (nonatomic, strong) UIView *pageControl;


+ (instancetype)shareInstance;

@end


