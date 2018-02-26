//
//  HistoryCell.m
//  MyConcentration
//
//  Created by ljie on 2017/8/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HistoryCell.h"
#import "Chart.h"

@implementation HistoryCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"HistoryCell";
    HistoryCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = CellBgColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    //获取当前日期的n天前或n天后
    //n为负数，为n天前，n为正数为n天后
    //获取当前日期的前一周
    //周二 周三 周四 周五 周六 周日 昨天 今天
    for (int i = 0; i < 7; i++) {
        NSString *str = [NSString string];
        str = [LJUtil getNDay:-i dateType:@"EEE"];
        if (i == 0) {
            str = NSLocalizedString(@"today", nil);
        }
        if (i == 1) {
            str = NSLocalizedString(@"yesterday", nil);
        }
        [titleArr addObject:str];
    }
    NSArray *titles = [[titleArr reverseObjectEnumerator] allObjects];//将数组中的周几倒序
    
    //柱状图
    NSArray *numArr = [NSArray arrayWithArray:[self getData]];
    numArr = [[numArr reverseObjectEnumerator] allObjects];//将数组中的次数倒序

    Chart *chartView = [[Chart alloc] initWithFrame:CGRectMake(15, 10, Screen_Width-60, 190-20)];
    chartView.numLabels = numArr;
    chartView.nameLabels = titles;
    [chartView showBarView];
    [self.contentView addSubview:chartView];
}

//获取次数数组
- (NSMutableArray *)getNumsData {
    NSArray *modelArr = [[ConcentrationViewModel sharedInstance] getConcentrationData];
    
    modelArr = [[modelArr reverseObjectEnumerator] allObjects];//将数组中的model倒序
    //xxx，前天，昨天，今天
    //变成 ->
    //今天，昨天，前天，xxx
    //近7天
    NSMutableArray *sevenArr = [NSMutableArray array];
    
    //数组大于7个数据
    if (modelArr.count >= 7) {
        
    } else {
        //数组小于7个数据
        
    }
    for (int i = 0; i < 7; i++) {
        if (modelArr.count) {
            [sevenArr addObject:modelArr[i]];
        } else {
            Concentration *model = modelArr[i];
            model.date = @"";
            model.num = 0;
            model.type = @"";
            [sevenArr addObject:model];
        }
    }
//    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *nums = [NSMutableArray array];
    //取出近7天的次数
    for (Concentration *model in sevenArr) {
        [nums addObject:[NSString stringWithFormat:@"%ld", model.num]];
    }
    
    return nums;
}


//获取次数数组
- (NSMutableArray *)getData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
    if (dic == nil) {
        dic = [NSDictionary dictionary];
    }
    
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSString *str = [NSString string];
        str = [LJUtil getNDay:-i dateType:@"yyyy-MM-dd"];
        str = [LJUtil getZeroTimeInterverlWithDateStr:str];
        
        NSInteger number = [[dic objectForKey:str] integerValue];
        [numArr addObject:[NSString stringWithFormat:@"%ld", number]];
    }
    return numArr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
