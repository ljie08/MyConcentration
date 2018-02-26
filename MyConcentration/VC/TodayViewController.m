//
//  TodayViewController.m
//  MyConcentration
//
//  Created by ljie on 2017/8/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TodayViewController.h"
#import "CircleProgressView.h"
#import "HistoryViewController.h"

@interface TodayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *normalLab;//今日专注
@property (weak, nonatomic) IBOutlet UILabel *todayLab;//今天的日期
@property (weak, nonatomic) IBOutlet UILabel *numberLab;//次数
@property (weak, nonatomic) IBOutlet UILabel *minutesLab;//分钟

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnPadding;

@property (nonatomic, strong) CircleProgressView *circleView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ConcentrationViewModel *viewmodel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(progressAction) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    //取消定时器
    [self.timer setFireDate:[NSDate distantFuture]];
//    self.timer = nil;
}

- (void)initViewModelBinding {
    self.viewmodel = [ConcentrationViewModel sharedInstance];
}

#pragma mark - click

//关闭
- (IBAction)closeToday:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//历史记录
- (void)showHistory {
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//刷新圆形进度条的进度
- (void)progressAction {
    if (self.circleView.percent >= 1.f) {
        self.circleView.percent = 0.0f;
    }
    self.circleView.percent += 0.01;
    NSLog(@"\npercent : %.2f", self.circleView.percent);
}

#pragma mark - UI
- (void)initUIView {
    CGFloat width = 150.0*Width_Scale;
    NSString *str = [LJUtil getTheTimeBucket];
    self.circleView = [[CircleProgressView alloc] initWithFrame:CGRectMake((Screen_Width-width)/2, 114*Heigt_Scale, width, width) title:str];
    [self.view addSubview:self.circleView];
    
    self.labPadding.constant = 70*Heigt_Scale;
    self.btnPadding.constant = 50*Heigt_Scale;
    
    [self setNav];
    [self setXibData];
}

//导航栏按钮
- (void)setNav {
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(0, 0, 30, 30);
    [showBtn setImage:[UIImage imageNamed:@"single"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:showBtn];
    [self addNavigationWithTitle:nil leftItem:leftItem rightItem:nil titleView:nil];
}

//xib中的数据
- (void)setXibData {
    self.circleView.titleLab.frame = CGRectMake(0, (CGRectGetWidth(self.circleView.frame)-80*Heigt_Scale)/2, CGRectGetWidth(self.circleView.frame), 80*Heigt_Scale);
    self.circleView.titleLab.numberOfLines = 0;
    self.circleView.titleLab.font = [UIFont systemFontOfSize:20];
    NSString *dateStr = [LJUtil getCurrentTimes];
    self.todayLab.text = [NSString stringWithFormat:@"%@", dateStr];
//***
//***
    NSArray *modelArr = [self.viewmodel getConcentrationData];
    NSInteger todayNum = 0;
    //取出数组中今天的次数
    for (Concentration *model in modelArr) {
        NSString *today = [LJUtil getZeroWithTimeInterverl];
        if ([model.date isEqualToString:today]) {
            todayNum++;
        }
    }
    self.numberLab.text = [NSString stringWithFormat:@"%ld", todayNum];
    self.minutesLab.text = [NSString stringWithFormat:@"%ld", todayNum*28];
//***
//***
    
    
/***
***
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
    }
    
    //key   : 2017-08-11
    //value : 2次
    //根据时间戳取次数
    //当前时间戳
    NSString *todayStr = [LJUtil getZeroWithTimeInterverl];
    NSInteger number = [[dic objectForKey:todayStr] integerValue];
    self.numberLab.text = [NSString stringWithFormat:@"%ld", number];
    //今天的分钟 次数*20
    self.minutesLab.text = [NSString stringWithFormat:@"%ld", number*20];
***
***/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
