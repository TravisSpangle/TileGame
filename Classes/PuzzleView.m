//
//  PuzzleView.m
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "PuzzleView.h"

@implementation PuzzleView
@synthesize x, y;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
}

- (void)dealloc {
    [super dealloc];
}


@end
