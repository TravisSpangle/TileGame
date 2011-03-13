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

	int panIteration, xIteration, yIteration, puzzleSpacer;
@end

@implementation PuzzleController

- (void)loadView;
{
	self.view = [[[PuzzleView alloc] init] autorelease];
	blankX = 2;
	blankY = 2;
	
	puzzleSpacer = 5;
	
	panIteration = 0;
	xIteration = 0;
	yIteration = 0;
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
			
			if (row == blankX && col == blankY) {
				continue; //hole in tile
			}
			
			//UIView *tileView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
			PuzzleView *tileView = [PuzzleView initWithPosition:col yPosition:row];
			//UIView *tileView = [[[PuzzleView alloc] initWithFrame:CGRectZero] autorelease];
			tileView.backgroundColor = [UIColor greenColor];
			tileView.layer.borderColor = [[UIColor blueColor] CGColor];
			tileView.layer.borderWidth = 1.0;
			
			CGRect tileFrame = CGRectMake(0, 0, 100, 100);

			tileFrame.origin.x = (col * 100) + ((col + 1 ) * puzzleSpacer);
			tileFrame.origin.y = (row * 100) + ((row + 1 ) * puzzleSpacer);
			
			
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
	//UIView	*tappedView = [tapRecognizer view];
	//tappedView.center = CGPointMake(0, 0);
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer;
{

	//UIView *pannedView = [panRecognizer view];
	PuzzleView *pannedView = (PuzzleView *)[panRecognizer view];
	//TileView *piece = (TileView *)[gestureRecognizer view];
	
	if (panRecognizer.state != UIGestureRecognizerStateChanged) {
		//do not process of if this gesture is not part of a continuous change.
		return;
	}
	
	/*recieve the moving coordinates and stor into x/yIteration values. We want to collect this data for 4 touch notifications before we decide to move left or right. */
	CGPoint p = [panRecognizer translationInView:self.view];

	//NSLog(@"Translation: %@", NSStringFromCGPoint(p));
	xIteration += p.x;
	yIteration += p.y;
	//NSLog(@"\tMoving x:%i y:%i", xIteration, yIteration);
	
	if(++panIteration < 4) {
		return;
	}else {
		//reset for next decision.
		panIteration = 0;
	}
	
	//Do not allow the user to move anything during animation
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	CGPoint newCenter = pannedView.center;
	
	if (xIteration <= -1) {
		xIteration *= -1;
	}
	
	if (yIteration <= -1) {
		yIteration *= -1;
	}
	
	if (xIteration > yIteration) {
		//moving on x axis
		//NSLog(@"Moving on x axis x:%i y:%i", xIteration, yIteration);			
		if (p.x >= -1) {
			newCenter.x += 105;
		}else {
			newCenter.x += -105;
		}
		//newCenter.x += p.x;
	}else {
		//NSLog(@"Moving on y axis x:%i y:%i", xIteration, yIteration);
		if (p.y >= -1) {
			newCenter.y += 105;
		}else {
			newCenter.y += -105;
		}
		//newCenter.y += p.y;
	}
	
	//resetting count
	xIteration = 0;
	yIteration = 0;
	
	if (newCenter.x > 320 || newCenter.x < puzzleSpacer || newCenter.y < puzzleSpacer || newCenter.y > 310) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		return;
	}
	
	NSLog(@"Moving tile on x:%i y:%i", [pannedView.xPosition integerValue], [pannedView.yPosition integerValue]);
	
	pannedView.center = newCenter;
	[self.view bringSubviewToFront:pannedView];
	
	[panRecognizer setTranslation:CGPointZero inView:self.view];
	
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	
}
@end
