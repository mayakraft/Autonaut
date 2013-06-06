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
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "FlippingAutomataView.h"
#import "Generator.h"
#import "ScrollViewController.h"
#import "SettingsView.h"
#import "Colors.h"

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
    FlippingAutomataView *flippingAutomata;
    Generator *generator;
    UITapGestureRecognizer *tapGesture;
    BOOL random; // for segue transition
    SettingsView *settings;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSDictionary *b_w = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor blackColor], @"off",
                                                                     [UIColor whiteColor], @"on",
                                                                     [UIColor colorWithRed:203/255.0 green:195/255.0 blue:182/255.0 alpha:1.0], @"complement",
                                                                     @"b&w", @"title", nil];
    NSDictionary *rgb = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor blueColor], @"off",
                                                                     [UIColor redColor], @"on",
                                                                     [UIColor greenColor], @"complement",
                                                                     @"rgb", @"title", nil];

    [[Colors sharedColors] setThemes:[[NSDictionary alloc] initWithObjectsAndKeys:b_w, @"b_w", rgb, @"rgb", nil]];

    [self.view setBackgroundColor:[UIColor colorWithRed:203/255.0 green:195/255.0 blue:182/255.0 alpha:1.0]];
    flippingAutomata = [[FlippingAutomataView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.height-self.view.frame.size.width)/2, 0, self.view.frame.size.height, self.view.frame.size.height)];
    [self.view addSubview:flippingAutomata];
        
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
    [playgroundButton setTitle:@"settings" forState:UIControlStateNormal];
    [playgroundButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:33.0]];
    [playgroundButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    playgroundButton.layer.borderWidth = 4.0f;
    playgroundButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    playgroundButton.layer.cornerRadius = 25.0f;
    [playgroundButton setHidden: YES];
    [playgroundButton setTag:2];
    [self.view addSubview:playgroundButton];
        
    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:.66];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.75];   
    
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
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapListener:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setEnabled:NO];
    generator = nil;
}

-(void) updateColorsProgramWide
{
    [generatorButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [generatorButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    generatorButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    [playgroundButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [playgroundButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    playgroundButton.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
    
}

- (IBAction) unwindToViewController: (UIStoryboardSegue*) unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[ScrollViewController class]])
    {
        NSLog(@"Coming from ScrollView!");
    }
//    else if ([sourceViewController isKindOfClass:[GreenViewController class]])
//    {
//        NSLog(@"Coming from GREEN!");
//    }
    NSLog(@"Unwind to View Controller");
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

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
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator"];
    [self performSelector:@selector(animateCheckerboardShrinkAndReposition) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(expandToCollapse:) withObject:@"playground" afterDelay:0.20];
    [tapGesture performSelector:@selector(setEnabled:) withObject:@1 afterDelay:1.0];
    NSLog(@"%f : %f : %f : %f", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    if(generator == nil){
        generator = [[Generator alloc] initWithFrame:CGRectMake( self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"rule"]){
            NSLog(@"There is a RULE");
            [generator setRule:[[NSUserDefaults standardUserDefaults] objectForKey:@"rule"]];
        }
        else
            [generator setRule:@30];
            NSLog(@"no rule");
    }
    [flippingAutomata setStopped:@1];
    [generator setNewRule];
    flippingAutomata.autoresizesSubviews = YES;
    generator.autoresizesSubviews = YES;
    generator.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(13.333f, 13.333f),self.view.frame.size.width*.5-self.view.frame.size.width*.15, .5*self.view.frame.size.height-self.view.frame.size.height*0.075);

    [self.view addSubview:generator];
    [self.view sendSubviewToBack:generator];
}
-(IBAction)playgroundButtonPress:(id)sender{
    settings = [[SettingsView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [settings setDataSource:settings];
    [settings setDelegate:self];
    [settings setBackgroundView:nil];
    [settings setCenter:CGPointMake(settings.center.x, settings.center.y+settings.bounds.size.height)];
    [self.view addSubview:settings];

    [self performSelector:@selector(expandToCollapse:) withObject:@"playground"];
    [self performSelector:@selector(expandToCollapse:) withObject:@"generator" afterDelay:0.1];
    [self animateSettingsTableIn];
    //[self performSegueWithIdentifier:@"SettingsSegue" sender:self];
//    [self performSelector:@selector(expandToCollapse:) withObject:@"playground"];
//    [self performSelector:@selector(expandToCollapse:) withObject:@"generator" afterDelay:0.20];
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    
    if(animationID.length > 14)
        if([[animationID substringToIndex:15] isEqualToString:@"animationShrink"]){
            NSLog(@"Settings things hidden");
            if([[animationID substringFromIndex:15] isEqualToString:@"generator"])
                [generatorButton setHidden:YES];
            else if ([[animationID substringFromIndex:15] isEqualToString:@"playground"])
                [playgroundButton setHidden:YES];
        }
    if ([animationID isEqualToString:@"generator"] || [animationID isEqualToString:@"playground"])
    {
        [UIView beginAnimations:[NSString stringWithFormat:@"animationShrink%@",animationID] context:NULL];
        [UIView setAnimationDuration:0.12f];
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
    [UIView setAnimationDuration:0.08f];
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
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.66];                                                //-111
    flippingAutomata.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-self.view.frame.size.width*.5+self.view.frame.size.width*.15, -.5*self.view.frame.size.height+self.view.frame.size.height*0.075), 0.075f, 0.075f);
    generator.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.0f, 1.0f);
    [UIView commitAnimations];
}
-(void)animateCheckerboardExpandAndReposition
{
    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:.2];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.28];
    [UIView beginAnimations:@"checkerboard" context:nil];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.66];                                                      //-205
    flippingAutomata.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0f, 1.0f), 0, 0);
    generator.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(13.333f, 13.333f),self.view.frame.size.width*.5-self.view.frame.size.width*.15, .5*self.view.frame.size.height-self.view.frame.size.height*0.075);
    [UIView commitAnimations];
}
-(void)tapPressed:(UITapGestureRecognizer*)sender
{
    NSLog(@"Tapping");
    [self animateCheckerboardExpandAndReposition];
    generatorButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
    playgroundButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
    [flippingAutomata setStopped:@0];
    [flippingAutomata performSelector:@selector(beginAnimations) withObject:nil afterDelay:1.0];
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
    [generatorButton setHidden:YES];
    [playgroundButton setHidden:YES];
    [self buttonFlipDown:generatorButton];
    //    [self performSelector:@selector(buttonFlipDown:) withObject:generatorButton afterDelay:.2];
    [self performSelector:@selector(buttonFlipDown:) withObject:playgroundButton afterDelay:.2];
    [UIView beginAnimations:@"animateSettingsTableIn" context:nil];
    [UIView setAnimationDuration:.33];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [settings setCenter:CGPointMake(self.view.center.x, self.view.center.y+self.view.bounds.size.height)];
    [UIView commitAnimations];
}

-(void)tapListener:(UITapGestureRecognizer*)sender
{
    NSLog(@"Tap Listener: %f : %f",[sender locationInView:sender.view].x,
          [sender locationInView:sender.view].y);
    if(CGRectContainsPoint(flippingAutomata.frame, [sender locationInView:[sender view]]))
    {
        NSLog(@"Tapping");
        [self animateCheckerboardExpandAndReposition];
        generatorButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
        playgroundButton.transform=CGAffineTransformMakeScale(1.0, 1.0);
        [flippingAutomata setStopped:@0];
        [flippingAutomata performSelector:@selector(beginAnimations) withObject:nil afterDelay:1.0];
        [tapGesture setEnabled:NO];
    }
    if(CGRectContainsPoint([[generator randomAutomataView] frame], [sender locationInView:[sender view]])){
        NSLog(@"Generator");
        random = TRUE;
        [self performSegueWithIdentifier:@"FullScreenSegue" sender:self];
    }
    if(CGRectContainsPoint([[generator nonrandomAutomataView] frame], [sender locationInView:[sender view]])){
        NSLog(@"Generator");
        random = FALSE;
        [self performSegueWithIdentifier:@"FullScreenSegue" sender:self];
    }
    //    CGPoint anchor = CGPointMake(randomAutomataView.center.x/self.bounds.size.width,
    //                                 randomAutomataView.center.y/self.bounds.size.height);
    //    if(CGRectContainsPoint([randomAutomataView frame], [sender locationInView:[sender view]])){
    //        NSLog(@":: %f : %f",randomAutomataView.center.x, randomAutomataView.center.y*4);
    //    }
    //    if(CGRectContainsPoint([nonrandomAutomataView frame], [sender locationInView:[sender view]])){
    //        NSLog(@"Non Random Automata");
    //        NSLog(@":: %f : %f",randomAutomataView.center.x, -randomAutomataView.center.y);
    //    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        if([cell.detailTextLabel.text isEqualToString:@"no"]){
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)){
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
        if([cell.detailTextLabel.text isEqualToString:@"white"])
            [cell.detailTextLabel setText:@"perlan"];
        else
            [cell.detailTextLabel setText:@"white"];
    }
    else if (indexPath.section == 2){
        if([cell.detailTextLabel.text isEqualToString:@"b_w"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"rgb" forKey:@"theme"];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:@"b_w" forKey:@"theme"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateColorsProgramWide];
        [tableView reloadData];
    }
    else if (indexPath.section == 3)
    {
        [self animateSettingsTableOut];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
