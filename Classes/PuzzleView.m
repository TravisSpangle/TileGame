//
//  PuzzleView.m
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "PuzzleView.h"

@implementation PuzzleView
@synthesize xPosition, yPosition;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

+ (PuzzleView *)initWithPosition:(int)xPosition_ yPosition:(int)yPosition_;
{
	PuzzleView *pv = [[[PuzzleView alloc] init] autorelease];
	[pv setXPosition:[NSNumber numberWithInt:xPosition_]];
	[pv setYPosition:[NSNumber numberWithInt:yPosition_]];
	
	return pv;
}

- (void)drawRect:(CGRect)rect {
	
}

- (void)dealloc {
    [super dealloc];
}


@end
