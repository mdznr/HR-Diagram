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

@property (strong, nonatomic) NSMutableArray *stars;

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
	_stars = [[NSMutableArray alloc] initWithCapacity:1];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
	[self addGestureRecognizer:longPress];
	
	// Create the first star at a particular point.
	[self createStarAtPoint:SUN_CENTER];
}

///	Create a new star at a point.
///	@param point The point at which to center the star.
- (void)createStarAtPoint:(CGPoint)point
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
}

///	Add a star to the plot.
///	@param star The star to add to the plot.
- (void)addStar:(HRDStarView *)star
{
	[_stars addObject:star];
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
			// The coordinates of the starView relative to the entire view.
			CGFloat xPos = MIN(MAX(0, (star.center.x + translation.x)), PLOT_WIDTH);
			CGFloat yPos = MIN(MAX(0, (star.center.y + translation.y)), PLOT_HEIGHT);
			sender.view.center = CGPointMake(xPos, yPos);
			
			// The percentage of the x and y values on the graph.
			CGFloat x = (xPos - 0) / PLOT_WIDTH;
			CGFloat y = (yPos - 0) / PLOT_HEIGHT;
			
			star.surfaceTemperature = x;
			star.absoluteMagnitude = y;
		} break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded:
			break;
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
			[self createStarAtPoint:point];
			break;
		case UIGestureRecognizerStateChanged:
			// TODO: Move star.
			break;
		case UIGestureRecognizerStateEnded:
			break;
		case UIGestureRecognizerStateCancelled:
			break;
		default:
			break;
	}
}

@end
