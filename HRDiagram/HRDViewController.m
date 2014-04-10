//
//  HRDViewController.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDViewController.h"

#import "HRDStarView.h"

#define LEFT_EDGE 64
#define RIGHT_EDGE 960
#define TOP_EDGE 67
#define BOTTOM_EDGE 700

#define WIDTH (RIGHT_EDGE - LEFT_EDGE)
#define HEIGHT (BOTTOM_EDGE - TOP_EDGE)

@interface HRDViewController ()

///	The view representing the star.
@property (weak, nonatomic) IBOutlet HRDStarView *starView;

@end

@implementation HRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnStar:)];
	[self.starView addGestureRecognizer:pan];
	
	// TODO: Set default values for star.
}

- (void)didPanOnStar:(UIPanGestureRecognizer *)sender
{
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStateChanged: {
			// Get the translation.
			CGPoint translation = [sender translationInView:self.view];
			// Reset the translation.
			[sender setTranslation:CGPointMake(0, 0) inView:self.view];
			
			// Update the location of the star on the diagram.
			// The coordinates of the starView relative to the entire view.
			CGFloat xPos = MIN(MAX(LEFT_EDGE, (self.starView.center.x + translation.x)), RIGHT_EDGE);
			CGFloat yPos = MIN(MAX(TOP_EDGE, (self.starView.center.y + translation.y)), BOTTOM_EDGE);
			self.starView.center = CGPointMake(xPos, yPos);
			
			// The percentage of the x and y values on the graph.
			CGFloat x, y;
			x = (xPos - LEFT_EDGE) / WIDTH;
			y = (yPos - TOP_EDGE) / HEIGHT;
			
			self.starView.surfaceTemperature = x;
			self.starView.absoluteMagnitude = y;
		} break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded:
			break;
		default:
			break;
	}
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

@end
