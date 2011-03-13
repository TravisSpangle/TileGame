//
//  PuzzleView.m
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "PuzzleView.h"

@implementation PuzzleView
@synthesize xPosition, yPosition, identifier;
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self addSubview:nameLabel];
		[nameLabel release];
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

+ (PuzzleView *)initWithIdWithPosition:(int)identifier_ xPosition:(int)xPosition_ yPosition:(int)yPosition_;
{
	PuzzleView *pv = [[[PuzzleView alloc] init] autorelease];
	[pv setXPosition:[NSNumber numberWithInt:xPosition_]];
	[pv setYPosition:[NSNumber numberWithInt:yPosition_]];
	
	[pv setIdentifier:[NSNumber numberWithInt:identifier_]];
	
	return pv;
}
- (void)drawRect:(CGRect)rect {
	[nameLabel setText:@"1"];
	//self.backgroundColor = [UIColor greenColor];
	
	 //self.layer.borderColor = [[UIColor blueColor] CGColor];
	// self.layer.borderWidth = 1.0;

}

- (void)dealloc {
    [super dealloc];
}


@end
