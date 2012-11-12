//
//  ClockView.m
//  clock
//
//  Created by Ignacio Enriquez Gutierrez on 1/31/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file License.txt for copying permission.
//

#import "ClockView.h"

@implementation ClockView

#pragma mark - Public Methods

- (void)start
{
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
}

- (void)stop
{
	[_timer invalidate];
	_timer = nil;
}

//customize appearence
- (void)setHourHandImage:(CGImageRef)image
{
	if (image == NULL) {
		hourHand.backgroundColor = [UIColor blackColor].CGColor;
		hourHand.cornerRadius = 3;
	}else{
		hourHand.backgroundColor = [UIColor clearColor].CGColor;
		hourHand.cornerRadius = 0.0;
		
	}
	hourHand.contents = (id)image;
}

- (void)setMinHandImage:(CGImageRef)image
{
	if (image == NULL) {
		minHand.backgroundColor = [UIColor grayColor].CGColor;
	}else{
		minHand.backgroundColor = [UIColor clearColor].CGColor;
	}
	minHand.contents = (id)image;
}

- (void)setSecHandImage:(CGImageRef)image
{
	if (image == NULL) {
		secHand.backgroundColor = [UIColor whiteColor].CGColor;
		secHand.borderWidth = 1.0;
		secHand.borderColor = [UIColor grayColor].CGColor;
	}else{
		secHand.backgroundColor = [UIColor clearColor].CGColor;
		secHand.borderWidth = 0.0;
		secHand.borderColor = [UIColor clearColor].CGColor;
	}
	secHand.contents = (id)image;
}

- (void)setClockBackgroundImage:(CGImageRef)image
{
	if (image == NULL) {
		containerLayer.borderColor = [UIColor blackColor].CGColor;
		containerLayer.borderWidth = 1.0;
		containerLayer.cornerRadius = 5.0;
	}else{
		containerLayer.borderColor = [UIColor clearColor].CGColor;
		containerLayer.borderWidth = 0.0;
		containerLayer.cornerRadius = 0.0;
	}
	containerLayer.contents = (id)image;
}

#pragma mark - Private Methods

//Default sizes of hands:
//in percentage (0.0 - 1.0)
#define HOURS_HAND_LENGTH 0.65
#define MIN_HAND_LENGTH 0.75
#define SEC_HAND_LENGTH 0.8
//in pixels
#define HOURS_HAND_WIDTH 10
#define MIN_HAND_WIDTH 8
#define SEC_HAND_WIDTH 4

float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

//timer callback
- (void) updateClock:(NSTimer *)theTimer{
	
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_clockTime];
	NSInteger seconds = [dateComponents second];
	NSInteger minutes = [dateComponents minute];
	NSInteger hours = [dateComponents hour];
    NSLog(@"_clockTime is %@",_clockTime);
	NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);
	if (hours > 12) hours -=12; //PM
    
	//set angles for each of the hands
	CGFloat secAngle = Degrees2Radians(seconds/60.0*360);
	CGFloat minAngle = Degrees2Radians(minutes/60.0*360);
	CGFloat hourAngle = Degrees2Radians(hours/12.0*360) + minAngle/12.0;
	
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
//	secHand.transform = CATransform3DMakeRotation (secAngle+M_PI, 0, 0, 1);
    secHand.transform = CATransform3DMakeRotation (secAngle, 0, 0, 1);
	minHand.transform = CATransform3DMakeRotation (minAngle, 0, 0, 1);
	hourHand.transform = CATransform3DMakeRotation (hourAngle+M_PI, 0, 0, 1);
}
#pragma mark - Overrides

- (void) layoutSubviews
{
	[super layoutSubviews];
    
	containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
	float length = MIN(self.frame.size.width, self.frame.size.height)/2;
	CGPoint c = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	hourHand.position = minHand.position = secHand.position = c;
    
	CGFloat w, h;
	CGFloat scale = 1;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		scale = [UIScreen mainScreen].scale;
	}
	
	if (hourHand.contents == NULL){
		w = HOURS_HAND_WIDTH;
		h = length*HOURS_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)hourHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)hourHand.contents)/scale;
	}
	hourHand.bounds = CGRectMake(0,0,w,h);
	
	if (minHand.contents == NULL){
		w = MIN_HAND_WIDTH;
		h = length*MIN_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)minHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)minHand.contents)/scale;
	}
	minHand.bounds = CGRectMake(0,0,w,h);
	
	if (secHand.contents == NULL){
		w = SEC_HAND_WIDTH;
		h = length*SEC_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)secHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)secHand.contents)/scale;
	}
	secHand.bounds = CGRectMake(0,0,w,h);
    
	hourHand.anchorPoint = CGPointMake(0.5,0.5);
	minHand.anchorPoint = CGPointMake(0.5, 0.5);
	secHand.anchorPoint = CGPointMake(0.5,0.5);
	containerLayer.anchorPoint = CGPointMake(0.5,0.5);
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		containerLayer = [CALayer layer];
		hourHand = [CALayer layer];
		minHand = [CALayer layer];
		secHand = [CALayer layer];
        
		//default appearance
		[self setClockBackgroundImage:NULL];
		[self setHourHandImage:NULL];
		[self setMinHandImage:NULL];
		[self setSecHandImage:NULL];
		
		//add all created sublayers
		[containerLayer addSublayer:hourHand];
		[containerLayer addSublayer:minHand];
		[containerLayer addSublayer:secHand];
		[self.layer addSublayer:containerLayer];
	}
	return self;
}

- (void)removeFromSuperview
{
	[self stop];
	[super removeFromSuperview];
}

- (void)dealloc
{
	[self stop];
}


@end