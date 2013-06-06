//
//  FlippingAutomataView.m
//  Autonaut
//
//  Created by Robby on 5/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "FlippingAutomataView.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "Colors.h"

@implementation FlippingAutomataView
@synthesize automataArray;
@synthesize stopped;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        BOARD_WIDTH = BOARD_HEIGHT = 10;
        flipTime = .66;
        intervalTime = .005;
        restartTime = 4.0;
        stopped = [NSNumber numberWithBool:NO];
        animatedCells = [[NSMutableArray alloc] init];
        automataRules = [NSArray arrayWithObjects:@18, @30, @60, @90, @106, @110, @126, nil];
        [self loadNewAutomata:[automataRules objectAtIndex:arc4random()%automataRules.count]];
        for(int j = 0; j < BOARD_HEIGHT; j++){
            for(int i = 0; i < BOARD_WIDTH; i++){
                [animatedCells addObject:[[UIView alloc] initWithFrame:CGRectMake(i*self.bounds.size.width/BOARD_WIDTH,
                                                                                  j*self.bounds.size.height/BOARD_HEIGHT,
                                                                                  self.bounds.size.width/BOARD_WIDTH,
                                                                                  self.bounds.size.height/BOARD_HEIGHT)]];
                [[animatedCells objectAtIndex:j*BOARD_WIDTH+i] performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor]];
                [self addSubview:[animatedCells objectAtIndex:j*BOARD_WIDTH+i]];
            }
        }
    }
    return self;
}
-(void) beginAnimations{
    if(![stopped boolValue])
        [self performSelector:@selector(loop:) withObject:[NSNumber numberWithInteger:0]];
}
-(void) loop:(NSNumber*)cellNumber{
    NSInteger cell = [cellNumber integerValue];
    if(cell < BOARD_WIDTH*BOARD_HEIGHT){
        [self flipCell:cellNumber];
        [self performSelector:@selector(loop:) withObject:[NSNumber numberWithInteger:cell+1] afterDelay:intervalTime];
    }
}
-(void) loadNewAutomata:(NSNumber*) ruleNumber{
    Automata *titleAutomata = [[Automata alloc] initwithRule:[ruleNumber integerValue] randomInitials:YES width:BOARD_WIDTH height:BOARD_HEIGHT];
    automataArray = [titleAutomata arrayFromData];
}
-(void) resetBoard{
    CATransform3D identity = CATransform3DIdentity;
    [UIView setAnimationDuration:0.0];
    for(int i = 0; i < animatedCells.count; i++)
        [[animatedCells objectAtIndex:i] layer].transform = identity;
}
-(void)flipCell:(NSNumber*)cellNumber{
    CATransform3D transformFlip = CATransform3DIdentity;
    transformFlip.m34 = -1.0 / 100;
    transformFlip = CATransform3DRotate(transformFlip, M_PI, 0, 1, 0);
    [UIView beginAnimations:[NSString stringWithFormat:@"%@",cellNumber] context:nil];
    [UIView setAnimationDuration:flipTime];
    [[animatedCells objectAtIndex:[cellNumber integerValue]] layer].transform = transformFlip;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
    UIColor *cellColor;
    if([[automataArray objectAtIndex:[cellNumber integerValue]] boolValue])
        cellColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"];
    else
        cellColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"];
    [[animatedCells objectAtIndex:[cellNumber integerValue]] performSelector:@selector(setBackgroundColor:) withObject:cellColor afterDelay:flipTime*.48];
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
    if([animationID respondsToSelector:@selector(integerValue)])
    {
        if([animationID integerValue] == BOARD_HEIGHT*BOARD_WIDTH-1){
            [self resetBoard];
            [self loadNewAutomata:[automataRules objectAtIndex:arc4random()%automataRules.count]];
            if(![stopped boolValue])
                [self performSelector:@selector(beginAnimations) withObject:[NSNumber numberWithInteger:0] afterDelay:restartTime];
        }
    }
}
@end