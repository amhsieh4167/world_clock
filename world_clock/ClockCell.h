//
//  ClockCell.h
//  world_clock
//
//  Created by Alex Hsieh on 11/11/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockCell : UITableViewCell

@property(strong, nonatomic) UILabel* oCityLabel;
@property(strong, nonatomic) UILabel* oLocalTimeLabel;
@property(strong, nonatomic) UIView* oClockView;

@end
