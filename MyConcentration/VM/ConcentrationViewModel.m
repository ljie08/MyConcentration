//
//  ConcentrationViewModel.m
//  MyConcentration
//
//  Created by ljie on 2017/12/1.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ConcentrationViewModel.h"

@implementation ConcentrationViewModel

+ (instancetype)sharedInstance {
    static ConcentrationViewModel *viewmodel = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        viewmodel = [[self alloc] init];
    });
    return viewmodel;
}

//获取
- (NSArray *)getConcentrationData {
    NSArray *modelArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[self localDataPath]];
    if (modelArr == nil) {
        modelArr = [NSArray array];
    }
    return modelArr;
}

//保存
- (void)saveConcentrationDataWithModel:(Concentration *)model {
    NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[self getConcentrationData]];
    
    [modelArr addObject:model];
    [NSKeyedArchiver archiveRootObject:modelArr toFile:[self localDataPath]];
}

//总数据
- (Total *)getTotalData {
    NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[self getConcentrationData]];
    
    NSMutableArray *dateArr = [NSMutableArray array];
    for (Concentration *model in modelArr) {
        [dateArr addObject:model.date];
    }
    //去除数组中重复的元素(日期)
    NSSet *set = [NSSet setWithArray:dateArr];
    
    Total *model = [[Total alloc] init];
    model.totalNum = modelArr.count;
    model.totalDays = set.allObjects.count;
    
    return model;
}

//柱状图数据



//归档路径
- (NSString *)localDataPath {
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"concentration.plist"];
    return listPath;
}

@end
