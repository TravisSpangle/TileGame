//
//  PuzzleView.h
//  TilePuzzel
//
//  Created by Travis Spangle on 3/11/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PuzzleView : UIView {
	NSNumber * x;
	NSNumber * y;
}
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@end
