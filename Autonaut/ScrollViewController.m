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

@interface ScrollViewController ()
{
    UIScrollView *scrollView;
    UIImageView *automataView;
    UITapGestureRecognizer *tapGesture;
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

    automata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:[random boolValue] width:self.view.bounds.size.width*3*.99999*retina height:self.view.bounds.size.height*.99999*retina];
    automataView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*3, self.view.bounds.size.height)];
    [automataView setImage:[automata GIFImageFromDataWithLightColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                          DarkColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
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
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapListener:)];
    [tapGesture setNumberOfTapsRequired:2];
    [scrollView addGestureRecognizer:tapGesture];

    [self.view addSubview:scrollView];
	// Do any additional setup after loading the view.
}
-(void)tapListener:(UITapGestureRecognizer*)sender{
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return automataView;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
