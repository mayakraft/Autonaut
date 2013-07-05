//
//  ViewController.m
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "SelectionViewController.h"
#import "ScrollViewController.h"
#import "Automata.h"
#import "FlippingAutomataView.h"
#import "Generator.h"
#import "SettingsView.h"
#import "Colors.h"
#import "Sounds.h"

#import <StoreKit/StoreKit.h>
#import "InAppPurchaseHelper.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define INTERVAL .15f
#define FLIP_INTERVAL 0.66f

#define SHRINK_TIME 0.12f
#define EXPAND_TIME 0.08f
#define SCALED_DOWN_AMOUNT 0.01

@interface ViewController ()
{
    UIButton *generatorButton;
    UIButton *playgroundButton;
    UIButton *settingsButton;
    FlippingAutomataView *flippingAutomata;
    Generator *generator;
    UITapGestureRecognizer *tapGesture;
    BOOL random; // for segue transition
    SettingsView *settings;
    UIView *loadingView;
    NSArray *_products;
    UIView *alertView;
    
    UIView *activityIndicatorView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    NSLog(@"Entering View Did Load");
    [super viewDidLoad];
 
    [self.view setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"complement"]];
    flippingAutomata = [[FlippingAutomataView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.height-self.view.frame.size.width)/2, 0, self.view.frame.size.height, self.view.frame.size.height)];
    [self.view addSubview:flippingAutomata];
    
#warning lump button properties into one
    CALayer *properties = [CALayer layer];
    properties.borderWidth = 4.0f;
    properties.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    properties.cornerRadius = 25.0f;
    
    generatorButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 30, [[UIScreen mainScreen] bounds].size.width-100, 50)];
    [generatorButton setTitle:@"generator" forState:UIControlStateNormal];
    [generatorButton addTarget:self action:@selector(generatorButtonPress:) forControlEvents:UIControlEventTouchDown];
    [generatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:33.0f]];
    [generatorButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [generatorButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    generatorButton.layer.borderWidth = 4.0f;
    generatorButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    generatorButton.layer.cornerRadius = 25.0f;
    [generatorButton setHidden:YES];
    [generatorButton setTag:1];
    [self.view addSubview:generatorButton];
    
    playgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, [[UIScreen mainScreen] bounds].size.width-100, 50)];
    [playgroundButton addTarget:self action:@selector(playgroundButtonPress:) forControlEvents:UIControlEventTouchDown];
    [playgroundButton setTitle:@"playground" forState:UIControlStateNormal];
    [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:33.0]];
    [playgroundButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    playgroundButton.layer.borderWidth = 4.0f;
    playgroundButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    playgroundButton.layer.cornerRadius = 25.0f;
    [playgroundButton setHidden: YES];
    [playgroundButton setTag:2];
    [self.view addSubview:playgroundButton];
#warning playground button disabled
    [playgroundButton setEnabled:NO];

    settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 170, [[UIScreen mainScreen] bounds].size.width-100, 50)];
    [settingsButton addTarget:self action:@selector(settingsButtonPress:) forControlEvents:UIControlEventTouchDown];
    [settingsButton setTitle:@"settings" forState:UIControlStateNormal];
    [settingsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:33.0]];
    [settingsButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [settingsButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    settingsButton.layer.borderWidth = 4.0f;
    settingsButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    settingsButton.layer.cornerRadius = 25.0f;
    [settingsButton setHidden: YES];
    [settingsButton setTag:2];
    [self.view addSubview:settingsButton];

    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:.66];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.75];
    [self performSelector:@selector(buttonFlipDown:) withObject:settingsButton afterDelay:.83];
    
    if(IS_IPAD()){
        [generatorButton setFrame:CGRectMake(150, 100, [[UIScreen mainScreen] bounds].size.width-300, 100)];
        [generatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        generatorButton.layer.borderWidth = 8.0f;
        generatorButton.layer.cornerRadius = 50.0f;
        [playgroundButton setFrame:CGRectMake(150, 235, [[UIScreen mainScreen] bounds].size.width-300, 100)];
        [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        playgroundButton.layer.borderWidth = 8.0f;
        playgroundButton.layer.cornerRadius = 50.0f;
        [settingsButton setFrame:CGRectMake(150, 370, [[UIScreen mainScreen] bounds].size.width-300, 100)];
        [settingsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        settingsButton.layer.borderWidth = 8.0f;
        settingsButton.layer.cornerRadius = 50.0f;
    }

    [flippingAutomata beginAnimations];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapListener:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];

    [tapGesture setEnabled:NO];
    generator = nil;
    
    loadingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [loadingView setBackgroundColor:[UIColor blackColor]];
    [loadingView setAlpha:0.0];
    [loadingView setUserInteractionEnabled:NO];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setFrame:CGRectMake(0, 0, 36, 36)];
    [activityIndicator setCenter:[loadingView center]];
    [loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self.view addSubview:loadingView];
    

//    UIButton *selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [selectionButton setBackgroundColor:[UIColor orangeColor]];
//    [selectionButton addTarget:self action:@selector(goSelection:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:selectionButton];
    NSLog(@"ViewController viewDidLoad did load");
}

-(void)goSelection:(id)sender{
    [[Sounds mixer] playTouch];
    [self performSegueWithIdentifier:@"SelectionViewSegue" sender:nil];
}
-(void) rulePressed{
    NSLog(@"RulePressed, DELEGATE");
    [tapGesture setEnabled:YES];
}

-(void) updateColorsProgramWide
{
    [generator updateColors];
    [flippingAutomata updateColors];
    [self.view setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"complement"]];
    [generatorButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [generatorButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    generatorButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    [playgroundButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    playgroundButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    [settingsButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [settingsButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    settingsButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
}

- (IBAction) unwindToViewController: (UIStoryboardSegue*) unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[ScrollViewController class]])
    {
        [loadingView setAlpha:0.0];
        NSLog(@"Unwinding from ScrollView!");
    }
    else if ([sourceViewController isKindOfClass:[SelectionViewController class]])
    {
        NSLog(@"Unwinding from SelectionView! RULE: %@",[(SelectionViewController*)sourceViewController ruleSelection]);
        if([(SelectionViewController*)sourceViewController ruleSelection] != nil){
            [generator setRule:[(SelectionViewController*)sourceViewController ruleSelection]];
            [generator updateImageViews];
            [generator updateRuleButtonsAnimated:@1];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FullScreenSegue"]){
        ScrollViewController *vc = [segue destinationViewController];
        [vc setRandom:[NSNumber numberWithBool:random]];
        [vc setRule:generator.rule];
    }
}
-(void) viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
-(void)buttonFlipDown:(UIButton*)button
{
    [[button layer] setAnchorPoint:CGPointMake(0.5f, -.33)];
    [[button layer] setTransform:CATransform3DRotate(CATransform3DIdentity, M_PI*.5, 1, 0, 0)];
    [button setHidden:NO];
    CATransform3D transformFlipDown = CATransform3DIdentity;
    transformFlipDown.m34 = -1.0 / 500;
    transformFlipDown = CATransform3DRotate(transformFlipDown, 0, 1, 0, 0);
    [UIView beginAnimations:[NSString stringWithFormat:@"flipButtonDown%d",button.tag] context:nil];
    [UIView setAnimationDuration:0.2];
    [[button layer] setTransform:transformFlipDown];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}
-(IBAction)generatorButtonPress:(id)sender{
    [[Sounds mixer] playTouch];
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator"];
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground" afterDelay:0.1];
    [self performSelector:@selector(expandToCollapse:) withObject:@"settings" afterDelay:0.2];
    [self performSelector:@selector(animateCheckerboardShrinkAndReposition) withObject:nil afterDelay:0.2];
    [tapGesture setEnabled:YES];
//    [tapGesture performSelector:@selector(setEnabled:) withObject:@1 afterDelay:1.0];
    NSLog(@"%f : %f : %f : %f", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    if(generator == nil){
        generator = [[Generator alloc] initWithFrame:CGRectMake( self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"rule"])
            [generator setRule:[[NSUserDefaults standardUserDefaults] objectForKey:@"rule"]];
        else
            [generator setRule:@30];
    }
    [flippingAutomata setStopped:@1];
    [generator setNewRule];
    flippingAutomata.autoresizesSubviews = YES;
    generator.autoresizesSubviews = YES;
    generator.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(13.333f, 13.333f),self.view.frame.size.width*.5-self.view.frame.size.width*.166, .5*self.view.frame.size.height-self.view.frame.size.height*0.075);
    [generator setDelegate:self];
    [self.view addSubview:generator];
    [self.view sendSubviewToBack:generator];
}
-(IBAction)playgroundButtonPress:(id)sender{}

-(IBAction)settingsButtonPress:(id)sender{

    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"com.robbykraft.cellular.colors"] boolValue])
    {
        InAppPurchaseHelper *inAppPurchaseHelper = [InAppPurchaseHelper sharedInstance];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (![inAppPurchaseHelper productPurchasedWithProductIdentifier:[delegate purchaseColorsProductIdentifier]]){
            NSLog(@"com.robbykraft.cellular.colors has not been purchased");
        }
        [inAppPurchaseHelper setViewController:self];
        
        //obtain the list of in-app products
        [inAppPurchaseHelper requestProductsWithOnCompleteBock:^(BOOL success, NSArray *products) {
            if (success){
                _products = products;
                NSLog(@"Products: %@",_products);
            }
        }];
    }
    [[Sounds mixer] playTouch];
    settings = [[SettingsView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [settings setDataSource:settings];
    [settings setDelegate:self];
    [settings setBackgroundColor:[UIColor clearColor]];
    [settings setBackgroundView:nil];
    [settings setCenter:CGPointMake(settings.center.x, settings.center.y+settings.bounds.size.height)];
    [self.view addSubview:settings];

    [self performSelector:@selector(expandToCollapse:) withObject:@"settings"];
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground" afterDelay:0.1];
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator" afterDelay:0.2];
    [self animateSettingsTableIn];
}
-(void) startPurchase{
    activityIndicatorView = [[UIView alloc] initWithFrame:self.view.bounds];
    [activityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.66]];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:activityIndicatorView.center];
    [activityIndicator startAnimating];
    [activityIndicatorView addSubview:activityIndicator];
    [activityIndicatorView setUserInteractionEnabled:YES];
    [self.view addSubview:activityIndicatorView];
}
-(void) finishPurchase{
    NSLog(@"Callback to ViewController, finishing Purchase");
    [settings reloadData];
    if(activityIndicatorView != nil){
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
    }
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    
    if(animationID.length > 14)
        if([[animationID substringToIndex:15] isEqualToString:@"animationShrink"]){
            if([[animationID substringFromIndex:15] isEqualToString:@"generator"])
                [generatorButton setHidden:YES];
            else if ([[animationID substringFromIndex:15] isEqualToString:@"playground"])
                [playgroundButton setHidden:YES];
            else if ([[animationID substringFromIndex:15] isEqualToString:@"settings"])
                [settingsButton setHidden:YES];
        }
    if ([animationID isEqualToString:@"generator"] || [animationID isEqualToString:@"playground"] || [animationID isEqualToString:@"settings"])
    {
        [UIView beginAnimations:[NSString stringWithFormat:@"animationShrink%@",animationID] context:NULL];
        [UIView setAnimationDuration:0.12f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        if([animationID isEqualToString:@"generator"])
            generatorButton.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
        else if ([animationID isEqualToString:@"playground"])
            playgroundButton.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
        else if ([animationID isEqualToString:@"settings"])
            settingsButton.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        [UIView commitAnimations];
    }
}
-(void)expandToCollapse:(NSString*)objectDescription
{
    [UIView beginAnimations:objectDescription context:NULL];
    [UIView setAnimationDuration:0.08f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if([objectDescription isEqualToString:@"generator"])
        generatorButton.transform=CGAffineTransformMakeScale(1.15, 1.15);
	else if ([objectDescription isEqualToString:@"playground"])
        playgroundButton.transform=CGAffineTransformMakeScale(1.15, 1.15);
	else if ([objectDescription isEqualToString:@"settings"])
        settingsButton.transform=CGAffineTransformMakeScale(1.15, 1.15);
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[UIView commitAnimations];
}
-(void)animateCheckerboardShrinkAndReposition
{
    [UIView beginAnimations:@"checkerboard" context:nil];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.66];                                                //-111
//    flippingAutomata.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-self.view.frame.size.width*.5+self.view.frame.size.width*.15, -.5*self.view.frame.size.height+self.view.frame.size.height*0.075), 0.075f, 0.075f);
    flippingAutomata.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-self.view.frame.size.width*.5+self.view.frame.size.width*.166, -.5*self.view.frame.size.height+self.view.frame.size.height*0.075), 0.075f, 0.075f);
    generator.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.0f, 1.0f);
    [UIView commitAnimations];
}
-(void)animateCheckerboardExpandAndReposition
{
    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:.2];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.28];
    [self performSelector:@selector(buttonFlipDown:) withObject:settingsButton afterDelay:.36];
    [UIView beginAnimations:@"checkerboard" context:nil];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.66];                                                      //-205
    flippingAutomata.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0f, 1.0f), 0, 0);
    generator.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(13.333f, 13.333f),self.view.frame.size.width*.5-self.view.frame.size.width*.166, .5*self.view.frame.size.height-self.view.frame.size.height*0.075);
    [UIView commitAnimations];
}
-(void) animateSettingsTableIn
{
    [UIView beginAnimations:@"animateSettingsTableIn" context:nil];
    [UIView setAnimationDuration:.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [settings setCenter:self.view.center];
    [UIView commitAnimations];
}
-(void) animateSettingsTableOut
{
    generatorButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
    playgroundButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
    settingsButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
    [generatorButton setHidden:YES];
    [playgroundButton setHidden:YES];
    [settingsButton setHidden:YES];
    [self buttonFlipDown:generatorButton];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.1];
    [self performSelector:@selector(buttonFlipDown:) withObject:settingsButton afterDelay:.2];
    [UIView beginAnimations:@"animateSettingsTableIn" context:nil];
    [UIView setAnimationDuration:.33];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [settings setCenter:CGPointMake(self.view.center.x, self.view.center.y+self.view.bounds.size.height)];
    [UIView commitAnimations];
}
-(void)tapListener:(UITapGestureRecognizer*)sender
{
    if(CGRectContainsPoint(flippingAutomata.frame, [sender locationInView:[sender view]]))
    {
        [[Sounds mixer] playTouch];
        [self animateCheckerboardExpandAndReposition];
        generatorButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
        playgroundButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
        settingsButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
        [flippingAutomata setStopped:@0];
        [flippingAutomata performSelector:@selector(beginAnimations) withObject:nil afterDelay:1.0];
        [tapGesture setEnabled:NO];
    }
    if(CGRectContainsPoint([[generator randomAutomataView] frame], [sender locationInView:[sender view]])){
        [self performSelectorInBackground:@selector(fadeInLoadingView) withObject:nil];
        random = TRUE;
        [self performSegueWithIdentifier:@"FullScreenSegue" sender:self];
    }
    if(CGRectContainsPoint([[generator nonrandomAutomataView] frame], [sender locationInView:[sender view]])){
        [self performSelectorInBackground:@selector(fadeInLoadingView) withObject:nil];
        random = FALSE;
        [self performSegueWithIdentifier:@"FullScreenSegue" sender:self];
    }
}
-(void)fadeInLoadingView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.33];
    [loadingView setAlpha:0.66];
    [UIView commitAnimations];
}

#pragma mark - In App Purchases
//
//- (void)productPurchased:(NSNotification *)notification {
//    
//    NSString * productIdentifier = notification.object;
//    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
//        if ([product.productIdentifier isEqualToString:productIdentifier]) {
//            [settings reloadData];
//            //supposed to be this below
//            //
//            //BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
//            [[NSUserDefaults standardUserDefaults] setObject:@"purchased" forKey:@"IAP"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
////            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            *stop = YES;
//        }
//    }];
//    
//}

#pragma mark - Table view delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPAD())
        return 100;
    else
        return 50;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(IS_IPAD()){
        if(section==0)
            return 150;
        else return 20;
    }
    else{
        if(section == 0)
            return 60;
        else
            return 5;
    }
}
//-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"This is getting called");
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor greenColor]];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    [title setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2.0, 22)];
//    [title setTextAlignment:NSTextAlignmentCenter];
//    [title setText:@"SETTINGS"];
//    [title setBackgroundColor:[UIColor clearColor]];
//    [title setTextColor:[UIColor whiteColor]];
//    //    [view addSubview:title];
//    return view;
//}

-(void)showRetinaSpeedWarning
{
    alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*.66, self.view.bounds.size.width*.66)];
    [alertView setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    //[[alertView layer] setCornerRadius:self.view.bounds.size.width*.033];
    [[alertView layer] setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor]];
    [[alertView layer] setBorderWidth:self.view.bounds.size.width*.01];
    [[alertView layer] setCornerRadius:self.view.bounds.size.width*.033];
    [alertView setCenter:CGPointMake(self.view.center.x, -alertView.bounds.size.height)];
    UITextView *warning = [[UITextView alloc] initWithFrame:CGRectMake(alertView.bounds.size.width*.05, alertView.bounds.size.height*.05, alertView.bounds.size.width*.9, alertView.bounds.size.height*.9)];
    [warning setFont:[UIFont systemFontOfSize:self.view.bounds.size.width*.07]];
    [warning setText:@"Retina images look awesome, but they also take 4 times longer to generate"];
    [warning setBackgroundColor:[UIColor clearColor]];
    [warning setTextAlignment:NSTextAlignmentCenter];
    [alertView addSubview:warning];
    [warning setTextColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    UIButton *okayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*.33, self.view.bounds.size.width*.1)];
    [okayButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    [[okayButton layer] setBorderWidth:self.view.bounds.size.width*.01];
    [[okayButton layer] setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor]];
    [[okayButton layer] setCornerRadius:self.view.bounds.size.width*.05];
    [okayButton setTitle:@"okay" forState:UIControlStateNormal];
    [okayButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [[okayButton titleLabel] setFont:[UIFont boldSystemFontOfSize:self.view.bounds.size.width*.066]];
    [okayButton setCenter:CGPointMake(alertView.bounds.size.width*.5, alertView.bounds.size.height*.833)];
    [okayButton addTarget:self action:@selector(dismissRetinaSpeedWarning) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:okayButton];
    [self.view addSubview:alertView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.33];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [alertView setCenter:self.view.center];
    [UIView commitAnimations];
    
}
-(void)dismissRetinaSpeedWarning
{
    [[Sounds mixer] playTouch];
    NSLog(@"Dismissing");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [alertView setCenter:CGPointMake(alertView.center.x, self.view.bounds.size.height+alertView.bounds.size.height)];
    [UIView commitAnimations];
    [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        if([cell.detailTextLabel.text isEqualToString:@"no"]){
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)){
                //if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"retinaSpeedWarning"] boolValue]){
                    [self showRetinaSpeedWarning];
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"retinaSpeedWarning"];
                //}
                [cell.detailTextLabel setText:@"yes"];
                [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"retina"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else{
            [cell.detailTextLabel setText:@"no"];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"retina"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else if (indexPath.section == 1){
        if([cell.detailTextLabel.text isEqualToString:@"white"]){
            [cell.detailTextLabel setText:@"smooth"];
            [[NSUserDefaults standardUserDefaults] setObject:@"smooth" forKey:@"noise"];
        }
        else{
            [cell.detailTextLabel setText:@"white"];
            [[NSUserDefaults standardUserDefaults] setObject:@"white" forKey:@"noise"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (indexPath.section == 2){
        if([cell.detailTextLabel.text isEqualToString:@"off"]){
            [cell.detailTextLabel setText:@"on"];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"sound"];
        }
        else{
            [cell.detailTextLabel setText:@"off"];
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"sound"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (indexPath.section == 3){
        if([cell.detailTextLabel.text isEqualToString:@"b&w"])
            [[NSUserDefaults standardUserDefaults] setObject:@"clay" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"clay"])
            [[NSUserDefaults standardUserDefaults] setObject:@"moss" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"moss"])
            [[NSUserDefaults standardUserDefaults] setObject:@"water" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"water"])
            [[NSUserDefaults standardUserDefaults] setObject:@"brick" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"brick"])
            [[NSUserDefaults standardUserDefaults] setObject:@"zelda" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"zelda"])
            [[NSUserDefaults standardUserDefaults] setObject:@"ice" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"ice"])
            [[NSUserDefaults standardUserDefaults] setObject:@"arcade" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"arcade"])
            [[NSUserDefaults standardUserDefaults] setObject:@"stone" forKey:@"theme"];
        else if([cell.detailTextLabel.text isEqualToString:@"stone"])
            [[NSUserDefaults standardUserDefaults] setObject:@"b_w" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateColorsProgramWide];
        [tableView reloadData];
    }
    else if (indexPath.section == 4){
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] isEqualToString:@"b_w"] ||
           [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.robbykraft.cellular.colors"] boolValue])
            [self animateSettingsTableOut];
        else
        {
            if(_products == nil || ![_products count]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot locate color themes. Are you connected to the internet?" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles: nil];
                [alert show];
            }
            else{
                UIAlertView *purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Unlock all the colors!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase", @"Restore Transaction", nil];
                [purchaseAlert show];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[Sounds mixer] playTouch];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if(buttonIndex == 1){
        SKProduct * product = (SKProduct *) _products[0];
        NSLog(@"Trying to purchase(%@): %@",product.productIdentifier,product.localizedTitle);
        [[InAppPurchaseHelper sharedInstance] buyProduct:product];
    }
    else if (buttonIndex == 2){
        SKProduct * product = (SKProduct *) _products[0];
        NSLog(@"Trying to purchase(%@): %@",product.productIdentifier,product.localizedTitle);
        [[InAppPurchaseHelper sharedInstance] restoreCompletedTransactions];
    }
    else if (buttonIndex == 0){
        [[NSUserDefaults standardUserDefaults] setObject:@"b_w" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateColorsProgramWide];
        [settings reloadData];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
