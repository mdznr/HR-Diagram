//
//  HRDPlotView.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/17/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDPlotView.h"

#import "HRDStarView.h"

#define SUN_FRAME CGRectMake(566, 360, 44, 44)
#define SUN_CENTER CGPointMake(588, 382)

#define PLOT_WIDTH 892
#define PLOT_HEIGHT 636

@interface HRDPlotView ()

///	A newly created star.
@property (strong, nonatomic) HRDStarView *youngStar;

@end

@implementation HRDPlotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
	[self addGestureRecognizer:longPress];
	
	// Create the first star at a particular point.
	[self createStarAtPoint:SUN_CENTER];
}

///	Create a new star at a point.
///	@param point The point at which to center the star.
/// @return A reference to the star that was created.
- (HRDStarView *)createStarAtPoint:(CGPoint)point
{
	// Crete the star at the point.
#warning how to handle frame size?
	HRDStarView *star = [[HRDStarView alloc] initWithFrame:CGRectMake(point.x-1, point.y+1, 2, 2)];
	
	// Add gesture recognizers.
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnStar:)];
	[star addGestureRecognizer:pan];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnStar:)];
	[star addGestureRecognizer:tap];
	
	// Add the star.
	[self addStar:star];
	
	// Animate to expanding star.
	[UIView animateWithDuration:0.4f
						  delay:0.0f
		 usingSpringWithDamping:0.6f
		  initialSpringVelocity:0.5f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 star.frame = CGRectMake(point.x-22, point.y-22, 44, 44);
					 } completion:nil];
	
	return star;
}

///	Add a star to the plot.
///	@param star The star to add to the plot.
- (void)addStar:(HRDStarView *)star
{
	[self addSubview:star];
}


#pragma mark - Gesture Recognizers

///	Did pan on a star.
///	@param sender The pan gesture recognizer sending the event.
- (void)didPanOnStar:(UIPanGestureRecognizer *)sender
{
	HRDStarView *star = (HRDStarView *) sender.view;
	
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStateChanged: {
			// Get the translation.
			CGPoint translation = [sender translationInView:self];
			// Reset the translation.
			[sender setTranslation:CGPointZero inView:self];
			
			// Update the location of the star on the diagram.
			sender.view.center = CGPointMake((star.center.x + translation.x), (star.center.y + translation.y));
			
			// The percentage of the x and y values on the graph.
			CGFloat x = star.center.x / PLOT_WIDTH;
			CGFloat y = star.center.y / PLOT_HEIGHT;
			
			star.surfaceTemperature = x;
			star.absoluteMagnitude = y;
			
			// Make transparent if it will be removed.
			if ( !CGRectContainsPoint(self.bounds, sender.view.center) ) {
				star.alpha = 0.5f;
			} else {
				star.alpha = 1.0f;
			}
			
		} break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded: {
			if ( !CGRectContainsPoint(self.bounds, sender.view.center) ) {
				// TODO: Poof?
				[sender.view removeFromSuperview];
			}
		} break;
		default:
			break;
	}
}

- (void)didTapOnStar:(UITapGestureRecognizer *)sender
{
	HRDStarView *star = (HRDStarView *) sender.view;
	// TODO: Bring up popover menu with stats.
}

- (void)didLongPress:(UILongPressGestureRecognizer *)sender
{
	// Find where the long press was.
	CGPoint point = [sender locationInView:sender.view];
	
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
			// Create a star at that point.
			self.youngStar = [self createStarAtPoint:point];
			break;
		case UIGestureRecognizerStateChanged:
			// Move star to stay centered with touch.
			self.youngStar.center = [sender locationInView:self];
			// TODO:
			break;
		case UIGestureRecognizerStateEnded:
			self.youngStar = nil;
			break;
		case UIGestureRecognizerStateCancelled:
			break;
		default:
			break;
	}
}

- (void)removeAllStars
{
	for ( UIView *subview in self.subviews ) {
		[subview removeFromSuperview];
	}
}

- (void)removeAllStarsWithAnimation
{
	for ( UIView *subview in self.subviews ) {
		[UIView animateWithDuration:0.4f
							  delay:0.0f
							options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 subview.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 [subview removeFromSuperview];
						 }];
	}
}

- (void)removeAllStarsAnimated:(BOOL)animated
{
	if ( animated ) {
		[self removeAllStarsWithAnimation];
	} else {
		[self removeAllStars];
	}
}

@end
