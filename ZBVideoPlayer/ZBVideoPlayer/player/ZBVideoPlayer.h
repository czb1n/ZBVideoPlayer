//
//  ZBVideoPlayer.h
//  ZBVideoPlayer
//
//  Created by benjamin on 17/3/28.
//  Copyright © 2017年 czb1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    PlayerScreenStateSmall,
    PlayerScreenStateFull,
    PlayerScreenStateChanging,
} PlayerScreenState;

@protocol ZBVideoPlayerDelegate <NSObject>

@optional

- (void)VideoIsReadyToPlay;
- (void)VideoIsLoading;
- (void)VideoIsPlaying;
- (void)playVideoError;

- (void)playerWillEnterFullScreen;
- (void)playerWillExitFullScreen;

- (void)playerDidEnterFullScreen;
- (void)playerDidExitFullScreen;

@end

@interface ZBVideoPlayer : UIView

@property (weak, nonatomic) id <ZBVideoPlayerDelegate> delegate;

@property (strong, nonatomic) AVPlayer *avPlayer;

@property (assign, nonatomic) PlayerScreenState screenState;

@property (assign, nonatomic) BOOL enableLog;

+ (instancetype)playerWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;

- (void)play;
- (void)stop;

- (void)playVideo:(NSURL *)URL;
- (void)changeVideo:(NSURL *)URL;

- (void)enterFullScreen;
- (void)exitFullScreen;

@end
