//
//  ViewController.m
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "Automata.h"
#import "Square.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "FlippingAutomataView.h"
#import "Generator.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define INTERVAL .15f
#define FLIP_INTERVAL 0.66f

#define SHRINK_TIME 0.12f
#define EXPAND_TIME 0.08f
#define SCALED_DOWN_AMOUNT 0.01  // For example, 0.01 is one hundredth of the normal size

@interface ViewController ()
{
    UIButton *generatorButton;
    UIButton *playgroundButton;
    FlippingAutomataView *flippingAutomata;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:.9 green:.87 blue:.84 alpha:1.0]];
    flippingAutomata = [[FlippingAutomataView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.height-self.view.frame.size.width)/2, 0, self.view.frame.size.height, self.view.frame.size.height)];
    [self.view addSubview:flippingAutomata];
        
    generatorButton = [[UIButton alloc] initWithFrame:CGRectMake(66, -10, [[UIScreen mainScreen] bounds].size.width-133, 40)];
    [generatorButton setTitle:@"generator ➜" forState:UIControlStateNormal];
    [generatorButton addTarget:self action:@selector(generatorButtonPress:) forControlEvents:UIControlEventTouchDown];
    [generatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0f]];
    [generatorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [generatorButton setBackgroundColor:[UIColor whiteColor]];
    generatorButton.layer.borderWidth = 3.0f;
    generatorButton.layer.borderColor = [[UIColor blackColor] CGColor];
    generatorButton.layer.cornerRadius = 20.0f;
    [generatorButton setHidden:YES];
    [generatorButton setTag:1];
    //[self.view addSubview:generatorButton];
    
    playgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, [[UIScreen mainScreen] bounds].size.width-120, 40)];
    [playgroundButton addTarget:self action:@selector(playgroundButtonPress:) forControlEvents:UIControlEventTouchDown];
    [playgroundButton setTitle:@"playground ➜" forState:UIControlStateNormal];
    [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0]];
    [playgroundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[UIColor whiteColor]];
    playgroundButton.layer.borderWidth = 3.0f;
    playgroundButton.layer.borderColor = [[UIColor blackColor] CGColor];
    playgroundButton.layer.cornerRadius = 20.0f;
    [playgroundButton setHidden: YES];
    [playgroundButton setTag:2];
    //[self.view addSubview:playgroundButton];
    
    [[generatorButton layer] setAnchorPoint:CGPointMake(0.5f, -.33)];
    [[generatorButton layer] setTransform:CATransform3DRotate(CATransform3DIdentity, M_PI/4*3, 1, 0, 0)];
    [[playgroundButton layer] setAnchorPoint:CGPointMake(0.5f, -1.0)];
    [[playgroundButton layer] setTransform:CATransform3DRotate(CATransform3DIdentity, M_PI/4*3, 1, 0, 0)];
    
    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:1.33];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:2.0];
//    [UIView beginAnimations:[NSString stringWithFormat:@"%@",squareNumber] context:nil];
//    [UIView setAnimationDuration:flipInterval];
//    [travelingRow[selection] layer].transform = transformFlipDown;
   
    
    if(IS_IPAD()){
        [generatorButton setFrame:CGRectMake(150, 100, [[UIScreen mainScreen] bounds].size.width-300, 100)];
        [generatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        generatorButton.layer.borderWidth = 8.0f;
        generatorButton.layer.cornerRadius = 50.0f;
        [playgroundButton setFrame:CGRectMake(150, 250, [[UIScreen mainScreen] bounds].size.width-300, 100)];
        [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        playgroundButton.layer.borderWidth = 8.0f;
        playgroundButton.layer.cornerRadius = 50.0f;
        
    }

    [flippingAutomata beginAnimations];

}
-(void)buttonFlipDown:(UIButton*)button
{
    [button setHidden:NO];
    CATransform3D transformFlipDown = CATransform3DIdentity;
    transformFlipDown.m34 = -1.0 / 500;
    transformFlipDown = CATransform3DRotate(transformFlipDown, 0, 1, 0, 0);
    [UIView beginAnimations:[NSString stringWithFormat:@"flipButtonDown%d",button.tag] context:nil];
    [UIView setAnimationDuration:0.33];
    [[button layer] setTransform:transformFlipDown];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}
-(IBAction)generatorButtonPress:(id)sender{
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator"];
    [self performSelector:@selector(animateCheckerboardShrinkAndReposition) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground" afterDelay:0.20];
    Generator *generator = [[Generator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:generator];
}
-(IBAction)playgroundButtonPress:(id)sender{
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground"];
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator" afterDelay:0.20];
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    if ([animationID isEqualToString:@"generator"] || [animationID isEqualToString:@"playground"])
    {
        [UIView beginAnimations:@"animationShrink" context:NULL];
        [UIView setAnimationDuration:SHRINK_TIME];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        if([animationID isEqualToString:@"generator"])
            generatorButton.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
        else if ([animationID isEqualToString:@"playground"])
            playgroundButton.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        [UIView commitAnimations];
    }
}
-(void)expandToCollapse:(NSString*)objectDescription
{
    [UIView beginAnimations:objectDescription context:NULL];
    [UIView setAnimationDuration:SHRINK_TIME];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if([objectDescription isEqualToString:@"generator"])
        generatorButton.transform=CGAffineTransformMakeScale(1.15, 1.15);
	else if ([objectDescription isEqualToString:@"playground"])
        playgroundButton.transform=CGAffineTransformMakeScale(1.15, 1.15);
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[UIView commitAnimations];
}
-(void)animateCheckerboardShrinkAndReposition
{
    [UIView beginAnimations:@"checkerboard" context:nil];
    flippingAutomata.autoresizesSubviews = YES;
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.66];
    flippingAutomata.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-125, -205), 0.1f, 0.1f);
    [UIView commitAnimations];
}
// keyPath is @"transform.rotation.z"
//- (CAAnimation*)spinAnimationForKeyPath:(NSString*)keyPath
//{
//    CAKeyframeAnimation * animation;
//    animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
//    animation.duration = FLIP_INTERVAL;
//    animation.delegate = self;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    
//    // Create arrays for values and associated timings.
//    float degrees = M_PI;
//    float delta = degrees;
//    NSMutableArray *values = [NSMutableArray array];
//    NSMutableArray *timings = [NSMutableArray array];
//    NSMutableArray *keytimes = [NSMutableArray array];
//    
//    NSLog(@"Degrees: %.2f  Delta: %.2f",degrees*180/M_PI, delta*180/M_PI);
//    
//    [values addObject:[NSNumber numberWithFloat:0]];
//    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [keytimes addObject:[NSNumber numberWithFloat:0.0]];
//    
//    [values addObject:[NSNumber numberWithFloat:degrees*1.10]];
//    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [keytimes addObject:[NSNumber numberWithFloat:0.80]];
//    
//    [values addObject:[NSNumber numberWithFloat:degrees]];
//    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [keytimes addObject:[NSNumber numberWithFloat:1.0]];
//    
//    // Reduce the size of the bounce by the lid's tension
//    
//    animation.values = values;
//    animation.timingFunctions = timings;
//    animation.keyTimes = keytimes;
//    return animation;
//}
//-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
//	NSLog(@"AnimationDidStop");
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
