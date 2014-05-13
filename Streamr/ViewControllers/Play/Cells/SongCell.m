//
//  SongCell.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/12/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void) viewWillAppear
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
