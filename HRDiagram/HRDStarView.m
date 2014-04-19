//
//  HRDStarView.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDStarView.h"

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
	if ( self.surfaceTemperature < 2500 ) {
		return [UIColor colorWithHue:0.09 saturation:0.74 brightness:1 alpha:1]; //  2,500
	} else if ( self.surfaceTemperature < 3750 ) {
		return [UIColor colorWithHue:0.09 saturation:0.40 brightness:1 alpha:1]; //  3,750
	} else if ( self.surfaceTemperature < 5000 ) {
		return [UIColor colorWithHue:0.09 saturation:0.20 brightness:1 alpha:1]; //  5,000
	} else if ( self.surfaceTemperature < 7500 ) {
		return [UIColor colorWithHue:0.65 saturation:0.07 brightness:1 alpha:1]; //  7,500
	} else if ( self.surfaceTemperature < 10000 ) {
		return [UIColor colorWithHue:0.63 saturation:0.19 brightness:1 alpha:1]; // 10,000
	} else if ( self.surfaceTemperature < 15000 ) {
		return [UIColor colorWithHue:0.63 saturation:0.29 brightness:1 alpha:1]; // 15,000
	} else if ( self.surfaceTemperature < 20000 ) {
		return [UIColor colorWithHue:0.63 saturation:0.32 brightness:1 alpha:1]; // 20,000
	} else if ( self.surfaceTemperature < 30000 ) {
		return [UIColor colorWithHue:0.63 saturation:0.35 brightness:1 alpha:1]; // 30,000
	} else {
		return [UIColor colorWithHue:0.63 saturation:0.37 brightness:1 alpha:1]; // 40,000
	}
	
	// Default.
	return [UIColor whiteColor];
}


#pragma mark - Appearance

- (void)updateDisplay
{
	self.backgroundColor = [self color];
}

@end
