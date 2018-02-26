//
//  DetailCell.h
//  MyConcentration
//
//  Created by ljie on 2017/12/1.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithType:(NSString *)type date:(NSString *)date num:(NSNumber *)num;
- (void)setDataWithModel:(Concentration *)model;

@end
