//
//  ClockCell.m
//  world_clock
//
//  Created by Alex Hsieh on 11/11/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "ClockCell.h"
#import "ClockView.h"

@interface ClockCell ()
{
    IBOutlet UILabel*       oCityLabel;
    IBOutlet UILabel*       oLocalTimeLabel;
    IBOutlet UIView*        oClockView;
}

@end

@implementation ClockCell

@synthesize oCityLabel      = _oCityLabel;
@synthesize oLocalTimeLabel = _oLocalTimeLabel;
@synthesize oClockView      = _oClockView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
