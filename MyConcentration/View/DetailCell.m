//
//  DetailCell.m
//  MyConcentration
//
//  Created by ljie on 2017/12/1.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "DetailCell.h"

@interface DetailCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *minuteLab;

@end

@implementation DetailCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"DetailCell";
    DetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.backgroundColor = WhiteAlphaColor;
    
    return cell;
}

- (void)setDataWithModel:(Concentration *)model {
    model.date = [LJUtil timeInterverlToDateStr:model.date];
    self.typeLab.text = model.type;
    self.dateLab.text = model.date;
    self.minuteLab.text = [NSString stringWithFormat:@"%ld%@", model.num*28, NSLocalizedString(@"fen", nil)];
}

- (void)setDataWithType:(NSString *)type date:(NSString *)date num:(NSNumber *)num {
    self.dateLab.text = date;
    NSInteger minute = [num integerValue];
    self.minuteLab.text = [NSString stringWithFormat:@"%ld%@", minute*28, NSLocalizedString(@"fen", nil)];
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
