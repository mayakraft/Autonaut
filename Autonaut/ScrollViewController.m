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
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSInteger retina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue];

    automata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:[random boolValue] width:self.view.bounds.size.width*3*.99999*retina height:self.view.bounds.size.height*.99999*retina];
    automataView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*3, self.view.bounds.size.height)];
    [automataView setImage:[automata GIFImageFromDataWithScale:retina]];
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

-(void)tapListener:(UITapGestureRecognizer*)sender
{
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
//    NSLog(@"Tapped twice");
//    SEL theUnwindSelector = @selector(goToRoot:);
//    NSString *unwindSegueIdentifier = @"unwindToViewController";
//    UINavigationController *nc = [self navigationController];
//    // Find the view controller that has this unwindAction selector (may not be one in the nav stack)
//    UIViewController *viewControllerToCallUnwindSelectorOn = [nc viewControllerForUnwindSegueAction: theUnwindSelector
//                                                                                 fromViewController: self
//                                                                                         withSender:self];
//    // None found, then do nothing.
//    if (viewControllerToCallUnwindSelectorOn == nil) {
//        NSLog(@"No controller found to unwind too");
//        return;
//    }
//    
//    // Can the controller that we found perform the unwind segue.  (This is decided by that controllers implementation of canPerformSeque: method
//    BOOL cps = [viewControllerToCallUnwindSelectorOn canPerformUnwindSegueAction: theUnwindSelector
//                                                              fromViewController: self
//                                                                      withSender: sender];
//    // If we have permision to perform the seque on the controller where the unwindAction is implmented
//    // then get the segue object and perform it.
//    if (cps) {
//        
//        UIStoryboardSegue *unwindSegue = [nc segueForUnwindingToViewController: viewControllerToCallUnwindSelectorOn fromViewController: self identifier: unwindSegueIdentifier];
//        
//        [viewControllerToCallUnwindSelectorOn prepareForSegue: unwindSegue sender: self];
//        
//        [unwindSegue perform];
//    }

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return automataView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
