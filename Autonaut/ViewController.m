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

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define INTERVAL .15f
#define FLIP_INTERVAL 0.66f

#define SHRINK_TIME 0.12f
#define EXPAND_TIME 0.08f
#define SCALED_DOWN_AMOUNT 0.01  // For example, 0.01 is one hundredth of the normal size

@interface ViewController ()
{
    UIView *checkerboard;
    NSMutableArray *homeCells;
    NSMutableArray *flipRow;
    NSInteger selection;
    UIButton *generatorButton;
    UIButton *playgroundButton;
    NSInteger pauseCounter;
    NSInteger BOARD_HEIGHT, BOARD_WIDTH;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:.9 green:.87 blue:.84 alpha:1.0]];

    if (IS_IPAD() || [[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] bounds].size.width < 5/3.0)
        BOARD_HEIGHT = 12;//8;
    else
        BOARD_HEIGHT = 15;//10;
    BOARD_WIDTH = 9;//6;

    Automata *titleAutomata = [[Automata alloc] initwithRule:60 randomInitials:YES width:BOARD_WIDTH height:BOARD_HEIGHT];
    NSArray *automataArray = [titleAutomata arrayFromData];
    /*UIImage *automata = [[Automata alloc] initwithRule:18 randomInitials:YES width:320 height:320 retinaScale:2.0];
    UIImageView *automataView = [[UIImageView alloc] initWithImage:automata];
    automataView.layer.masksToBounds = NO;
    automataView.layer.cornerRadius = 8; // if you like rounded corners
    automataView.layer.shadowOffset = CGSizeMake(-5, 7);
    automataView.layer.shadowRadius = 5;
    automataView.layer.shadowOpacity = 0.5;
    [automataView setFrame:CGRectMake(900, 1500, 160, 160)];
    [self.view addSubview:automataView];*/
    

//    checkerboard = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                            [[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.width-20,
//                                                            [[UIScreen mainScreen] bounds].size.width,
//                                                            [[UIScreen mainScreen] bounds].size.width)];
    checkerboard = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            [[UIScreen mainScreen] bounds].size.width,
                                                            [[UIScreen mainScreen] bounds].size.height-20)];
    homeCells = [[NSMutableArray alloc] init];
    flipRow = [[NSMutableArray alloc] init];
    NSInteger yOffset = [[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.width;
    yOffset-=20;
    for(int i = 0; i < BOARD_WIDTH; i++){
        [flipRow addObject:[[Square alloc] initWithFrame:CGRectMake(i*checkerboard.bounds.size.width/BOARD_WIDTH,
                                                                      checkerboard.bounds.size.height/BOARD_HEIGHT - checkerboard.bounds.size.height/BOARD_HEIGHT/2.0*3,
                                                                      checkerboard.bounds.size.width/BOARD_WIDTH,
                                                                      checkerboard.bounds.size.height/BOARD_HEIGHT)]];
        [flipRow[i] layer].zPosition = 10;
        [flipRow[i] layer].anchorPoint = CGPointMake(0.5f,1);
        //((UIView*)homeCells[j*BOARD_WIDTH+i]).layer.anchorPoint = CGPointMake(checkerboard.bounds.size.width/BOARD_WIDTH/4.0, checkerboard.bounds.size.height/BOARD_HEIGHT/2.0);
        [[flipRow[i] layer] setShadowColor:[[UIColor grayColor] CGColor]];
        [[flipRow[i] layer] setShadowOffset:CGSizeMake(1.1, 1.1)];
        [[flipRow[i] layer] setShadowRadius:3.0];
        [checkerboard addSubview:[flipRow objectAtIndex:i]];
    }
    for(int j = 0; j < BOARD_HEIGHT; j++){
        for(int i = 0; i < BOARD_WIDTH; i++){
            [homeCells addObject:[[Square alloc] initWithFrame:CGRectMake(i*checkerboard.bounds.size.width/BOARD_WIDTH,
                                                                          j*checkerboard.bounds.size.height/BOARD_HEIGHT + checkerboard.bounds.size.height/BOARD_HEIGHT/2.0,
                                                                          checkerboard.bounds.size.width/BOARD_WIDTH,
                                                                          checkerboard.bounds.size.height/BOARD_HEIGHT)]];
            //((UIView*)homeCells[j*BOARD_WIDTH+i]).layer.zPosition = 10;
            ((UIView*)homeCells[j*BOARD_WIDTH+i]).layer.anchorPoint = CGPointMake(0.5f,1);
            [(Square*)homeCells[j*BOARD_WIDTH+i] setState:[[automataArray objectAtIndex:j*BOARD_WIDTH+i] boolValue]];
            //((UIView*)homeCells[j*BOARD_WIDTH+i]).layer.anchorPoint = CGPointMake(checkerboard.bounds.size.width/BOARD_WIDTH/4.0, checkerboard.bounds.size.height/BOARD_HEIGHT/2.0);
            [checkerboard addSubview:[homeCells objectAtIndex:j*BOARD_WIDTH+i]];
        }
    }
    [self.view addSubview:checkerboard];
    generatorButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 25, [[UIScreen mainScreen] bounds].size.width-100, 40)];
    [generatorButton setTitle:@"generator" forState:UIControlStateNormal];
    [generatorButton addTarget:self action:@selector(generatorButtonPress:) forControlEvents:UIControlEventTouchDown];
    [generatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0f]];
    [generatorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [generatorButton setBackgroundColor:[UIColor whiteColor]];
    generatorButton.layer.borderWidth = 3.0f;
    generatorButton.layer.borderColor = [[UIColor blackColor] CGColor];
    generatorButton.layer.cornerRadius = 20.0f;
    //[self.view addSubview:generatorButton];
    
    playgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 75, [[UIScreen mainScreen] bounds].size.width-100, 40)];
    [playgroundButton addTarget:self action:@selector(playgroundButtonPress:) forControlEvents:UIControlEventTouchDown];
    [playgroundButton setTitle:@"playground" forState:UIControlStateNormal];
    [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0]];
    [playgroundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[UIColor whiteColor]];
    playgroundButton.layer.borderWidth = 3.0f;
    playgroundButton.layer.borderColor = [[UIColor blackColor] CGColor];
    playgroundButton.layer.cornerRadius = 20.0f;
    //[self.view addSubview:playgroundButton];

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
    selection = 0;
    pauseCounter = 0;
    NSTimer *gameTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:INTERVAL target:self selector:@selector(loop) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:gameTimer forMode:NSDefaultRunLoopMode];
}
-(IBAction)generatorButtonPress:(id)sender{
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator"];
    [self performSelector:@selector(animateCheckerboardShrinkAndReposition) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground" afterDelay:0.20];
}
-(IBAction)playgroundButtonPress:(id)sender{
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground"];
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator" afterDelay:0.20];
}
-(void) loop{
    if(!pauseCounter){
        CATransform3D identity = CATransform3DIdentity;
        [flipRow[selection%BOARD_WIDTH] setFrame:CGRectMake([flipRow[selection%BOARD_WIDTH] frame].origin.x,
                                                            ((int)(selection/BOARD_WIDTH))*checkerboard.bounds.size.height/BOARD_HEIGHT - checkerboard.bounds.size.height/BOARD_HEIGHT,
                                                            [flipRow[selection%BOARD_WIDTH] frame].size.width,
                                                            [flipRow[selection%BOARD_WIDTH] frame].size.height)];
        [flipRow[selection%BOARD_WIDTH] layer].transform = identity;
        [((Square*)flipRow[selection%BOARD_WIDTH]) performSelector:@selector(randomState) withObject:self afterDelay:FLIP_INTERVAL/2.0];
        [self animate3Drotation];
        selection++;
        if(selection == BOARD_HEIGHT*BOARD_WIDTH+BOARD_WIDTH) {
            selection = 0;
            pauseCounter = 10;
        }
        if(pauseCounter == 0 && selection % BOARD_WIDTH == 0)
            pauseCounter = 1;
    }
    else
        if(pauseCounter > 0)
            pauseCounter--;
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
    if([animationID isEqualToString:@"3DFlipDown"])
    {
        NSLog(@"%f",[flipRow[0] frame].origin.y);    
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
    pauseCounter = -1;
    [UIView beginAnimations:@"checkerboard" context:nil];
    checkerboard.autoresizesSubviews = YES;
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.66];
    checkerboard.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-125, -185), 0.15f, 0.15f);
    [UIView commitAnimations];
}
-(void)animate3Drotation
{
    CATransform3D transform3DFoo = CATransform3DIdentity;
    transform3DFoo.m34 = -1.0 / 100;
    transform3DFoo = CATransform3DRotate(transform3DFoo, M_PI, 1, 0, 0);
    [UIView beginAnimations:@"3DFlipDown" context:NULL];
    [UIView setAnimationDuration:FLIP_INTERVAL];
    ((UIView*)flipRow[selection%BOARD_WIDTH]).layer.transform = transform3DFoo;//CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}
// keyPath is @"transform.rotation.z"
- (CAAnimation*)spinAnimationForKeyPath:(NSString*)keyPath
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration = FLIP_INTERVAL;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // Create arrays for values and associated timings.
    float degrees = M_PI;
    float delta = degrees;
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *timings = [NSMutableArray array];
    NSMutableArray *keytimes = [NSMutableArray array];
    
    NSLog(@"Degrees: %.2f  Delta: %.2f",degrees*180/M_PI, delta*180/M_PI);
    
    [values addObject:[NSNumber numberWithFloat:0]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [keytimes addObject:[NSNumber numberWithFloat:0.0]];
    
    [values addObject:[NSNumber numberWithFloat:degrees*1.10]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [keytimes addObject:[NSNumber numberWithFloat:0.80]];
    
    [values addObject:[NSNumber numberWithFloat:degrees]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [keytimes addObject:[NSNumber numberWithFloat:1.0]];
    
    // Reduce the size of the bounce by the lid's tension
    
    animation.values = values;
    animation.timingFunctions = timings;
    animation.keyTimes = keytimes;
    return animation;
}
-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	//NSLog(@"AnimationDidStop");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
