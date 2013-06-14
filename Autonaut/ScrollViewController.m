//
//  ScrollViewController.m
//  Autonaut
//
//  Created by Robby on 6/2/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "ScrollViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "Colors.h"
#import "Sounds.h"

@interface ScrollViewController ()
{
    UIScrollView *scrollView;
    UIImageView *automataView;
    UITapGestureRecognizer *tap1Gesture;
    UITapGestureRecognizer *tap2Gesture;
    UIView *menu;
    UILabel *alertLabel;
    UIButton *exportButton;
}
@end

@implementation ScrollViewController
@synthesize automata;
@synthesize rule;
@synthesize random;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    NSLog(@"Scrollview Did Load");
    [super viewDidLoad];
    [self.view setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"complement"]];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSInteger retina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue];

    int howRandom = [random boolValue];
    if(howRandom && [[[NSUserDefaults standardUserDefaults] objectForKey:@"noise"] isEqualToString:@"smooth"])
        howRandom++;
    automata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:howRandom width:self.view.bounds.size.width*3*.99999*retina height:self.view.bounds.size.height*.99999*retina];
    automataView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*3*.99999, self.view.bounds.size.height*.99999)];
    [automataView setImage:[automata ImageWithColorLight:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                          Dark:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
                                                              Scale:retina]];
//    [automataView setImage:[automata GIFImageFromDataWithScale:retina]];
    automataView.layer.magnificationFilter = kCAFilterNearest;
    [scrollView addSubview:automataView];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:100.0*retina];
    [scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0)];
    [scrollView setDelegate:self];
    [scrollView flashScrollIndicators];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(automataView.bounds.size.width, automataView.bounds.size.height)];
    [self.view addSubview:scrollView];
    
    tap1Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Listener:)];
    [tap1Gesture setNumberOfTapsRequired:1];
    [scrollView addGestureRecognizer:tap1Gesture];

    tap2Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Listener:)];
    [tap2Gesture setNumberOfTapsRequired:2];
    [scrollView addGestureRecognizer:tap2Gesture];
    
    [tap1Gesture requireGestureRecognizerToFail:tap2Gesture];

    menu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [menu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menu.png"]]];//[UIColor colorWithWhite:0.0 alpha:0.66]];
    [menu setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height-22)];
    [self.view addSubview:menu];
    exportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
    [exportButton setBackgroundImage:[UIImage imageNamed:@"export"] forState:UIControlStateNormal];
    [exportButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [exportButton.layer setBorderWidth:1.0];
    [exportButton.layer setCornerRadius:4.0];
    [exportButton.layer setMasksToBounds:YES];
    [exportButton setCenter:CGPointMake(menu.bounds.size.width/2.0, menu.bounds.size.height/2.0)];
    [exportButton addTarget:self action:@selector(exportPressed:) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:exportButton];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self toggleMenu];
}
-(void)exportPressed:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(automataView.image, nil, nil, nil);
    [exportButton setEnabled:NO];
    [[Sounds mixer] playShutter];
    [self flashScreen];
    [self showMessage:@"Saved to Photo Album"];
}
-(void)flashScreen
{
    UIView *flash = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [flash setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:flash];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.33];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [flash setAlpha:0.0];
    [UIView commitAnimations];
    [flash performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}
-(void) showMessage:(NSString*)message
{
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*.475, self.view.bounds.size.width, self.view.bounds.size.height*.05)];
    [alertLabel setText:message];
    [alertLabel setFont:[UIFont boldSystemFontOfSize:self.view.bounds.size.height*.033]];
    [alertLabel setTextColor:[UIColor whiteColor]];
    [alertLabel setBackgroundColor:[UIColor blackColor]];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:alertLabel];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDelegate:self];
    [alertLabel setAlpha:0.0];
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [alertLabel removeFromSuperview];
    [exportButton setEnabled:YES];
}
-(void)tap2Listener:(UITapGestureRecognizer*)sender{
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
}
-(void)tap1Listener:(UITapGestureRecognizer*)sender{
    [self toggleMenu];
}
-(void)toggleMenu{
    if(menu.center.y == self.view.bounds.size.height-22){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.16];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [menu setCenter:CGPointMake(menu.center.x, self.view.bounds.size.height+22)];
        [UIView commitAnimations];
    }
    else if(menu.center.y == self.view.bounds.size.height+22){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.16];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [menu setCenter:CGPointMake(menu.center.x, self.view.bounds.size.height-22)];
        [UIView commitAnimations];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return automataView;
}
//-(void)viewDidLayoutSubviews{
//    
//}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
