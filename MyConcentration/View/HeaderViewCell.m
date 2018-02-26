//
//  HeaderViewCell.m
//  MyConcentration
//
//  Created by ljie on 2017/8/15.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HeaderViewCell.h"

@interface HeaderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *hoursLab;
@property (weak, nonatomic) IBOutlet UILabel *daysLab;

@end

@implementation HeaderViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"HeaderViewCell";
    HeaderViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HeaderViewCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setDateWithModel:(Total *)model {
    self.numLab.text = [NSString stringWithFormat:@"%ld", model.totalNum];
    self.hoursLab.text = [NSString stringWithFormat:@"%.2f", model.totalHours];
    self.daysLab.text = [NSString stringWithFormat:@"%ld", model.totalDays];
}

- (void)setLabelData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }
    
    NSArray *modelArr = [[ConcentrationViewModel sharedInstance] getConcentrationData];
    NSInteger todayNum = 0;
    //取出数组中今天的次数
    for (Concentration *model in modelArr) {
        NSString *today = [LJUtil getZeroWithTimeInterverl];
        if ([model.date isEqualToString:today]) {
            todayNum++;
        }
    }
    
    //总次数
    NSInteger num = 0;
    
    //天数大于1，计算和，小于1直接赋值
    if (dict.allValues.count > 1) {
        for (int i = 0; i < dict.allValues.count; i++) {
            if (i < dict.allValues.count - 1) {
                
                NSInteger num1 = [dict.allValues[i] integerValue];
                NSInteger num2 = [dict.allValues[i+1] integerValue];
                num = num1+num2;
            }
        }
    } else {
        num = dict.allValues.count>0?[dict.allValues[0] integerValue]:0;
    }
    //总天数
    NSInteger days = dict.allKeys.count;
    
    self.numLab.text = [NSString stringWithFormat:@"%ld", num];
    self.hoursLab.text = [NSString stringWithFormat:@"%.2f", num*80.0/60.0];
    self.daysLab.text = [NSString stringWithFormat:@"%ld", days];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self setLabelData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
