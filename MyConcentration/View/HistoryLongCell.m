//
//  HistoryLongCell.m
//  MyConcentration
//
//  Created by ljie on 2017/8/14.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HistoryLongCell.h"

@interface HistoryLongCell ()

@property (weak, nonatomic) IBOutlet UILabel *minutesLab;//时长
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//日期
@property (weak, nonatomic) IBOutlet UILabel *numLab;//次数

@end

@implementation HistoryLongCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"HistoryLongCell";
    HistoryLongCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HistoryLongCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = CellBgColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    [cell getMaxNumberAndDate];
    
    return cell;
}

//获取次数最大的日期
- (void)getMaxNumberAndDate {
    NSInteger maxNum = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
    //比较得出时间最长的value
    for (id num in dic.allValues) {
        if ([num floatValue] > maxNum) {
            maxNum = [num floatValue];
        }
    }
    
    //得出最长的value对应的key(日期)
    static NSString *dateStr;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key:%@ - obj:%@", key, obj);
        if (maxNum == [obj integerValue]) {
            NSString *str = [LJUtil timeInterverlToDateStr:key];
            dateStr = str;//block里不能直接访问外部的变量
        }
    }];
    NSLog(@"dateStr ---   %@", dateStr);
    
    self.minutesLab.text = [NSString stringWithFormat:@"%@ %ld %@", NSLocalizedString(@"all", nil), maxNum*28, NSLocalizedString(@"fen", nil)];
    self.dateLab.text = dateStr==nil?NSLocalizedString(@"nodate", nil):dateStr;
    self.numLab.text = [NSString stringWithFormat:@"%ld", maxNum];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
