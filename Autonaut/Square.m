//
//  Square.m
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Square.h"
@implementation Square

@synthesize state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        state = [NSNumber numberWithBool:arc4random()%2];
        if([state boolValue])
            [self setBackgroundColor:[UIColor whiteColor]];
        else
            [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

-(void) setState:(NSNumber*)stateToBe
{
    state = stateToBe;
    if([state boolValue])
        [self setBackgroundColor:[UIColor whiteColor]];
    else
        [self setBackgroundColor:[UIColor blackColor]];
}

-(void) randomState
{
    state = [NSNumber numberWithBool:arc4random()%2];
    if([state boolValue])
        [self setBackgroundColor:[UIColor whiteColor]];
    else
        [self setBackgroundColor:[UIColor blackColor]];    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}*/

-(void) setShadow
{
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(-5, 7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

@end
