//
//  MyPlayer.m
//  MyConcentration
//
//  Created by ljie on 2017/8/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MyPlayer.h"

@implementation MyPlayer

+ (instancetype)shareInstance {
    static MyPlayer *myPlayer = nil; static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myPlayer = [[MyPlayer alloc] init];
    });
    return myPlayer;
}

//根据音乐名字播放音乐🎵
- (void)playMusicWithName:(NSString *)name {
    //获取对应音乐资源
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
    if (url == nil) return;
    //创建对应的播放器
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //准备播放
    [_player prepareToPlay];
    //播放音乐
    [_player play];
    [_player setNumberOfLoops:100000];
    NSLog(@"播放了");
}

//暂停或播放
- (void)playOrStopMusic {
    if ([_player isPlaying]) {
        [_player pause];
        NSLog(@"暂停");
        return;
    }
    [_player play];
    NSLog(@"播放");
}

@end
