//
//  HeaderViewCell.h
//  MyConcentration
//
//  Created by ljie on 2017/8/15.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDateWithModel:(Total *)model;

@end
