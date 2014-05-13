//
//  PlaylistCell.h
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPlaylistName;
@property (strong, nonatomic) IBOutlet UILabel *lblSongNumber;

@end
