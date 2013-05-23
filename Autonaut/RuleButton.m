//
//  RuleButton.m
//  Autonaut
//
//  Created by Robby on 5/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "RuleButton.h"
#import "Generator.h"

@implementation RuleButton
@synthesize ruleNumber;
@synthesize state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3.0, frame.size.height/2.0)];
        center = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/3.0, 0, frame.size.width/3.0, frame.size.height/2.0)];
        right = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/3.0*2, 0, frame.size.width/3.0, frame.size.height/2.0)];
        [self addSubview:left];
        [self addSubview:center];
        [self addSubview:right];
        [right setUserInteractionEnabled:NO];
        [center setUserInteractionEnabled:NO];
        [left setUserInteractionEnabled:NO];
//        bg.exclusiveTouch = NO;
    }
    return self;
}

-(void) setState:(BOOL)s
{
    NSLog(@"Set State %d",s);
    state = s;
    [(Generator*)self.superview setNewRule];
    [self animateStateChange];
}

-(void) animateStateChange
{
    NSLog(@"Animate State Change");
    bottom = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, self.frame.size.height/2.0, self.frame.size.width/3.0, self.frame.size.height/2.0)];
    if(state)
        [bottom setBackgroundColor:[UIColor whiteColor]];
    else
        [bottom setBackgroundColor:[UIColor blackColor]];
    [self addSubview:bottom];
    [bottom setUserInteractionEnabled:NO];
    
}
-(void)layoutSubviews
{
    if(!(ruleNumber % 2))
        [right setBackgroundColor:[UIColor whiteColor]];
    else
        [right setBackgroundColor:[UIColor blackColor]];
    if(!((int)(ruleNumber/2.0) % 2))
        [center setBackgroundColor:[UIColor whiteColor]];
    else
        [center setBackgroundColor:[UIColor blackColor]];
    if(!((int)(ruleNumber/4.0) % 2))
        [left setBackgroundColor:[UIColor whiteColor]];
    else
        [left setBackgroundColor:[UIColor blackColor]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
