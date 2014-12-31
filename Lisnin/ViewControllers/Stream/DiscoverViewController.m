//
//  DiscoverViewController.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PTSessionHandler.h"
#import "DiscoverCell.h"
#import "MusicService.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface DiscoverViewController () <MCNearbyServiceBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* availablePeers;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DiscoverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PTSessionHandler handler] setBrowserDelegate:self];
    self.availablePeers = [[NSMutableArray alloc] initWithCapacity:10];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [[PTSessionHandler handler] startBrowsing];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[PTSessionHandler handler] stopBrowsing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)onBtnDone:(id)sender {
    [self.delegate returnToControlView:self.view];
}

#pragma mark peer browsing

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [self.availablePeers addObject:peerID];
    [self.tableView reloadData];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    MCPeerID* peerToRemove = nil;
    for(MCPeerID* peer in self.availablePeers)
    {
        if([peer.displayName isEqualToString:peerID.displayName]){
            peerToRemove = peer;
            break;
        }
    }
    [self.availablePeers removeObject:peerToRemove];
    [self.tableView reloadData];
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
    return [self.availablePeers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiscoverCell";
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.lblDeviceName.text = [[self.availablePeers objectAtIndex:indexPath.row] displayName];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    MCPeerID* peer = [self.availablePeers objectAtIndex:indexPath.row];
    [[PTSessionHandler handler] connectToPeer:peer.displayName];
    
    [self.delegate returnToControlView:self.view];
}

@end
