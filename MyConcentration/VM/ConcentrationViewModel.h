//
//  ConcentrationViewModel.h
//  MyConcentration
//
//  Created by ljie on 2017/12/1.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcentrationViewModel : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)getConcentrationData;

- (void)saveConcentrationDataWithModel:(Concentration *)model;

- (Total *)getTotalData;

@end
