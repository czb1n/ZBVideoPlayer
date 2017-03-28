//
//  ZBVideoPlayer.m
//  ZBVideoPlayer
//
//  Created by benjamin on 17/3/28.
//  Copyright © 2017年 czb1n. All rights reserved.
//

#import "ZBVideoPlayer.h"

#define DEBUGLOG(format, ...)                               ([self debugLog:(format), ## __VA_ARGS__])

#define PLAYER_ITEM_STATUS                                  @"status"
#define PLAYER_ITEM_LOADED_TIME_RANGES                      @"loadedTimeRanges"

@interface ZBVideoPlayer ()

@property (strong, nonatomic) NSTimer *loadTimer;
@property (assign, nonatomic) CGFloat keepRate;
@property (assign, nonatomic) CGFloat currentRate;

@end

@implementation ZBVideoPlayer

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self setupPlayer:URL];
    }
    return self;
}

+ (instancetype)playerWithURL:(NSURL *)URL
{
    ZBVideoPlayer *player = [[ZBVideoPlayer alloc] initWithURL:URL];
    
    return player;
}

- (void)dealloc
{
    [self stop];
    [self removeCurrentItemObserver];
    [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    [(AVPlayerLayer *)self.layer setPlayer:nil];
    self.avPlayer = nil;
}

#pragma mark - set up

- (void)setupPlayer:(NSURL *)URL
{
    self.avPlayer = [[AVPlayer alloc] initWithURL:URL];
    
    [(AVPlayerLayer *)self.layer setPlayer:self.avPlayer];
    [(AVPlayerLayer *)self.layer setVideoGravity:AVLayerVideoGravityResize];
    
    self.avPlayer.volume = 0.5;
    
    self.keepRate = 0.0;
    self.currentRate = 0.0;
    
    [self setupCurrentItemObserver];
}

- (void)setupCurrentItemObserver
{
    [self.avPlayer.currentItem addObserver:self
                                forKeyPath:PLAYER_ITEM_STATUS
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
    
    [self.avPlayer.currentItem addObserver:self
                                forKeyPath:PLAYER_ITEM_LOADED_TIME_RANGES
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
}

- (void)removeCurrentItemObserver
{
    if (self.avPlayer.currentItem) {
        @try {
            [self.avPlayer.currentItem removeObserver:self forKeyPath:PLAYER_ITEM_STATUS];
            [self.avPlayer.currentItem removeObserver:self forKeyPath:PLAYER_ITEM_LOADED_TIME_RANGES];
        }
        @catch (NSException *exception) {
            DEBUGLOG(@"remove player item observer excetion = %@", exception);
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        if ([keyPath isEqualToString:PLAYER_ITEM_STATUS]) {
            if ([playerItem status] == AVPlayerStatusReadyToPlay) {
                DEBUGLOG(@"player is ready to play");
                [self.delegate VideoIsReadyToPlay];
            }
            else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
                DEBUGLOG(@"play video error");
                [self.delegate playVideoError];
            }
        }
        else if ([keyPath isEqualToString:PLAYER_ITEM_LOADED_TIME_RANGES]) {
            NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
            
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval result = startSeconds + durationSeconds;
            
            self.currentRate = result;
            
            DEBUGLOG(@"current player item loaded time %f, %f, %f", startSeconds, durationSeconds, result);
        }
    }
}

#pragma mark - player control
- (void)play
{
    [self.avPlayer play];
    [self startTimer];
}

- (void)stop
{
    [self.avPlayer pause];
    [self stopTimer];
}

- (void)playVideo:(NSURL *)URL
{
    [self stop];
    
    [self changeVideo:URL];
    
    [self play];
}

- (void)changeVideo:(NSURL *)URL
{
    [self removeCurrentItemObserver];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:URL];
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    
    [self setupCurrentItemObserver];
}

#pragma mark - timer
- (void)startTimer
{
    if (self.loadTimer) {
        [self stopTimer];
    }
    
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                      target:self
                                                    selector:@selector(checkVideoLoadStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    
    DEBUGLOG(@"start timer");
}

- (void)stopTimer
{
    [self.loadTimer invalidate];
    self.loadTimer = nil;
    
    DEBUGLOG(@"stop timer");
}

- (void)checkVideoLoadStatus
{
    if (self.keepRate == self.currentRate) {
        [self.delegate VideoIsLoading];
        DEBUGLOG(@"video is loading");
    }
    else {
        [self.delegate VideoIsPlaying];
    }
    
    self.keepRate = self.currentRate;
}

#pragma mark - log
- (void)debugLog:(NSString *)format, ...;
{
    if (self.enableLog) {
        va_list args;
        
        va_start(args, format);
        NSString *log = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSLog(@"ZBVideoPlayer : %@", log);
    }
}

@end
