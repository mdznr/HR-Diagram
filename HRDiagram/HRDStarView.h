//
//  HRDStarView.h
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRDStarView : UIView

///	The Radius (R☉) of the star.
/// @discussion The value of this is a function of luminosity/absoluteMagnitude and temperature/color.
@property (nonatomic) double radius;

///	The Luminosity (L☉) of the star.
/// @discussion This property directly relates to @c absoluteMagnitude.
@property (nonatomic) double luminosity;

///	The Absolute Magnitude (M) of the star.
/// @discussion This property directly relates to @c luminosity.
@property (nonatomic) double absoluteMagnitude;

///	The Surface Temperature (K) of the star.
@property (nonatomic) double surfaceTemperature;

///	The B-V Color Index of the star.
@property (nonatomic) double colorIndex;

///	The Spectral Class of the star.
@property (nonatomic) NSString *spectralClass;

@end
