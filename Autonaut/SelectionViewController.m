//
//  SelectionViewController.m
//  Autonaut
//
//  Created by Robby on 6/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "SelectionViewController.h"
#import "Colors.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SelectionViewController ()
{
    NSArray *interestingSingle;
    NSArray *interestingRandom;
    UIScrollView *scroll;
    NSMutableArray *pullToRefreshDots;
    UIColor *offColor;
    UIColor *onColor;
    UIColor *complementColor;
    NSInteger YOFFSET;
}
@end

@implementation SelectionViewController
@synthesize ruleSelection;

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
    
    YOFFSET = 20;
    if(IS_IPAD())
        YOFFSET = 0;
    
    pullToRefreshDots = [NSMutableArray array];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [scroll setDelaysContentTouches:NO];
    int SQUARES = 64;
    while (SQUARES*8 > [[UIScreen mainScreen] bounds].size.width) SQUARES/=2.0;
    
    interestingSingle = [(AppDelegate*)[UIApplication sharedApplication].delegate interestingSingle];
    interestingRandom = [(AppDelegate*)[UIApplication sharedApplication].delegate interestingRandom];
    onColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"];
    offColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"];
    complementColor = [[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"complement"];
    
    NSInteger contentSize = YOFFSET + (2 + ( interestingSingle.count + interestingRandom.count ) / 8.0 ) * self.view.frame.size.width/9.0;
    if(contentSize < [[UIScreen mainScreen] bounds].size.height)
        contentSize = [[UIScreen mainScreen] bounds].size.height+10;

    UIView *dark = [[UIView alloc] initWithFrame:CGRectMake(0, -contentSize*.5, self.view.frame.size.width, contentSize*2.0)];
    [dark setBackgroundColor:offColor];
    [dark setUserInteractionEnabled:YES];
    [scroll addSubview:dark];

    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentSize*2.0)];
    [back setBackgroundColor:complementColor];
    [back setUserInteractionEnabled:YES];
    [scroll addSubview:back];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/18.0, YOFFSET, self.view.frame.size.width*8/9.0, self.view.frame.size.width/9.0*3/2.0)];
    [count setFont:[UIFont fontWithName:@"Helvetica" size:self.view.frame.size.width/9.0*3/2.0]];
    [count setTextColor:offColor];
    int foundCount = 0;
    for(NSNumber *i in [[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"])
        if([i integerValue] == 1)
            foundCount++;
    for(NSNumber *i in [[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"])
        if([i integerValue] == 1)
            foundCount++;
    
    [count setText:[NSString stringWithFormat:@"%d/%d",foundCount, interestingRandom.count+interestingSingle.count]];
    [[count layer] setShadowOffset:CGSizeMake(-1.0, -1.0)];
    [[count layer] setShadowColor:[onColor CGColor]];
    [[count layer] setShadowOpacity:1.0];
    [[count layer] setShadowRadius:0.5];
    [count setTextAlignment:NSTextAlignmentRight];
    [count setBackgroundColor:[UIColor clearColor]];
    [scroll addSubview:count];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imageName;
    NSString *imagePath;
    int position = 0;
    BOOL found;
    for(int i = 0; i < 256; i++){
        found = false;
        for(NSNumber *element in interestingRandom)
            if(i == [element integerValue])
                found = true;
        if(found){
            imageName = [NSString stringWithFormat:@"random_%d.png",i];
            imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            UIButton *rule = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SQUARES, SQUARES)];
            [rule setImage:[[UIImage alloc] initWithContentsOfFile:imagePath] forState:UIControlStateNormal];
            [rule setFrame:CGRectMake(0, 0, SQUARES, SQUARES)];
            [rule setCenter:CGPointMake((1+position%8)*self.view.frame.size.width/9.0, YOFFSET+((int)((position)/8.0)+2)*self.view.frame.size.width/9.0)];
            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"] objectAtIndex:i] boolValue]){
                [rule.layer setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"] CGColor]];
            }
            else{
                [rule.layer setBorderColor:[offColor CGColor]];
                [rule.layer setOpacity:0.5];
                [rule setEnabled:NO];
            }
            rule.tag = i;
            [rule.layer setBorderWidth:SQUARES/24.0];
            [rule addTarget:self action:@selector(randomPressed:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:rule];
            position++;
        }
    }
    for(int i = 0; i < 256; i++){
        BOOL found = false;
        for(NSNumber *element in interestingSingle)
            if(i == [element integerValue])
                found = true;
        if(found){
            imageName = [NSString stringWithFormat:@"single_%d.png",i];
            imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            UIButton *rule = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SQUARES, SQUARES)];
            [rule setImage:[[UIImage alloc] initWithContentsOfFile:imagePath] forState:UIControlStateNormal];
            [rule setCenter:CGPointMake((1+position%8)*self.view.frame.size.width/9.0, YOFFSET+((int)((position)/8.0)+2)*self.view.frame.size.width/9.0)];
            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"] objectAtIndex:i] boolValue]){
                [rule.layer setBorderColor:[onColor CGColor]];
            }
            else{
                [rule.layer setBorderColor:[offColor CGColor]];
                [rule.layer setOpacity:0.5];
                [rule setEnabled:NO];
            }
            rule.tag = i;
            [rule.layer setBorderWidth:SQUARES/24.0];
            [rule addTarget:self action:@selector(singlePressed:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:rule];
            position++;
        }
    }
    
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, contentSize)];
    [scroll setScrollEnabled:YES];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setDelegate:self];
    [self.view addSubview:scroll];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 0){
        //in the negative
        if(scrollView.contentOffset.y > -scroll.bounds.size.width*.18){
            //add squares when you need
            NSInteger dotSpace = scrollView.bounds.size.width/30.0;
            if((int)(scrollView.contentOffset.y / -dotSpace) > pullToRefreshDots.count)
            {
                UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width*.01, scrollView.bounds.size.width*.01)];
                [dot setBackgroundColor:complementColor];
                [dot setCenter:CGPointMake(scrollView.bounds.size.width*.5, dotSpace*((int)(scrollView.contentOffset.y / -dotSpace))-dotSpace*.5 )];
                [pullToRefreshDots addObject:dot];
                [self.view addSubview:dot];
                [self animateDot:dot atPoint:CGPointMake(scrollView.bounds.size.width*.5, dotSpace*((int)(scrollView.contentOffset.y / -dotSpace))-dotSpace*.5 )];
            }
        }
        // pop all dots
        else{
            for(UIView *dot in pullToRefreshDots)
                [self popDot:dot];
            pullToRefreshDots = [NSMutableArray array];
            
        }
    }
}
-(void)popDot:(UIView*)dot
{
    CGPoint center = dot.center;
    [UIView beginAnimations:@"pop" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.166];
    [dot setFrame:CGRectMake(center.x-scroll.bounds.size.width*.05, center.y-scroll.bounds.size.width*.05, scroll.bounds.size.width*.1, scroll.bounds.size.width*.1)];
    [dot setAlpha:0.0];
    [UIView commitAnimations];
}

-(void)animateDot:(UIView*)dot atPoint:(CGPoint)center{
    [dot setFrame:CGRectMake(0, 0, scroll.bounds.size.width*.05, scroll.bounds.size.width*.05)];
    [dot setAlpha:0.2];
    [dot setCenter:center];
    [UIView beginAnimations:@"spin" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.166];
    [dot setFrame:CGRectMake(center.x-scroll.bounds.size.width*.005, center.y-scroll.bounds.size.width*.005, scroll.bounds.size.width*.01, scroll.bounds.size.width*.01)];
    [dot setAlpha:1.0];
    [UIView commitAnimations];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"ScrollViewDidEndDragging : %f, %f",scrollView.contentOffset.x, scrollView.contentOffset.y);
    if(scrollView.contentOffset.y < -scroll.bounds.size.width*.18){
        ruleSelection = nil;
        [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"ScrollViewDidEndDecelerating");
    if(pullToRefreshDots.count)
        for(UIView *square in pullToRefreshDots)
            [square removeFromSuperview];
    pullToRefreshDots = [NSMutableArray array];
}
-(void)randomPressed:(UIButton*)sender{
    ruleSelection = [NSNumber numberWithInteger:sender.tag];
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
}
-(void)singlePressed:(UIButton*)sender{
    ruleSelection = [NSNumber numberWithInteger:sender.tag];
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
