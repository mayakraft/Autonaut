//
//  RuleButton.m
//  Autonaut
//
//  Created by Robby on 5/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "RuleButton.h"
#import "Generator.h"
#import <QuartzCore/CAAnimation.h>

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
        blackfuzz = [[UIImageView alloc] initWithFrame:CGRectMake(-.5*(frame.size.width*1.208-frame.size.width),-.5*(frame.size.width*1.208/1.353125-frame.size.height),frame.size.width*1.208,frame.size.width*1.208/1.353125)];
        whitefuzz = [[UIImageView alloc] initWithFrame:blackfuzz.frame];
        [blackfuzz setImage:[UIImage imageNamed:@"blackfuzz.png"]];
        [whitefuzz setImage:[UIImage imageNamed:@"whitefuzz.png"]];
        [self addSubview:blackfuzz];
        [self sendSubviewToBack:blackfuzz];
        [self addSubview:whitefuzz];
        [self sendSubviewToBack:whitefuzz];
        [whitefuzz setAlpha:0.0];
//        bg.exclusiveTouch = NO;
        state = 0;
    }
    return self;
}

-(void) setState:(BOOL)s
{
    state = s;
    [self animateStateChange];
}

-(void) updateFuzzState
{
    [UIView beginAnimations:@"alternateFuzz" context:nil];
    [UIView setAnimationDuration:0.33];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if(state){
        [whitefuzz setAlpha:1.0];
        [blackfuzz setAlpha:0.0];
    }
    else{
        [whitefuzz setAlpha:0.0];
        [blackfuzz setAlpha:1.0];
    }
    [UIView commitAnimations];
}

-(void) animateStateChange
{
    UIColor *cellColor;
    if(state) cellColor = [UIColor whiteColor];
    else      cellColor = [UIColor blackColor];
    
    [self performSelectorInBackground:@selector(updateFuzzState) withObject:nil];
    
    bottom = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, self.frame.size.height/4.0, self.frame.size.width/3.0, self.frame.size.height/2.0)];
    [bottom setUserInteractionEnabled:NO];
    [bottom setBackgroundColor:center.backgroundColor];
    [[bottom layer] setAnchorPoint:CGPointMake(0.5, 1.0)];
    [self addSubview:bottom];
    
    CATransform3D transformFlip = CATransform3DIdentity;
    transformFlip.m34 = -1.0 / 50;
    transformFlip = CATransform3DRotate(transformFlip, M_PI, 1, 0, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.24];
    [[bottom layer] setTransform:transformFlip];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
    [bottom performSelector:@selector(setBackgroundColor:) withObject:cellColor afterDelay:.24*.48];
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
