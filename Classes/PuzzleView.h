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
	NSNumber * orderId;
	
	UILabel *nameLabel;
}
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;
@property (nonatomic, retain) NSNumber * orderId;

@property (nonatomic, retain) UILabel * nameLabel;

+ (PuzzleView *)initWithIdWithPosition:(int)identifier_ xPosition:(int)xPosition_ yPosition:(int)yPosition_;

@end
