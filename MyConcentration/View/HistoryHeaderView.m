//
//  HistoryHeaderView.m
//  MyConcentration
//
//  Created by ljie on 2017/8/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HistoryHeaderView.h"

@interface HistoryHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *hoursLab;
@property (weak, nonatomic) IBOutlet UILabel *daysLab;

@end

@implementation HistoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setLabelData];
}

- (void)setLabelData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }
    
    //总次数
    NSInteger num = 0;
    
    //天数大于1，计算和，小于1直接赋值
    if (dict.allValues.count > 1) {
        for (int i = 0; i < dict.allValues.count; i++) {
            NSInteger num1 = [dict.allValues[i] integerValue];
            NSInteger num2 = [dict.allValues[i+1] integerValue];
            num = num1+num2;
        }
    } else {
        num = dict.allValues.count>0?[dict.allValues[0] integerValue]:0;
    }
    //总天数
    NSInteger days = dict.allKeys.count;
    
    self.numLab.text = [NSString stringWithFormat:@"%ld", num];
    self.hoursLab.text = [NSString stringWithFormat:@"%.2f", num*20.0/60.0];
    self.daysLab.text = [NSString stringWithFormat:@"%ld", days];
}

@end
