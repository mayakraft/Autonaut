//
//  AnimatedBoardView.h
//  Autonaut
//
//  Created by Robby on 5/9/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Automata.h"

@interface AnimatedBoardView : UIView
{
    NSInteger BOARD_HEIGHT;
    NSInteger BOARD_WIDTH;
    UIView *board;
    NSMutableArray *animatedCells;
    NSMutableArray *travelingRow;
    CGFloat flipTime;
    CGFloat flipTimeFloor;
    CGFloat intervalTime;
    CGFloat intervalTimeFloor;
}

@property NSArray *automataArray;
-(void) triggerFlipCellBegin;

@end
