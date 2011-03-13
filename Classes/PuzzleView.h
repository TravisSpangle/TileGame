//
//  PuzzleView.h
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PuzzleView : UIView {
	NSNumber * xPosition;
	NSNumber * yPosition;
}
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;

+ (PuzzleView *)initWithPosition:(int)xCoordinate yPosition:(int)yCoordinate;

@end
