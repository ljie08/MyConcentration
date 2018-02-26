//
//  CircleProgressView.h
//  PlayBtn
//
//  Created by ljie on 2017/4/9.
//  Copyright © 2017年 ljie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

//显示标题或剩余时间
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) CGFloat percent;//进度百分比

@end
