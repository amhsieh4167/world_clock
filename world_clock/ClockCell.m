//
//  ClockCell.m
//  world_clock
//
//  Created by Alex Hsieh on 11/11/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "ClockCell.h"

@implementation ClockCell

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
