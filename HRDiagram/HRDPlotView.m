//
//  HRDPlotView.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/17/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDPlotView.h"

#import "HRDStarView.h"
#import "HRDStarInfoViewController.h"

#define SUN_FRAME CGRectMake(566, 360, 44, 44)
#define SUN_CENTER CGPointMake(588, 382)

#define PLOT_WIDTH 892
#define PLOT_HEIGHT 636

@interface HRDPlotView ()

///	A newly created star.
@property (strong, nonatomic) HRDStarView *youngStar;

///	A popover to show stats about stars.
@property (strong, nonatomic) UIPopoverController *popover;

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
	// Create long press gesture recognizer.
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
	longPress.minimumPressDuration = 0.2f;
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
		 usingSpringWithDamping:0.5f
		  initialSpringVelocity:2.0f
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
			CGFloat y = 1 - (star.center.y / PLOT_HEIGHT);
			
			star.point = CGPointMake(x, y);
			
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
	
	// Create the content view controller.
	HRDStarInfoViewController *vc = [[HRDStarInfoViewController alloc] initWithNibName:@"HRDStarInfoViewController" bundle:nil];
	[vc setStar:star];
	
	// Create and display the popover.
	self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
	self.popover.popoverContentSize = CGSizeMake(264, 205);
	[self.popover presentPopoverFromRect:star.frame
								  inView:self
				permittedArrowDirections:UIPopoverArrowDirectionAny
								animated:YES];
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
			
			// Make transparent if it will be removed.
			if ( !CGRectContainsPoint(self.bounds, self.youngStar.center) ) {
				self.youngStar.alpha = 0.5f;
			} else {
				self.youngStar.alpha = 1.0f;
			}
			break;
		case UIGestureRecognizerStateEnded:
			if ( !CGRectContainsPoint(self.bounds, self.youngStar.center) ) {
				// TODO: Poof?
				[self.youngStar removeFromSuperview];
			}
			self.youngStar = nil;
			break;
		case UIGestureRecognizerStateCancelled:
			break;
		default:
			break;
	}
}

// TODO: Fix an issue where accidentally long pressing while trying to drag a star creates a new star.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	for ( UIView *view in self.subviews ) {
		if ( view == [view hitTest:point withEvent:event] ) {
			return view;
		}
	}
	
	return [super hitTest:point withEvent:event];
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
