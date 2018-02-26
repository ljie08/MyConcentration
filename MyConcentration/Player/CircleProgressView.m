//
//  CircleProgressView.m
//  PlayBtn
//
//  Created by ljie on 2017/4/9.
//  Copyright © 2017年 ljie. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView ()

@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        
        //进度layer
        self.shapeLayer = [CAShapeLayer layer];
        
        self.shapeLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.shapeLayer.position = CGPointMake(CGRectGetWidth(frame)/2.f, CGRectGetHeight(frame)/2.f);
        self.shapeLayer.strokeColor = MyColor.CGColor;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.shapeLayer.lineWidth = 3.f;
        self.shapeLayer.lineJoin = kCALineJoinRound;//连接方式 圆
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.strokeStart = 0.f;
        self.shapeLayer.strokeEnd = 0.f;
        
        UIBezierPath * circularPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0) radius:CGRectGetWidth(self.frame)/2.f startAngle:2*M_PI * 0.75 endAngle:2*M_PI *0.74999 clockwise:YES];//起点默认从15刻钟的地方开始，设置从0刻钟的地方开始
        
        //底层layer
        CAShapeLayer * shapeL = [CAShapeLayer layer];
        shapeL.bounds = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        shapeL.position = CGPointMake(CGRectGetWidth(frame)/2.f, CGRectGetHeight(frame)/2.f);
        shapeL.path = circularPath.CGPath;
        UIColor *color = WhiteAlphaColor;
        shapeL.strokeColor = color.CGColor;
        shapeL.fillColor = [UIColor clearColor].CGColor;
        shapeL.lineWidth = 3.f;
        shapeL.lineJoin = kCALineJoinRound;
        shapeL.lineCap = kCALineCapRound;
        
        self.shapeLayer.path = circularPath.CGPath;
        
        [self.layer addSublayer:shapeL];
        [self.layer addSublayer:self.shapeLayer];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetWidth(frame)-40)/2, CGRectGetWidth(frame), 40)];
        self.titleLab.text = title;
        self.titleLab.textColor = FontColor;
        self.titleLab.font = [UIFont systemFontOfSize:38];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+10, CGRectGetWidth(frame), 30)];
        self.timeLab.textColor = FontColor;
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLab];
    }
    return self;
}

//进度条的百分比
- (void)setPercent:(CGFloat)percent {
    self.shapeLayer.strokeEnd = percent;

    _percent = percent;
}

@end
