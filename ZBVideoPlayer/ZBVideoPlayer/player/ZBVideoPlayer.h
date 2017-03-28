//
//  ZBVideoPlayer.h
//  ZBVideoPlayer
//
//  Created by benjamin on 17/3/28.
//  Copyright © 2017年 czb1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZBVideoPlayerDelegate <NSObject>

@optional

- (void)VideoIsReadyToPlay;
- (void)VideoIsLoading;
- (void)VideoIsPlaying;
- (void)playVideoError;

- (void)playerWillChangeSmallScreen;
- (void)playerWillChangeFullScreen;

- (void)playerDidChangeSmallScreen;
- (void)playerDidChangeFullScreen;

@end

@interface ZBVideoPlayer : UIView

@property (weak, nonatomic) id<ZBVideoPlayerDelegate> delegate;

@property (strong, nonatomic) AVPlayer *avPlayer;

@property (assign, nonatomic) BOOL enableLog;

+ (instancetype)playerWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;

- (void)play;
- (void)stop;

- (void)playVideo:(NSURL *)URL;
- (void)changeVideo:(NSURL *)URL;

@end
