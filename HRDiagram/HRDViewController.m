//
//  HRDViewController.m
//  HRDiagram
//
//  Created by Matt Zanchelli on 4/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "HRDViewController.h"

#import "HRDPlotView.h"

#define LEFT_EDGE 64
#define RIGHT_EDGE 960
#define TOP_EDGE 67
#define BOTTOM_EDGE 700

#define WIDTH (RIGHT_EDGE - LEFT_EDGE)
#define HEIGHT (BOTTOM_EDGE - TOP_EDGE)

@interface HRDViewController ()

// The view representing the plot. Manages the stars.
@property (weak, nonatomic) IBOutlet HRDPlotView *plotView;

@end

@implementation HRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventTypeMotion ){
		[_plotView removeAllStarsAnimated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

@end
