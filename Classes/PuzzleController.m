//
//  PuzzelViewController.m
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "PuzzleController.h"
#import "PuzzleView.h"
#import <QuartzCore/QuartzCore.h>

@interface PuzzleController ()
- (void)loadTiles;
- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer;
- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer;
@end


@implementation PuzzleController

- (void)loadView;
{
	self.view = [[[PuzzleView alloc] init] autorelease];
}

- (void)viewDidLoad;
{
	self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidAppear:(BOOL)animated;
{
	[super viewDidAppear:animated];
		[self loadTiles];
}

- (void)loadTiles;
{
	for (int row = 0; row < 3; row++) {
		for (int col = 0; col < 3; col++) {
			
			if (row == 2 && col == 2) {
				continue; //hole in tile
			}
			
			UIView *tileView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
			tileView.backgroundColor = [UIColor greenColor];
			tileView.layer.borderColor = [[UIColor blueColor] CGColor];
			tileView.layer.borderWidth = 1.0;
			
			CGRect tileFrame = CGRectMake(0, 0, 100, 100);

			tileFrame.origin.x = (col * 100) + ((col + 1 ) * 5);
			tileFrame.origin.y = (row * 100) + ((row + 1 ) * 5);
			
			
			tileView.center = self.view.center;
			tileView.frame = tileFrame;
			[self.view addSubview:tileView];
			
			
			UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
			[tileView addGestureRecognizer:tapRecognizer];
			
			UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)] autorelease];
			[tileView addGestureRecognizer:panRecognizer];
 
		}
	}
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer;
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	UIView	*tappedView = [tapRecognizer view];
	tappedView.center = CGPointMake(0, 0);
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer;
{

	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	UIView	*pannedView = [panRecognizer view];
	
	if (panRecognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint p = [panRecognizer translationInView:self.view];
		NSLog(@"Translation: %@", NSStringFromCGPoint(p));
		
		//moving on x axis?
		if (p.x != 0) {
			NSLog(@"Moving on x axis");
		}
				
		//moving on y axis?
		if (p.y != 0) {
			NSLog(@"Moving on y axis");
		}
		
		CGPoint newCenter = pannedView.center;
		newCenter.x += p.x;
		newCenter.y += p.y;
		
		pannedView.center = newCenter;
		[self.view bringSubviewToFront:pannedView];
		
		[panRecognizer setTranslation:CGPointZero inView:self.view];
	}
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}
@end
