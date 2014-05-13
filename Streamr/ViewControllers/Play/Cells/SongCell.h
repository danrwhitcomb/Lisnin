//
//  SongCell.h
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgArtwork;
@property (strong, nonatomic) IBOutlet UILabel *lblSongName;
@property (strong, nonatomic) IBOutlet UILabel *lblArtistName;
@property (strong, nonatomic) IBOutlet UILabel *lblAlbumName;

@end
