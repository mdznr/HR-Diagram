//
//  HRDStarInfoViewController.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/18/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDStarInfoViewController.h"

@interface HRDStarInfoViewController ()

///	The label for displaying the value of the star's radius.
@property (weak, nonatomic) IBOutlet UILabel *radiusValueLabel;

///	The label for displaying the value of the star's luminosity.
@property (weak, nonatomic) IBOutlet UILabel *luminosityValueLabel;

///	The label for displaying the value of the star's absolute magnitude.
@property (weak, nonatomic) IBOutlet UILabel *absoluteMagnitudeValueLabel;

///	The label for displaying the value of the star's surface temperature.
@property (weak, nonatomic) IBOutlet UILabel *surfaceTemperatureValueLabel;

///	The label for displaying the value of the star's color index.
@property (weak, nonatomic) IBOutlet UILabel *colorIndexValueLabel;

///	The label for displaying the value of the star's spectral class.
@property (weak, nonatomic) IBOutlet UILabel *spectralClassValueLabel;

@end

@implementation HRDStarInfoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self refreshStarInfo];
}

- (void)setStar:(HRDStarView *)star
{
	_star = star;
	
	[self refreshStarInfo];
}

int digits(float f)
{
	f = abs(f);
	
	if ( f < 0.001 ) {
		return 4;
	} else if ( f < 0.01 ) {
		return 3;
	} else if ( f < 0.1 ) {
		return 2;
	} else if ( f < 1.0 ) {
		return 1;
	} else {
		return 0;
	}
}

- (void)refreshStarInfo
{
	self.radiusValueLabel.text = [NSString stringWithFormat:@"%00.*f R⊙", digits(self.star.radius), self.star.radius];
	self.luminosityValueLabel.text = [NSString stringWithFormat:@"%00.*f L⊙", digits(self.star.luminosity), self.star.luminosity];
	self.absoluteMagnitudeValueLabel.text = [NSString stringWithFormat:@"%00.*f M⊙", digits(self.star.absoluteMagnitude), self.star.absoluteMagnitude];
	self.surfaceTemperatureValueLabel.text = [NSString stringWithFormat:@"%00.*f K", digits(self.star.surfaceTemperature), self.star.surfaceTemperature];
	self.colorIndexValueLabel.text = [NSString stringWithFormat:@"%00.*f", digits(self.star.colorIndex), self.star.colorIndex];
	self.spectralClassValueLabel.text = [NSString stringWithFormat:@"%@", self.star.spectralClass];
}

@end
