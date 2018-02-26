//
//  DetailViewController.m
//  MyConcentration
//
//  Created by ljie on 2017/12/1.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "UITableView+HD_NoList.h"

@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView *detailTable;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *numArr;
@property (nonatomic, strong) NSMutableArray *typeArr;
@property (nonatomic, strong) NSArray *conArr;

@property (nonatomic, strong) ConcentrationViewModel *viewmodel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewmodel = [[ConcentrationViewModel alloc] init];
    [self loadData];
}

- (NSArray *)conArr {
    if (_conArr == nil) {
        _conArr = [NSArray array];
    }
    return _conArr;
}

- (void)loadData {
    self.conArr = [[ConcentrationViewModel sharedInstance] getConcentrationData];
    self.conArr = [[self.conArr reverseObjectEnumerator] allObjects];//将数组中的周几倒序
    if (!self.conArr.count) {
        [self.detailTable showNoView:NSLocalizedString(@"还没有数据", nil) image:nil certer:CGPointZero x:20];
    } else {
        [self.detailTable dismissNoView];
    }
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.conArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [DetailCell myCellWithTableview:tableView];
    
    if (self.conArr.count) {
        [cell setDataWithModel:self.conArr[indexPath.section]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
//    [self initTitleViewWithTitle:NSLocalizedString(@"演员表", nil)];
    [self addNavigationWithTitle:NSLocalizedString(@"所有数据", nil) leftItem:nil rightItem:nil titleView:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

