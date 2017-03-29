//
//  ViewController.m
//  ZBVideoPlayer
//
//  Created by benjamin on 17/3/28.
//  Copyright © 2017年 czb1n. All rights reserved.
//

#import "ViewController.h"
#import "ZBVideoPlayer.h"

@interface ViewController () <ZBVideoPlayerDelegate>

@property (strong, nonatomic) ZBVideoPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.player = [ZBVideoPlayer playerWithURL:[NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"]];
    [self.player setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
    self.player.enableLog = YES;
    self.player.delegate = self;
    [self.view addSubview:self.player];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePlayerScreenState)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.player addGestureRecognizer:doubleTap];
    
    [self.player play];
}

- (void)changePlayerScreenState
{
    if (self.player.screenState == PlayerScreenStateSmall) {
        [self.player enterFullScreen];
    }
    else if (self.player.screenState == PlayerScreenStateFull) {
        [self.player exitFullScreen];
    }
}

- (void)playerWillEnterFullScreen
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)playerWillExitFullScreen
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)playerDidEnterFullScreen
{
    
}

- (void)playerDidExitFullScreen
{
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
