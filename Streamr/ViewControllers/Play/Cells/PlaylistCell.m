//
//  PlaylistCell.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PlaylistCell.h"

@implementation PlaylistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
