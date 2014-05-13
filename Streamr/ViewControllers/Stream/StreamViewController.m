//
//  StreamViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "StreamViewController.h"

@interface StreamViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblSongName;
@property (strong, nonatomic) IBOutlet UILabel *lblArtistName;
@property (strong, nonatomic) IBOutlet UILabel *lblAlbumName;
@property (strong, nonatomic) IBOutlet UIImageView *imageAlbumArt;
@property (strong, nonatomic) IBOutlet UIProgressView *progressSongTime;

@end

@implementation StreamViewController

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

#pragma mark Actions

-(IBAction)onBtnDiscover:(id) sender
{
    UITableViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscoverViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
