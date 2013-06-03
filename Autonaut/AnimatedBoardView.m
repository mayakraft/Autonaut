//
//  AnimatedBoardView.m
//  Autonaut
//
//  Created by Robby on 5/9/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "AnimatedBoardView.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>

@implementation AnimatedBoardView
@synthesize automataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        BOARD_WIDTH = 23;
        BOARD_HEIGHT = 23;
        flipTime = 0.5;
        flipTimeFloor = 0.5;
        intervalTime = 1.0;
        intervalTimeFloor = .33;
        
        board = [[UIView alloc] initWithFrame:CGRectMake(-(frame.size.height-frame.size.width)/2, -frame.size.height/2, frame.size.height, frame.size.height)];
        [[board layer] setAnchorPoint:CGPointMake(0.5, 0)];
        [board setCenter:CGPointMake(frame.size.width/2, 0)];
        animatedCells = [[NSMutableArray alloc] init];
        travelingRow = [[NSMutableArray alloc] init];

        [self loadNewAutomata:[NSNumber numberWithInteger:60]];
        
        for(int j = 0; j < BOARD_HEIGHT; j++){
            for(int i = 0; i < BOARD_WIDTH; i++){
                [animatedCells addObject:[[UIView alloc] initWithFrame:CGRectMake(i*board.bounds.size.width/BOARD_WIDTH,
                                                                              j*board.bounds.size.height/BOARD_HEIGHT,
                                                                              board.bounds.size.width/BOARD_WIDTH,
                                                                              board.bounds.size.height/BOARD_HEIGHT)]];
//                ((UIView*)animatedCells[j*BOARD_WIDTH+i]).layer.anchorPoint = CGPointMake(0.5f,1);
                [(UIView*)animatedCells[j*BOARD_WIDTH+i] setBackgroundColor:[UIColor colorWithWhite:[[automataArray objectAtIndex:j*BOARD_WIDTH+i] boolValue] alpha:1.0]];
                [((UIView*)animatedCells[j*BOARD_WIDTH+i]) setHidden:YES];
                [board addSubview:[animatedCells objectAtIndex:j*BOARD_WIDTH+i]];
            }
        }
        for(int i = 0; i < BOARD_WIDTH; i++){
            [travelingRow addObject:[[UIView alloc] initWithFrame:CGRectMake(i*board.bounds.size.width/BOARD_WIDTH,
                                                                        -board.bounds.size.height/BOARD_HEIGHT/2.0,
                                                                        board.bounds.size.width/BOARD_WIDTH,
                                                                        board.bounds.size.height/BOARD_HEIGHT)]];
            [travelingRow[i] layer].zPosition = 10;
            [travelingRow[i] setTag:i];
            [travelingRow[i] layer].anchorPoint = CGPointMake(0.5f,1);
//            [[travelingRow[i] layer] setShadowColor:[[UIColor grayColor] CGColor]];
//            [[travelingRow[i] layer] setShadowOffset:CGSizeMake(1.1, 1.1)];
//            [[travelingRow[i] layer] setShadowRadius:3.0];
            [board addSubview:[travelingRow objectAtIndex:i]];
        }

    }
    [self addSubview:board];
    board.transform = CGAffineTransformMakeScale(5.0, 5.0);
//    [self zoomOut];
    [self performSelector:@selector(zoomOut:) withObject:[NSNumber numberWithInteger:1] afterDelay:1.0];
    [self performSelector:@selector(zoomOut:) withObject:[NSNumber numberWithInteger:2] afterDelay:3.0];
    [self performSelector:@selector(zoomOut:) withObject:[NSNumber numberWithInteger:3] afterDelay:6.5];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:1] afterDelay:1.0];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:1] afterDelay:2.0];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:2] afterDelay:3.75];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:2] afterDelay:4.0];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:2] afterDelay:4.25];
    [self performSelector:@selector(speedFlipsPhase:) withObject:[NSNumber numberWithInteger:2] afterDelay:4.5];
    return self;
}
-(void)zoomOut:(NSNumber*)phase
{
    NSLog(@"Zoom %@",phase);
    CGAffineTransform largeZoom;// = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView beginAnimations:[NSString stringWithFormat:@"zoom%@",phase] context:nil];
    if([phase integerValue] == 1){
        [UIView setAnimationDuration:2.0];
        largeZoom = CGAffineTransformMakeScale(4.8f, 4.8f);
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }
    else if([phase integerValue] == 2){
        [UIView setAnimationDuration:3.52];
        largeZoom = CGAffineTransformMakeScale(1.05f, 1.05f);
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    else if([phase integerValue] == 3){
        [UIView setAnimationDuration:.666];
        largeZoom = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    [UIView setAnimationBeginsFromCurrentState:YES];
    board.transform = largeZoom;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
}

-(void) speedFlipsPhase:(NSNumber*)phase{
    if([phase integerValue] == 1)
    intervalTime *= .5;
    intervalTimeFloor *= .5;
    if([phase integerValue] == 1){
        flipTime *= .88;
        flipTimeFloor *= .88;
    }
    else if ([phase integerValue] == 2){
        flipTime *= .66;
        flipTimeFloor *= .66;
    }
    NSLog(@"Speed Up : %@",phase);
//    NSLog(@"HALF LIFE flip:%f (+floor:%f",flipTime, flipTimeFloor);
//    NSLog(@"HALF LIFE interval:%f (+floor:%f",intervalTime, intervalTimeFloor);
}
-(void) triggerFlipCellBegin
{
    CATransform3D identity = CATransform3DIdentity;
    for(UIView *square in travelingRow)
    {
        [square layer].transform = identity;
        if(square.tag == ((int) travelingRow.count/2))
            [self performSelector:@selector(flipCellVertical:) withObject:[NSNumber numberWithInteger:square.tag]];
        else
            [self performSelector:@selector(flipCellVertical:) withObject:[NSNumber numberWithInteger:square.tag] afterDelay:arc4random()%100/100.0*intervalTime + intervalTimeFloor];
    }
}

-(void) loadNewAutomata:(NSNumber*) ruleNumber{
    Automata *titleAutomata = [[Automata alloc] initwithRule:[ruleNumber integerValue] randomInitials:YES width:BOARD_WIDTH height:BOARD_HEIGHT];
    automataArray = [titleAutomata arrayFromData];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
//    if([[animationID substringToIndex:3] isEqualToString:@"zoom"])
//    {
//        
//    }
    if([animationID respondsToSelector:@selector(integerValue)])
    {
        NSInteger selection = [animationID integerValue]%BOARD_WIDTH;//((int)[animationID integerValue]/BOARD_WIDTH)+[animationID integerValue]%BOARD_WIDTH;
        NSInteger checkerboardIndex = ([animationID integerValue]+BOARD_WIDTH);// % (BOARD_HEIGHT * BOARD_WIDTH + BOARD_WIDTH);
        if(checkerboardIndex > BOARD_HEIGHT * BOARD_WIDTH + BOARD_WIDTH){
            [travelingRow[selection] setHidden:YES];
            return;
        }
        if(checkerboardIndex-BOARD_WIDTH >= 0 && checkerboardIndex-BOARD_WIDTH < BOARD_WIDTH*BOARD_HEIGHT)
            [animatedCells[checkerboardIndex-BOARD_WIDTH] setHidden:NO];
        CATransform3D identity = CATransform3DIdentity;
        [travelingRow[selection] layer].transform = identity;
        CGRect rect = CGRectMake([travelingRow[selection] frame].origin.x,
                                 (((int)checkerboardIndex/BOARD_WIDTH)-1)*board.bounds.size.height/BOARD_HEIGHT,
                                 board.bounds.size.width/BOARD_WIDTH,
                                 board.bounds.size.height/BOARD_HEIGHT);
        [travelingRow[selection] setFrame:rect];
        [self performSelector:@selector(flipCellVertical:) withObject:[NSNumber numberWithInteger:checkerboardIndex] afterDelay:arc4random()%100/100.0*intervalTime + intervalTimeFloor];
    }
}
-(void)flipCellVertical:(NSNumber*)squareNumber
{
    //    NSLog(@"%@",squareNumber);
    NSInteger selection = [squareNumber integerValue]%BOARD_WIDTH;
    CATransform3D transformFlipDown = CATransform3DIdentity;
    transformFlipDown.m34 = -1.0 / 100;
    transformFlipDown = CATransform3DRotate(transformFlipDown, M_PI, 1, 0, 0);
    [UIView beginAnimations:[NSString stringWithFormat:@"%@",squareNumber] context:nil];
    CGFloat flipInterval = arc4random()%100/100.0*flipTime+flipTimeFloor;
    [UIView setAnimationDuration:flipInterval];
    [travelingRow[selection] layer].transform = transformFlipDown;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
    bool nextCell;
    if([squareNumber integerValue] >= 0 && [squareNumber integerValue] < BOARD_WIDTH * BOARD_HEIGHT - BOARD_WIDTH){
//        NSLog(@"Automata Number: %@",squareNumber);
        nextCell = [[automataArray objectAtIndex:[squareNumber integerValue]+BOARD_WIDTH] boolValue];
    }
    else{
        nextCell = arc4random()%2;
//        NSLog(@"Random Number: %d",nextCell);
    }
    [travelingRow[selection] performSelector:@selector(setBackgroundColor:) withObject:[UIColor colorWithWhite:nextCell alpha:1.0] afterDelay:flipInterval/2.0];
}

@end
