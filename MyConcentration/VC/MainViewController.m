//
//  MainViewController.m
//  MyConcentration
//
//  Created by ljie on 2017/8/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MainViewController.h"
#import "TodayViewController.h"//今日数据
#import "CircleProgressView.h"//圆形进度
#import "JJSLGuideView.h"//可滑动的切换view
#import "MyPlayer.h"//播放

@interface MainViewController ()<UIAlertViewDelegate> {
    JJSLGuideView *_colorView;//可以滑动切换的view
    UIButton *_stopBtn;//停止按钮
    MyPlayer *_myplayer;//音乐播放
    CircleProgressView *_progress;//圆形进度条
}

@property (nonatomic, strong) NSTimer * progressTimer;//进度条
@property (nonatomic, strong) NSTimer *countTimer;//倒计时

@property (nonatomic, assign) NSInteger second;//秒
@property (nonatomic, assign) NSInteger minute;//分

@property (nonatomic, assign) NSInteger allSecond;//倒计时所剩的总秒数

@property (nonatomic, strong) ConcentrationViewModel *viewmodel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewmodel = [[ConcentrationViewModel alloc] init];
}

#pragma mark - Click
//跳转到今天VC
- (void)showTodayData {
    TodayViewController *today = [[TodayViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:today];
    [self presentViewController:nav animated:YES completion:nil];
}

//开始或暂停
//28分钟 28*60 1680秒每12秒运行一次progressAction方法，100次运行完成
- (void)beginPlay:(UIButton *)button {
    //判断点击开始的时候当前是第几页
    _progress = _colorView.circleArr[_colorView.pageIndex];
    
    if (self.second == 60) {//第一次显示为20:00
#pragma mark --
        _progress.timeLab.text = [NSString stringWithFormat:@"28:00"];
    }
    _colorView.scrollEnabled = NO;//不可以滑动
    _colorView.pageControl.hidden = YES;
    button.selected = !button.selected;
    //先判断是否在播放。如果在播放就停止，
    [_myplayer playOrStopMusic];
    
    //根据button的选中状态判断是否播放音乐或暂停，倒计时是否开始
    if (button.selected) {
        //开始
        //计时器开始，并播放音乐
        self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        
        self.progressTimer =  [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(circleprogressAction) userInfo:nil repeats:YES];
        _stopBtn.hidden = NO;
        
        NSArray *musicArr = [NSArray arrayWithObjects:@"Larrons En Foire", @"Tassel", @"My Soul", @"A Little Story", nil];
        NSLog(@"播放的-- %@", musicArr[_colorView.pageIndex]);
        [_myplayer playMusicWithName:musicArr[_colorView.pageIndex]];
        
    } else {
        //暂停
        [self.progressTimer setFireDate:[NSDate distantFuture]];
        [self.countTimer setFireDate:[NSDate distantFuture]];
    }
    [button setTitle:NSLocalizedString(@"continue", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"pause", nil) forState:UIControlStateSelected];
}

#pragma mark - 事件
//取消
//计时归零，计时器取消，播放停止
- (void)cancelTimer:(UIButton *)button {
    _colorView.scrollEnabled = YES;//可以滑动
    _colorView.pageControl.hidden = NO;
    
    //取消按钮隐藏
    button.hidden = YES;

    //关闭定时器 后边还能再开启
    [self stopTimerAndPlayer];
    [self resetData];
}

//关闭定时器，并停止播放
- (void)stopTimerAndPlayer {
    //关闭定时器 后边还能再开启
    [self.progressTimer setFireDate:[NSDate distantFuture]];
    [self.countTimer setFireDate:[NSDate distantFuture]];
    
    [_myplayer.player stop];//停止播放
    NSLog(@"停止");
    
    [self setBeginBtnTitle:NSLocalizedString(@"begin", nil)];
}

//重置数据
- (void)resetData {
    _progress.percent = 0.0f;//进度置为0
    
    _progress.timeLab.text = @"";//倒计时不显示
    self.second = 60;
#pragma mark ---
    self.minute = 27;
}

//圆形进度条进度
- (void)circleprogressAction {
    NSLog(@"\npercent : %.2f", _progress.percent);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (_progress.percent >= 1.f) {
        //进度完成，定时器关闭，进度条置为0，倒计时结束，时间恢复0，改变按钮title
        
        [self setBeginBtnTitle:NSLocalizedString(@"finish", nil)];
        
        //进度完成的时候，次数加1，保存
        
        //保存model
//
//***
        Concentration *model = [[Concentration alloc] init];
//        model.date = [LJUtil getNowDateTimeString];
        model.date = [LJUtil getZeroWithTimeInterverl];
        model.num = 1;
        model.type = _colorView.titles[_colorView.pageIndex];
        
        [self.viewmodel saveConcentrationDataWithModel:model];
//***
//***
//***
        

//***
//***
        //只保存时间和次数
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"dic"]];
        if (dic == nil) {
            dic = [NSMutableDictionary dictionary];
        }
        
        NSString *currentTime = [LJUtil getZeroWithTimeInterverl];//当前时间戳
        
        //用当前日期取字典里对应的次数，
        //先将存的字典取出来，如果是第一次，则数据为空，将次数和时间存字典再保存，
        //根据当前时间戳取次数，次数修改后再保存
        
        NSInteger num = [dic[currentTime] integerValue];
        num = num + 1;
        [dic setObject:[NSNumber numberWithInteger:num] forKey:currentTime];
        
        NSLog(@"%@", dic);
        [defaults setObject:dic forKey:@"dic"];
//***
//***
        
        
        //关闭定时器
        [self stopTimerAndPlayer];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"wancheng" message:@"haha" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _stopBtn.hidden = YES;
            [self resetData];
            _colorView.scrollEnabled = YES;//可以滑动
            _colorView.pageControl.hidden = NO;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    
#pragma mark ---
    //28分钟 1680秒
    NSLog(@"allSecond - %f",self.allSecond/1680.0);
    //进度百分比再倒计时的时候设置
//    _progress.percent = 1-self.allSecond/1680.0;
}

#pragma mark - 倒计时
- (void)countDown {
    if (self.second > 0) {
        self.second--;
    } else {
        //01:00 将时间置为初始值
        self.second = 59;
    }
    NSString *secondStr = [NSString string];
    NSString *minuteStr = [NSString string];
    if (self.second < 10 && self.second >= 0) {
        secondStr = [NSString stringWithFormat:@"0%ld", self.second];
    } else {
        secondStr = [NSString stringWithFormat:@"%ld", self.second];
    }
    
    if (self.minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld", self.minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%ld", self.minute];
    }
    
    //当剩余时间为01:00时，先计算剩是秒数，再minute--。否则本来还剩1分钟的时间，却分为0，秒也为0
    self.allSecond = self.minute*60+self.second;
    
    _progress.timeLab.text = [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
    
#pragma mark ---
    //28分钟 1680秒
    NSLog(@"allSecond - %f",self.allSecond/1680.0);
    //进度百分比
    //先赋值，走到进度条的定时器方法根据进度是否为1确定是否取消定时器
#pragma mark ---
    _progress.percent = 1-self.allSecond/1680.0;
    
    if (self.second == 0) {
        if (self.minute>0) {
            self.minute--;
        } else {
            //00:00 将时间置为初始值
#pragma mark ---
            self.minute = 27;
        }
    }
}

#pragma mark - UI
- (void)initUIView {
    _progress = [[CircleProgressView alloc] init];
    [self setUpColorView];
    [self setUpOtherUI];
}

//创建滑动页
- (void)setUpColorView {
    _colorView = [[JJSLGuideView alloc] init];
    _colorView.titles = @[NSLocalizedString(@"lively", nil), NSLocalizedString(@"stroll", nil), NSLocalizedString(@"sleep", nil), NSLocalizedString(@"alone", nil)];
    _colorView.colors = @[@"FFFFFF", @"#37A6FF", @"#FDE673", @"DCA6E3"];//默认 蓝 黄 绿 紫
    
    [self.view addSubview:_colorView];
    [self.view addSubview:_colorView.pageControl];
}

//底部按钮和label
- (void)setUpOtherUI {
    //开始
    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beginBtn.frame = CGRectMake((Screen_Width-140*Width_Scale)/2, CGRectGetMaxY(_colorView.circleview.frame)+70*Heigt_Scale, 140*Width_Scale, 40*Heigt_Scale);
    beginBtn.backgroundColor = MyColor;
    beginBtn.layer.masksToBounds = YES;
    beginBtn.layer.cornerRadius = 20*Heigt_Scale;
    [beginBtn setTitle:NSLocalizedString(@"begin", nil) forState:UIControlStateNormal];
    beginBtn.tag = 100;
    [beginBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [beginBtn addTarget:self action:@selector(beginPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginBtn];
    
    //今天
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    todayBtn.frame = CGRectMake((Screen_Width-140*Width_Scale)/2,Screen_Height-80*Heigt_Scale, 140*Width_Scale, 30*Heigt_Scale);
    [todayBtn setTitle:NSLocalizedString(@"today", nil) forState:UIControlStateNormal];
    [todayBtn setTitleColor:MyColor forState:UIControlStateNormal];
    [todayBtn addTarget:self action:@selector(showTodayData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:todayBtn];
    
    //提示语
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(todayBtn.frame)-60*Heigt_Scale, Screen_Width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = NSLocalizedString(@"hint", nil);
    label.textColor = FontColor;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    //结束
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.frame = CGRectMake(CGRectGetMaxX(beginBtn.frame)+10*Width_Scale, CGRectGetMinY(beginBtn.frame), 80*Width_Scale, 40*Heigt_Scale);
    [_stopBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [_stopBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _stopBtn.backgroundColor = MyColor;
    _stopBtn.layer.masksToBounds = YES;
    _stopBtn.layer.cornerRadius = 20*Heigt_Scale;
    _stopBtn.hidden = YES;
    _stopBtn.tag = 200;
    [_stopBtn addTarget:self action:@selector(cancelTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopBtn];
    
    _myplayer = [MyPlayer shareInstance];
    
#pragma mark ---
    self.minute = 27;
    self.second = 60;
}

//开始按钮的title
- (void)setBeginBtnTitle:(NSString *)title {
    UIButton *btn = [self.view viewWithTag:100];
    btn.selected = NO;
    [btn setTitle:title forState:UIControlStateNormal];
}

//Pianoboy - The truth that you leave

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
