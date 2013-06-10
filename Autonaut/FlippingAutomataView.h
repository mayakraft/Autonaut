//
//  FlippingAutomataView.h
//  Autonaut
//

#import <UIKit/UIKit.h>
#import "Automata.h"

@interface FlippingAutomataView : UIView
{
    NSInteger BOARD_HEIGHT;
    NSInteger BOARD_WIDTH;
    NSMutableArray *animatedCells;
    CGFloat flipTime;
    CGFloat intervalTime;
    CGFloat restartTime;
    NSArray *automataRules;
}

@property NSArray *automataArray;
@property NSNumber *stopped;
-(void) beginAnimations;
-(void)updateColors;

@end
