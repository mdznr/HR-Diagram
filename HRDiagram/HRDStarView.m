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

- (void)setAbsoluteMagnitude:(CGFloat)absoluteMagnitude
{
	_absoluteMagnitude = absoluteMagnitude;
	
	// TODO: Recalculate luminosity
	// TODO: Recalculate radius
	
	[self updateDisplay];
}

- (void)setSurfaceTemperature:(CGFloat)surfaceTemperature
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
	// Red, green, and blue components.
	CGFloat r, g, b = 1.0f;
	
	if ( self.surfaceTemperature < 0.25 ) {
		CGFloat p = ((0.25f - self.surfaceTemperature) / 25.0f);
		r = 0.63 + (p * 0.05);
		g = 0.71 + (p * 0.04);
		b = 1.0;
	} else if ( self.surfaceTemperature < 0.5 ) {
		CGFloat p = ((0.5f - self.surfaceTemperature) / 25.0f);
		r = 0.68 + (p * 0.13);
		g = 0.75 + (p * 0.10);
		b = 1.0;
	} else if ( self.surfaceTemperature < 0.75) {
		CGFloat p = ((0.75f - self.surfaceTemperature) / 25.0f);
		r = 0.81 + (p * 0.19);
		g = 0.85 + (p * 0.05);
		b = 1.00 - (p * 0.20);
	} else {
		CGFloat p = ((1.00f - self.surfaceTemperature) / 25.0f);
		r = 1.0;
		g = 0.9 - (p * 0.25);
		b = 0.8 - (p * 0.54);
	}
	
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
	
	// 0.00: [UIColor colorWithRed:0.63 green:0.71 blue:1.00 alpha:1]
	// 0.25: [UIColor colorWithRed:0.68 green:0.75 blue:1.00 alpha:1]
	// 0.50: [UIColor colorWithRed:0.81 green:0.85 blue:1.00 alpha:1]
	// 0.75: [UIColor colorWithRed:1.00 green:0.90 blue:0.80 alpha:1]
	// 1.00: [UIColor colorWithRed:1.00 green:0.65 blue:0.26 alpha:1]
}


#pragma mark - Drawing

- (void)updateDisplay
{
	self.backgroundColor = [self color];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, rect);
//    CGContextSetFillColor(ctx, CGColorGetComponents([[self color] CGColor]));
//    CGContextFillPath(ctx);
//}

@end
