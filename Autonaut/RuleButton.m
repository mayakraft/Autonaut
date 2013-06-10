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
#import "Colors.h"

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

-(void) setState:(BOOL)s animated:(BOOL)animated{
    state = s;
    [self updateStateAnimated:[NSNumber numberWithBool:animated]];
    [self performSelectorInBackground:@selector(updateFuzzStateAnimated:) withObject:[NSNumber numberWithBool:animated]];
}

-(void) updateStateAnimated:(NSNumber*)animated
{
    if(![animated boolValue]){
        bottom = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, self.frame.size.height/2.0, self.frame.size.width/3.0, self.frame.size.height/2.0)];
        [bottom setUserInteractionEnabled:NO];
        if(state) [bottom setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
        else     [bottom setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
        [self addSubview:bottom];
    }
    else{
        bottom = nil;
        UIColor *cellColor;
        if(state) cellColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"];
        else      cellColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"];
        
        // this method is incomplete. it stacks uiviews on top of each other forever. memory problem.
        bottom = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, self.frame.size.height/4.0, self.frame.size.width/3.0, self.frame.size.height/2.0)];
        [bottom setUserInteractionEnabled:NO];
        [bottom setBackgroundColor:center.backgroundColor];
        [[bottom layer] setAnchorPoint:CGPointMake(0.5, 1.0)];
        [[bottom layer] setZPosition:5.0];
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
//        [bottom performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.25];
    }
}

-(void) updateFuzzStateAnimated:(NSNumber*)animated
{
    if([animated boolValue]){
        [UIView beginAnimations:@"alternateFuzz" context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    if(state){
        [whitefuzz setAlpha:1.0];
        [blackfuzz setAlpha:0.0];
    }
    else{
        [whitefuzz setAlpha:0.0];
        [blackfuzz setAlpha:1.0];
    }
    if([animated boolValue])
        [UIView commitAnimations];
}

-(void)layoutSubviews
{
    if(!(ruleNumber % 2))
        [right setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    else
        [right setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    if(!((int)(ruleNumber/2.0) % 2))
        [center setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    else
        [center setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    if(!((int)(ruleNumber/4.0) % 2))
        [left setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    else
        [left setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
}

@end
