//
//  SongViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "SongViewController.h"
#import "SongCell.h"
#import "PlayViewController.h"

@interface SongViewController ()


@end

@implementation SongViewController

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
    if([[self.collections objectAtIndex:0] isKindOfClass:[MPMediaItem class]]){
        return 1;
    }
    else {
        return [self.collections count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([[self.collections objectAtIndex:0] isKindOfClass:[MPMediaItem class]]){
        return [self.collections count];
    }
    else {
        return [[[self.collections objectAtIndex:section] items]count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    
    // Configure the cell...
    MPMediaItem* song = nil;
    if([[self.collections objectAtIndex:0] isKindOfClass:[MPMediaItem class]]){
        song = [self.collections objectAtIndex:indexPath.row];
    }
    else {
        song = [[[self.collections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    }
    
    cell.lblSongName.text = [song valueForProperty:MPMediaItemPropertyTitle];
    cell.lblArtistName.text = [song valueForProperty:MPMediaItemPropertyArtist];
    cell.lblAlbumName.text = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    cell.imgArtwork.image = [[song valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(cell.imageView.frame.size.width, cell.imageView.frame.size.height)];
    
    cell.imgArtwork.layer.cornerRadius = 10;
    cell.imgArtwork.clipsToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([[self.collections objectAtIndex:0] isKindOfClass:[MPMediaItem class]]){
        return nil;
    }
    else {
        return [[self.collections objectAtIndex:section] title];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlayViewController sharedMusicPlayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:self.collections]];
    
    if([[self.collections objectAtIndex:0] isKindOfClass:[MPMediaItem class]]){
        [[PlayViewController sharedMusicPlayer] setNowPlayingItem: [self.collections objectAtIndex:indexPath.row]];
    }
    else {
        [PlayViewController sharedMusicPlayer].nowPlayingItem = [[[self.collections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row ];
    }
    
    [[PlayViewController sharedMusicPlayer] play];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
