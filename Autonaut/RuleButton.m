//
//  RuleButton.m
//  Autonaut
//
//  Created by Robby on 5/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "RuleButton.h"

@implementation RuleButton
@synthesize ruleNumber;

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
    }
    return self;
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
