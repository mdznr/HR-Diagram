//
//  HRDStarView.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDStarView.h"

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

- (void)setAbsoluteMagnitude:(double)absoluteMagnitude
{
	_absoluteMagnitude = absoluteMagnitude;
	
	// Recalculate luminosity.
//	_luminosity = ;
	
	// TODO: Recalculate radius
	
	[self updateDisplay];
}

- (void)setSurfaceTemperature:(double)surfaceTemperature
{
	_surfaceTemperature = surfaceTemperature;
	
	// TODO: Recalculate colorIndex
	// TODO: Recalculate spectralClass
	// TODO: Recalculate radius
	
	[self updateDisplay];
}

// TODO: Setters for other properties


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
