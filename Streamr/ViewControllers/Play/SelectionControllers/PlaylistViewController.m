//
//  PlaylistViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PlaylistViewController.h"
#import "SongViewController.h"
#import "PlaylistCell.h"
#import "SharedQuery.h"

@interface PlaylistViewController ()

@property (nonatomic, strong) MPMediaQuery* playlistQuery;

@end

@implementation PlaylistViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playlistQuery = [MPMediaQuery playlistsQuery];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray* items = [self.playlistQuery collections];
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaylistCell";
    PlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    MPMediaPlaylist* playlist = [[self.playlistQuery collections] objectAtIndex:indexPath.row];
    cell.lblPlaylistName.text = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    cell.lblSongNumber.text = [[[NSNumber numberWithInteger:[[playlist items] count]] stringValue] stringByAppendingString:@" Songs"];
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:bview];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"PlaylistToSong"]) {
        
        MPMediaPlaylist* playlist = [[self.playlistQuery collections]objectAtIndex:indexPath.row];
        
        // Get destination view
       SongViewController* vc = [segue destinationViewController];
        vc.navigationItem.title = [playlist valueForProperty:MPMediaPlaylistPropertyName];
        // Get button tag number (or do whatever you need to do here, based on your object
        vc.collections = [playlist items];
        
        // Pass the information to your destination view
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end