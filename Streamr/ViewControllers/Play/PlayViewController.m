//
//  PlayViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PlayViewController.h"
#import "SharedQuery.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblSongName;
@property (strong, nonatomic) IBOutlet UILabel *lblArtistName;
@property (strong, nonatomic) IBOutlet UILabel *lblAlbumName;
@property (strong, nonatomic) IBOutlet UIImageView *imgAlbumArt;
@property (strong, nonatomic) IBOutlet UISlider *sliderTime;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) MPMusicPlayerController* music;

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.music = [MPMusicPlayerController applicationMusicPlayer];
        
        [self.music setQueueWithQuery:[[SharedQuery sharedQuery] query]];
        MPMediaItem* item = [self.music nowPlayingItem];
        self.lblSongName.text = [item valueForProperty:MPMediaItemPropertyTitle];
        self.lblArtistName = [item valueForProperty:MPMediaItemPropertyArtist];
        self.lblAlbumName = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
  
    MPMediaItem* item = [self.music nowPlayingItem];
    
    self.imgAlbumArt.image = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(self.imgAlbumArt.frame.size.width, self.imgAlbumArt.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(MPMusicPlayerController*)musicPlayer
{
    return self.music;
}


-(IBAction)onBtnPlay:(id) sender
{
    [self.music play];
}

- (IBAction)onBtnPrevious:(id)sender {
    [self.music skipToPreviousItem];
}
- (IBAction)btnOnNext:(id)sender {
    [self.music skipToNextItem];
}

@end
