//
//  MusicSectionsViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/11/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "MusicSectionsViewController.h"
#import "SongViewController.h"

@interface MusicSectionsViewController ()
#import <MediaPlayer/MediaPlayer.h>


@end

@implementation MusicSectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ToSong"]) {
        
        // Get destination view
        SongViewController *vc = [segue destinationViewController];
        vc.collections = [[MPMediaQuery songsQuery] collections];
        vc.navigationItem.title = @"Songs";
    }
}



@end
