//
//  ViewController.m
//  ZBVideoPlayer
//
//  Created by benjamin on 17/3/28.
//  Copyright © 2017年 czb1n. All rights reserved.
//

#import "ViewController.h"
#import "ZBVideoPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZBVideoPlayer *player = [ZBVideoPlayer playerWithURL:[NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"]];
    [player setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
    player.enableLog = YES;
    [self.view addSubview:player];
    
    [player play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
