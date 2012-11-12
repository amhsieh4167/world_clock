//
//  City.h
//  world_clock
//
//  Created by Alex Hsieh on 11/12/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * timeZone;
@property (nonatomic, retain) NSNumber * offset;

@end
