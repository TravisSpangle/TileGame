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
#include <stdlib.h>

@interface PuzzleController ()
- (void)loadTiles;
- (void)loadEditButton;
- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer;
- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer;
- (void)checkSolution;
- (void)refreshPuzzle;
- (NSMutableArray *)randomOrder;

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
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
}

- (void)viewDidAppear:(BOOL)animated;
{
	[super viewDidAppear:animated];
	[self loadTiles];
	[self loadEditButton];
}

- (void)loadTiles;
{
	int idTracker = 0;
	NSMutableArray *order = [self randomOrder];
	
	for (int row = 0; row < 3; row++) {	
		for (int col = 0; col < 3; col++) {
		
			if (row == blankX && col == blankY) {
				continue; //hole in tile
			}
			
			//PuzzleView *tileView = [PuzzleView initWithPosition:col yPosition:row];
			PuzzleView *tileView = [PuzzleView initWithIdWithPosition:[[order objectAtIndex: idTracker++] integerValue] xPosition:col yPosition:row];

			tileView.layer.borderColor = [[UIColor blueColor] CGColor];
			tileView.layer.borderWidth = 1.0;
			
			/*TODO: get this stuff in PuzzleView*/
			
			
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

- (void)loadEditButton;
{	
	UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[refreshButton addTarget:self 
					  action:@selector(refreshPuzzle)
			forControlEvents:UIControlEventTouchDown];
	[refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
	refreshButton.frame = CGRectMake(80.0, 375.0, 160.0, 40.0);
	[self.view addSubview:refreshButton];
}

- (void)refreshPuzzle;
{
	for(PuzzleView *pv in self.view.subviews){
		if([pv isKindOfClass:[PuzzleView class]]) {
			[pv removeFromSuperview];
		}
	}
	
	blankX = 2;
	blankY = 2;
	
	[self loadTiles];
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer;
{

	BOOL isAdjacent = NO;
	
	PuzzleView *pannedView = (PuzzleView *)[tapRecognizer view];
	
	/*
	NSLog(@"Blank position is at x:%i y:%i\n\t Moving tile into it from position x:%i y:%i\n\tTile Identifier:%i", blankX , blankY, [pannedView.xPosition integerValue], [pannedView.yPosition integerValue], [pannedView.orderId integerValue]);
	 */
	
	if (([pannedView.xPosition integerValue] == blankX) && ([pannedView.yPosition integerValue] != blankY)) {
		
		if (([pannedView.yPosition integerValue] == (blankY-1)) ||
			([pannedView.yPosition integerValue] == (blankY+1)) ) {
			
			isAdjacent = YES;
		}
	}
		
	//	Is Y next to it?
	if (([pannedView.yPosition integerValue] == blankY) && ([pannedView.xPosition integerValue] != blankX)) {
		
		if (([pannedView.xPosition integerValue] == (blankX-1)) ||
				([pannedView.xPosition integerValue] == (blankX+1)) ) {
			isAdjacent = YES;
		}

	}
	
	if (!isAdjacent) {
		return;
	}
	
	CGPoint newCenter = pannedView.center;
	int xCoordinate = [pannedView.xPosition integerValue];
	int yCoordinate = [pannedView.yPosition integerValue];
	
	if ([pannedView.xPosition integerValue] != blankX) {
		if ([pannedView.xPosition integerValue] > blankX) {
			newCenter.x -= 105;
			xCoordinate--;
		}else if ([pannedView.xPosition integerValue] < blankX) {
			newCenter.x += 105;
			xCoordinate++;
		}
	}
	
	if ([pannedView.yPosition integerValue] != blankY) {
		if ([pannedView.yPosition integerValue] > blankY) {
			newCenter.y -= 105;
			yCoordinate--;
		}else if ([pannedView.yPosition integerValue] < blankY) {
			newCenter.y += 105;
			yCoordinate++;
		}
	}
	
	//reset the blank coordinates
	blankX = [pannedView.xPosition integerValue];
	blankY = [pannedView.yPosition integerValue];
	
	//reset tiles posistion
	[pannedView setXPosition:[NSNumber numberWithInt:xCoordinate]];
	[pannedView setYPosition:[NSNumber numberWithInt:yCoordinate]];
	
	[self.view bringSubviewToFront:pannedView];
	[PuzzleView animateWithDuration:0.1 animations:^{
		pannedView.center = newCenter;
	}];
	
	[self checkSolution];
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer;
{
	PuzzleView *pannedView = (PuzzleView *)[panRecognizer view];
	
	if (panRecognizer.state != UIGestureRecognizerStateChanged) {
		//do not process of if this gesture is not part of a continuous change.
		panIteration = 0;
		xIteration = 0;
		yIteration = 0;
		return;
	}
	
	/*recieve the moving coordinates and stor into x/yIteration values. We want to collect this data for 4 touch notifications before we decide to move left or right. */
	CGPoint p = [panRecognizer translationInView:self.view];

	//NSLog(@"Translation: %@", NSStringFromCGPoint(p));
	xIteration += p.x;
	yIteration += p.y;
	//NSLog(@"\tMoving x:%i y:%i", xIteration, yIteration);
	
	if(++panIteration < 4) {
		//keep counting
		return;
	}else {
		//reset for next decision.
		panIteration = 0;
	}
	
	//Do not allow the user to move anything during animation
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	CGPoint newCenter = pannedView.center;
	
	int xCoordinate = [pannedView.xPosition integerValue];
	int yCoordinate = [pannedView.yPosition integerValue];
	
	//making everything positive for a simplier comparison 
	//TODO: does this provide accurate results for -1,+1 scenarios?
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
			xCoordinate++;
		}else {
			xCoordinate--;
			newCenter.x += -105;
		}
		//newCenter.x += p.x;
	}else {
		//NSLog(@"Moving on y axis x:%i y:%i", xIteration, yIteration);
		if (p.y >= -1) {
			newCenter.y += 105;
			yCoordinate++;
		}else {
			newCenter.y += -105;
			yCoordinate--;
		}
		//newCenter.y += p.y;
	}
	
	//resetting count
	xIteration = 0;
	yIteration = 0;
	
	//TODO: extract tap boundries into a function and call here
	if (newCenter.x > 320 || newCenter.x < puzzleSpacer || newCenter.y < puzzleSpacer || newCenter.y > 310) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		return;
	}
	
	if (xCoordinate != blankX || yCoordinate != blankY) {
		//tile is not moving to the empty space, then it doesn't move
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		return;
	}
	
	//NSLog(@"Moving to blank position.\nblank:\tx:%i y:%i\ngoing:\tx:%i y:%i",blankX, blankY, xCoordinate, yCoordinate);
	
	
	//NSLog(@"Blank position is at x:%i y:%i\n\t Moving tile into it from position x:%i y:%i\n\tTile Identifier:%i", blankX , blankY, [pannedView.xPosition integerValue], [pannedView.yPosition integerValue], [pannedView.orderId integerValue]);

	//reset the blank coordinates
	blankX = [pannedView.xPosition integerValue];
	blankY = [pannedView.yPosition integerValue];
	
	//reset tiles posistion
	[pannedView setXPosition:[NSNumber numberWithInt:xCoordinate]];
	[pannedView setYPosition:[NSNumber numberWithInt:yCoordinate]];
	
	[self.view bringSubviewToFront:pannedView];
	[PuzzleView animateWithDuration:0.1 animations:^{
		pannedView.center = newCenter;
	}];
	
	//pannedView.center = newCenter;
	//[panRecognizer setTranslation:CGPointZero inView:self.view];
	
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	
	[self checkSolution];
}

- (void)checkSolution;
{
	//blank space must be in bottom right corner to be solved
	if (blankX !=2 || blankY != 2) {
		return;
	}
	
	BOOL solved = YES;
	
	//collect subviews
	NSMutableArray *views = [[[NSMutableArray alloc] init] autorelease];
	[views addObjectsFromArray:self.view.subviews];
	
	NSMutableArray *tilesToSort = [[[NSMutableArray alloc] init] autorelease];
	for(PuzzleView *pv in views) {
		if ([pv isKindOfClass:[PuzzleView class]]) {
			[tilesToSort addObject:pv];
		}
	}
	
	NSSortDescriptor *sortedTilesByX = [[[NSSortDescriptor alloc] initWithKey:@"xPosition" ascending:YES] autorelease];
	[tilesToSort sortUsingDescriptors:[NSArray arrayWithObject:sortedTilesByX]];
	
	NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:[tilesToSort count]];
	
	while([tilesToSort count]) 
	{
		id groupLead = [tilesToSort objectAtIndex:0];  
		NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"yPosition = %@", [groupLead yPosition]];
		
		NSArray *group = [tilesToSort filteredArrayUsingPredicate: groupPredicate];
		
		[sortedArray addObjectsFromArray:group];
		[tilesToSort removeObjectsInArray:group];
	}
		
	int solutionChecker = 0;
	for(PuzzleView *pv in sortedArray) {
		if ([pv isKindOfClass:[PuzzleView class]]) {
			NSLog(@"pv position x:%i y:%i id:%i",[pv.xPosition integerValue], [pv.yPosition integerValue], [pv.orderId integerValue]);
			if (++solutionChecker != [pv.orderId integerValue]) {
				solved = NO;
			}
		}
	}
	
	if (solved == YES) {
		NSLog(@"Solved!");
	}
}

- (NSArray *)randomOrder;
{	
	NSArray *correctOrder=[[NSArray alloc] initWithObjects:
						   [NSNumber numberWithInt:1],
						   [NSNumber numberWithInt:2],
						   [NSNumber numberWithInt:3],
						   [NSNumber numberWithInt:4],
						   [NSNumber numberWithInt:5],
						   [NSNumber numberWithInt:6],
						   [NSNumber numberWithInt:7],
						   [NSNumber numberWithInt:8],
						   nil];

	NSMutableArray *order = [[[NSMutableArray alloc] initWithArray:correctOrder ] autorelease];
	NSMutableArray *randOrder = [[[NSMutableArray alloc] init] autorelease];
	
	BOOL notSolvable = NO;
	
	do {

		do {
			int randomIndex = rand() % [order count];

			[randOrder addObject:[order objectAtIndex:randomIndex]];
			[order removeObjectAtIndex:randomIndex];
		} while ([order count] > 0);

		/*
		 Loop through array and count cases where the number is greater than the numbers that appear after it (inversions). As the tiles have an odd amount of rows it needs an even number of inversions.
		 */
		int inversionCheck = 0;
		for (int tileCount = 0; tileCount < [randOrder count]; tileCount++) {
			
			for (int checkInversion = tileCount+1; checkInversion <[randOrder count]; checkInversion++) {

				if ([[randOrder objectAtIndex:tileCount] integerValue] > [[randOrder objectAtIndex:checkInversion] integerValue]) {
					inversionCheck++;
				}
			}
		}
		
		if ((inversionCheck % 2) == 0) {
			notSolvable = YES;			
		}else {
			//start over
			[order addObjectsFromArray:correctOrder];
			[randOrder removeAllObjects];
		}

	} while (notSolvable == NO);
	
	[correctOrder release];
	
	return randOrder;
}

@end
