//
//  PlayViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "MainViewController.h"
#import "SharedQuery.h"
#import "PTSessionHandler.h"
#import "CircularProgressView.h"
#import "PTContext.h"
#import "DiscoverViewController.h"
#import "SettingsViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <pop/POP.h>
#import <pop/POPAnimationTracer.h>

@interface MainViewController () <NSStreamDelegate, CircularProgressViewDelegate, ModalControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblSongName;
@property (strong, nonatomic) IBOutlet UILabel *lblArtistName;
@property (strong, nonatomic) IBOutlet UILabel *lblAlbumName;

@property (strong, nonatomic) IBOutlet UIImageView *imgAlbumArt;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayMode;
@property (strong, nonatomic) IBOutlet UIButton *btnListenMode;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPeer;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleAdvertiser;

@property (strong, nonatomic) IBOutlet UIView *controlView;
@property (strong, nonatomic) DiscoverViewController *discoverController;
@property (strong, nonatomic) SettingsViewController *settingsController;

@property (nonatomic) CGRect MainRect;
@property (nonatomic) CGRect OffscreenLeftRect;
@property (nonatomic) CGRect OffscreenRightRect;

@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet CircularProgressView *progressView;

@property (strong, nonatomic) MPMusicPlayerController* music;
@property (strong, nonatomic) AVAssetReader* assetReader;
@property (strong, nonatomic) AVAssetReaderTrackOutput* assetOutput;
@property (strong, nonatomic) NSOutputStream* stream;

@property (nonatomic) BOOL isPlayMode;

@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextItem:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgAlbumArt.layer.cornerRadius = self.imgAlbumArt.frame.size.width / 2.0;
    self.imgAlbumArt.layer.masksToBounds = YES;
    
    self.backgroundView.layer.cornerRadius = self.backgroundView.frame.size.width / 2.0;
    self.backgroundView.layer.masksToBounds = YES;
    
    self.progressView.delegate = self;
    
    self.isPlayMode = [[PTContext context] isPlayMode];
        
    self.music = [MPMusicPlayerController iPodMusicPlayer];
    [self.music beginGeneratingPlaybackNotifications];
    
    if([[PTContext context] isPlayMode]){
        [self loadPlayMode];
        [[PTSessionHandler handler] advertiseSelf:YES];
    }
    else{
        [self loadListenMode];
    }
    
    [self setStreamingIcon];
    
    [self loadSubviews];
}

-(void) loadSubviews
{
    self.discoverController = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscoverViewController"];
    
    self.discoverController.delegate = self;
    [self.view addSubview:self.discoverController.view];
    
    
}

-(void) loadRects
{
    self.MainRect = CGRectMake(0, 0, self.view.frame.size.width, self.controlView.frame.size.height);
    self.OffscreenLeftRect = CGRectMake(0 - self.view.frame.size.width, 0, self.view.frame.size.width, self.controlView.frame.size.height);
    self.OffscreenRightRect = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.controlView.frame.size.height);
    
    self.discoverController.view.frame = self.OffscreenRightRect;

}

- (void) updateLocalNowPlaying
{
    if([self.music playbackState] == MPMusicPlaybackStatePlaying){
        [self startTimer];
    }
        
    MPMediaItem* item = [self.music nowPlayingItem];
    self.lblSongName.text = [item valueForProperty:MPMediaItemPropertyTitle];
    self.lblArtistName.text = [item valueForProperty:MPMediaItemPropertyArtist];
    self.lblAlbumName.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    self.imgAlbumArt.image = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(self.imgAlbumArt.frame.size.width, self.imgAlbumArt.frame.size.height)];
    if(self.imgAlbumArt.image == nil){
        self.imgAlbumArt.image = [UIImage imageNamed:@"default_album_art.png"];
    }
    
    if([self.music playbackState] == MPMusicPlaybackStatePlaying)
    {
        [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
    }
    else if( [self.music playbackState] == MPMusicPlaybackStatePaused)
    {
        [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"StartButton.png"] forState:UIControlStateNormal];
    }
}

-(void) updateRemoteNowPlaying
{
    PTContext* context = [PTContext context];
    self.lblSongName.text = [context remoteSongTitle];
    self.lblArtistName.text = [context remoteArtistTitle];
    self.lblAlbumName.text = [context remoteAlbumTitle];
    
    self.imgAlbumArt.image = [context remoteAlbumArtwork];
    
    if(self.imgAlbumArt.image == nil){
        self.imgAlbumArt.image = [UIImage imageNamed:@"default_album_art.png"];
    }
}

-(void) nextItem: (NSNotification*) notification
{
    [self updateLocalNowPlaying];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.isPlayMode){
        [self updateLocalNowPlaying];
    }
    else
    {
        [self updateRemoteNowPlaying];
    }
    
    [self loadRects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) becomeActive:(NSNotification*) notification
{
    if(self.isPlayMode){
        [self updateLocalNowPlaying];
    }
    else
    {
        [self updateRemoteNowPlaying];
    }
    NSLog(@"Became active");
}

-(void)loadPlayMode
{
    self.btnPlay.hidden = NO;
    self.btnNext.hidden = NO;
    self.btnPrevious.hidden = NO;
    self.btnAddPeer.hidden = YES;
    self.btnToggleAdvertiser.hidden = NO;

    [self.btnPlayMode setEnabled:NO];
    [self.btnListenMode setEnabled:YES];
    self.btnPlayMode.backgroundColor = [PTDefines activeColor];
    self.btnListenMode.backgroundColor = [PTDefines passiveColor];
}

-(void)loadListenMode
{
    self.btnPlay.hidden = YES;
    self.btnNext.hidden = YES;
    self.btnPrevious.hidden = YES;
    self.btnAddPeer.hidden = NO;
    self.btnToggleAdvertiser.hidden = YES;


    [self.btnPlayMode setEnabled:YES];
    [self.btnListenMode setEnabled:NO];
    self.btnPlayMode.backgroundColor = [PTDefines passiveColor];
    self.btnListenMode.backgroundColor = [PTDefines activeColor];
}

-(void)setStreamingIcon
{
    if([[PTContext context] isStreaming])
    {
        [self.btnToggleAdvertiser setBackgroundImage:[UIImage imageNamed:@"wifiIcon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnToggleAdvertiser setBackgroundImage:[UIImage imageNamed:@"disabledWifiIcon.png"] forState:UIControlStateNormal];
    }
}

#pragma mark Circular Progress View

-(float)getCurrentTime
{
    return self.music.currentPlaybackTime;
}

-(float)getTotalTime
{
    MPMediaItem* song = [self.music nowPlayingItem];
    NSNumber* duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    return [duration floatValue];
}

-(CGPoint)getCenterPoint
{
    float x = (self.progressView.frame.size.width / 2.0);
    float y = (self.progressView.frame.size.height / 2.0);
    return CGPointMake(x, y);
}

-(float) getRadius
{
    return self.progressView.frame.size.width / 2.0;
}

-(CGPoint) getStartPoint
{
    float x = self.progressView.frame.origin.x + (self.progressView.frame.size.width / 2.0);
    float y = self.progressView.frame.origin.y + (self.progressView.frame.size.height);
    return CGPointMake(x, y);
}

#pragma mark Animations

-(void)returnToControlView:(UIView *)outgoingView
{
    [self animateViewsRight:outgoingView incomingView:self.controlView];
}

-(void) animateViewsLeft:(UIView*) outgoingView incomingView:(UIView*)incomingView
{
    POPSpringAnimation* outgoingAnm = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    POPSpringAnimation* incomingAnm = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    outgoingAnm.fromValue = [NSValue valueWithCGRect:outgoingView.frame];
    incomingAnm.fromValue = [NSValue valueWithCGRect:incomingView.frame];
    outgoingAnm.toValue = [NSValue valueWithCGRect:self.OffscreenLeftRect];
    incomingAnm.toValue = [NSValue valueWithCGRect:self.MainRect];
    
    [outgoingView.layer pop_addAnimation:outgoingAnm forKey:animKeySlideOutgoing];
    [incomingView.layer pop_addAnimation:incomingAnm forKey:animKeySlideIncoming];
}

-(void) animateViewsRight:(UIView*) outgoingView incomingView:(UIView*) incomingView
{
    POPSpringAnimation* outgoingAnm = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    POPSpringAnimation* incomingAnm = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    outgoingAnm.toValue = [NSValue valueWithCGRect:self.OffscreenRightRect];
    incomingAnm.toValue = [NSValue valueWithCGRect:self.MainRect];
    
    [outgoingView.layer pop_addAnimation:outgoingAnm forKey:animKeySlideOutgoing];
    [incomingView.layer pop_addAnimation:incomingAnm forKey:animKeySlideIncoming];
}

#pragma mark Timer

-(void)startTimer
{
    if(self.timer == nil)
    {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopTimer
{
    if(self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

-(void)fireTimer:(NSTimer*) timer
{
    [self.progressView setNeedsDisplay];
}

#pragma mark Streaming

-(IBAction)onSwitchStreaming:(id)sender
{
    
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            CMSampleBufferRef sampleBuffer = [self.assetOutput copyNextSampleBuffer];
            CMBlockBufferRef blockBuffer;
            AudioBufferList audioBufferList;
            
            CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &audioBufferList, sizeof(AudioBufferList), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
            
            for (NSUInteger i = 0; i < audioBufferList.mNumberBuffers; i++) {
                AudioBuffer audioBuffer = audioBufferList.mBuffers[i];
                self.stream = [NSOutputStream outputStreamToBuffer:audioBuffer.mData capacity:audioBuffer.mDataByteSize];
                [self.stream write:audioBuffer.mData maxLength:audioBuffer.mDataByteSize];
            }
            
            CFRelease(blockBuffer);
            CFRelease(sampleBuffer);
        }
    }
}

#pragma mark Actions

-(IBAction)onBtnPlayMode:(id)sender
{
    [self loadPlayMode];
}

-(IBAction)onBtnListenMode:(id)sender
{
    [self loadListenMode];
}

- (IBAction )onBtnDiscoverPeer:(id)sender
{
    [self animateViewsLeft:self.controlView incomingView:self.discoverController.view];
}

- (IBAction)onBtnToggleAdvertiser:(id)sender {
    if([[PTContext context] isStreaming]){
        [[PTContext context] setIsStreaming:NO];
    }
    else
    {
        [[PTContext context] setIsStreaming:YES];
    }
    
    [self setStreamingIcon];
    [[PTSessionHandler handler] advertiseSelf:[[PTContext context] isStreaming]];
}

-(IBAction)onBtnPlay:(id) sender
{
    NSString* image;
    if([self.music playbackState] == MPMusicPlaybackStatePaused){
        [self.music play];
        [self startTimer];
        image = @"Pause.png";
    }
    else
    {
        [self.music pause];
        [self stopTimer];
        image = @"StartButton.png";
    }
    
    [self.btnPlay setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
}

- (IBAction)onBtnPrevious:(id)sender {
    [self.music skipToPreviousItem];
}
- (IBAction)btnOnNext:(id)sender {
    [self.music skipToNextItem];
}

@end

