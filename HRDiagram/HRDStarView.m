//
//  HRDStarView.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDStarView.h"

// BAD PROGRAMMING! The star view should not know about the plot size. I don't have time to make this elegant.
#define X_VALUE_MIN 40000
#define X_VALUE_MAX 2500
#define Y_VALUE_MIN 14
#define Y_VALUE_MAX -10

@interface HRDStarView ()

// The color stops.
// Stop point, color value.
@property (strong, nonatomic) NSArray *colorStops;

@end

@implementation HRDStarView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self ) {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self ) {
		[self commonInit];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if ( self ) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit;
{
	self.layer.cornerRadius = self.frame.size.width/2;
	
	// Defaults.
	self.backgroundColor = [UIColor whiteColor];
	
	// Must be increasing (for now).
	self.colorStops = @[
						 @2500, [UIColor colorWithHue:0.09 saturation:0.74 brightness:1 alpha:1],
						 @3750, [UIColor colorWithHue:0.09 saturation:0.40 brightness:1 alpha:1],
						 @5000, [UIColor colorWithHue:0.09 saturation:0.20 brightness:1 alpha:1],
						 @7500, [UIColor colorWithHue:0.65 saturation:0.07 brightness:1 alpha:1],
						@10000, [UIColor colorWithHue:0.63 saturation:0.19 brightness:1 alpha:1],
						@15000, [UIColor colorWithHue:0.63 saturation:0.29 brightness:1 alpha:1],
						@20000, [UIColor colorWithHue:0.63 saturation:0.32 brightness:1 alpha:1],
						@30000, [UIColor colorWithHue:0.63 saturation:0.35 brightness:1 alpha:1],
						@40000, [UIColor colorWithHue:0.63 saturation:0.37 brightness:1 alpha:1],
						];
}


- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	self.layer.cornerRadius = self.frame.size.width/2;
}


#pragma mark - Properties

- (void)setPoint:(CGPoint)point
{
	_colorIndex         = pow(((point.x) * sqrt(2.25 - -0.4)), 2) + -0.4;
	_surfaceTemperature = pow(((1-point.x) * sqrt(X_VALUE_MIN - X_VALUE_MAX)), 2) + X_VALUE_MAX;
	if ( _surfaceTemperature < 4000 ) {
		_spectralClass = @"M";
	} else if ( _surfaceTemperature <  5200 ) {
		_spectralClass = @"K";
	} else if ( _surfaceTemperature <  6000 ) {
		_spectralClass = @"G";
	} else if ( _surfaceTemperature <  7600 ) {
		_spectralClass = @"F";
	} else if ( _surfaceTemperature < 10000 ) {
		_spectralClass = @"A";
	} else if ( _surfaceTemperature < 30000 ) {
		_spectralClass = @"B";
	} else if ( _surfaceTemperature < 52000 ) {
		_spectralClass = @"O";
	} else {
		_spectralClass = @"?";
	}
	
	_absoluteMagnitude  = Y_VALUE_MIN + (point.y * (Y_VALUE_MAX - Y_VALUE_MIN));
	_luminosity = 10 * pow(10, (-10 * point.y) + 6);
	
	// TODO: Recalculate radius.
	
	[self updateDisplay];
}


#pragma mark - Private API

- (UIColor *)color
{
	// Go through all the stops.
	for ( int i=0; i<self.colorStops.count; i+=2 ) {
		NSUInteger index = i;
		if ( self.surfaceTemperature < ((NSNumber *) self.colorStops[index]).doubleValue ) {
			return (UIColor *) self.colorStops[index+1];
		}
	}
	
	// Default color.
	return [UIColor whiteColor];
}


#pragma mark - Appearance

- (void)updateDisplay
{
	self.backgroundColor = [self color];
}

@end
