//
//  Generator.m
//  Autonaut
//
//  Created by Robby on 5/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Generator.h"
#import "Automata.h"
#import "RuleButton.h"
#import "Colors.h"
#import "Sounds.h"

@implementation Generator
@synthesize rule;
@synthesize randomAutomataView;
@synthesize nonrandomAutomataView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSLog(@"InitWithFrame");

        retina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue];
        retina = 1;

        randomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, (self.frame.size.height-self.frame.size.width*1.2)*.33, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:randomAutomataView];
        
        nonrandomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, self.frame.size.height-(self.frame.size.height-self.frame.size.width*1.2)*.33-self.frame.size.width*.6, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:nonrandomAutomataView];
        
        NSInteger ruleButtonHeight = frame.size.height/13.0;
        NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
        for(int i = 0; i < 8; i++){
            RuleButton *button = [[RuleButton alloc] initWithFrame:CGRectMake(self.frame.size.width*.166-ruleButtonHeight*3/4.0, ruleButtonHeight*2.0+i*(ruleButtonHeight*1.2), ruleButtonHeight*3/2.0, ruleButtonHeight)];
            [button setRuleNumber:7-i];
            [button setState:0];
            [button addTarget:self action:@selector(ruleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonsMutable addObject:button];
        }
        buttons = buttonsMutable;
        
        selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ruleButtonHeight*3/2.0, ruleButtonHeight*.66)];
        [selectionButton setCenter:CGPointMake(self.frame.size.width*.166, ruleButtonHeight*2.5+8*(ruleButtonHeight*1.2))];
        [selectionButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
        [selectionButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
        [selectionButton.layer setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor]];
        [selectionButton.layer setBorderWidth:self.frame.size.width*.0066];
        [selectionButton.layer setCornerRadius:ruleButtonHeight*.33];
        [selectionButton setTitle:@"0" forState:UIControlStateNormal];
        [[selectionButton titleLabel] setFont:[UIFont boldSystemFontOfSize:ruleButtonHeight*.5]];
        [[selectionButton layer] setShadowOffset:CGSizeMake(0.0, 0.0)];
        [[selectionButton layer] setShadowColor:[UIColor blackColor].CGColor];
        //[[selectionButton layer] setShadowColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"] CGColor]];
        [[selectionButton layer] setShadowOpacity:1.0];
        [[selectionButton layer] setShadowRadius:0.0];
//        [[selectionButton layer] setShadowPath:<#(CGPathRef)#>]
        [[selectionButton layer] setMasksToBounds:YES];
        [self setNeedsUpdateFound];
        
        [selectionButton addTarget:delegate action:@selector(goSelection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectionButton];
    }
    return self;
}

-(void) updateColors{
    for(RuleButton *button in buttons)
        [button updateStateAnimated:@0];
    [selectionButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
    [selectionButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    [selectionButton.layer setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor]];
}

-(void) updateImageViews
{
    NSLog(@"UpdatingImageViews");
    int howRandom = 1;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"noise"] isEqualToString:@"smooth"])
        howRandom++;
    Automata *randomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:howRandom width:randomAutomataView.frame.size.width*retina height:randomAutomataView.frame.size.height*retina];
    randomAutomataView.layer.magnificationFilter = kCAFilterNearest;
    [randomAutomataView setImage:[randomAutomata ImageWithColorLight:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                                Dark:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
                                                               Scale:retina]];
    
    Automata *nonrandomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:NO width:nonrandomAutomataView.frame.size.width*retina height:nonrandomAutomataView.frame.size.height*retina];
    nonrandomAutomataView.layer.magnificationFilter = kCAFilterNearest;
    [nonrandomAutomataView setImage:[nonrandomAutomata ImageWithColorLight:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                                      Dark:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
                                                                     Scale:retina]];
}

-(void) setRule:(NSNumber *)r{
    NSLog(@"setRule %@",r);
    rule = r;
    bool binaryRule[8];
    //Convert Decimal to Binary
    int powerer, ruleNumberCopy = [rule integerValue];
    for(int i=7;i>=0;i--){
        binaryRule[i] = false;
        powerer = pow(2,i);
        if(ruleNumberCopy >= powerer){
            binaryRule[i] = true;
            ruleNumberCopy -= powerer;
        }
    }
    for(int i = 0; i < 8; i++)
        [[buttons objectAtIndex:i] setState:binaryRule[i] animated:NO];
}
-(void) setNeedsUpdateFound
{
    int foundCount = 0;
    for(NSNumber *i in [[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"])
        if([i integerValue] == 1)
            foundCount++;
    for(NSNumber *i in [[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"])
        if([i integerValue] == 1)
            foundCount++;
    [selectionButton setTitle:[NSString stringWithFormat:@"%d",foundCount] forState:UIControlStateNormal];
}
-(void)foundNewRuleReward
{
    [[Sounds mixer] playBells];
//    NSLog(@"Animating Flash");
//    CABasicAnimation *shadowFlash;
//    [shadowFlash setFromValue:[NSNumber numberWithFloat:self.bounds.size.width*.05]];
//    [shadowFlash setToValue:[NSNumber numberWithFloat:0.0]];
//    [shadowFlash setDuration:1.66f];
//    [shadowFlash setDelegate:self];
//    [[selectionButton layer] addAnimation:shadowFlash forKey:@"shadowRadius"];
//    UIView *flash = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selectionButton.bounds.size.width, selectionButton.bounds.size.height)];
}
-(void) setNewRule{
    NSInteger base10 = 0;
    for(int i = 0; i < 8; i++){
        if([(RuleButton*)[buttons objectAtIndex:i] state])
            base10+=pow(2.0, i);
    }
    rule = [NSNumber numberWithInteger:base10];
    NSLog(@"setNewRule: %@",rule);
    [[NSUserDefaults standardUserDefaults] setObject:rule forKey:@"rule"];
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"] objectAtIndex:[rule integerValue]] integerValue] == 0){
        NSMutableArray *randoms = [[[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"] mutableCopy];
        [randoms setObject:@1 atIndexedSubscript:[rule integerValue]];
        [[NSUserDefaults standardUserDefaults] setObject:randoms forKey:@"foundRandom"];
        [self setNeedsUpdateFound];
        [self foundNewRuleReward];
    }
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"] objectAtIndex:[rule integerValue]] integerValue] == 0){
        NSMutableArray *singles = [[[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"] mutableCopy];
        [singles setObject:@1 atIndexedSubscript:[rule integerValue]];
        [[NSUserDefaults standardUserDefaults] setObject:singles forKey:@"foundSingle"];
        [self setNeedsUpdateFound];
        [self foundNewRuleReward];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelectorInBackground:@selector(updateImageViews) withObject:nil];
}

-(void) updateRuleButtonsAnimated:(NSNumber*)animated
{
    NSInteger timer = .2;
    for(RuleButton *button in buttons){
        [button performSelector:@selector(updateStateAnimated:) withObject:animated afterDelay:timer*.075];
        timer++;
    }
}

-(IBAction)ruleButtonPress:(RuleButton*)sender
{
    NSLog(@"Rule Button Press (%@): %d",rule,[sender ruleNumber]);
    if([sender state]) [sender setState:FALSE animated:YES];
    else [sender setState:TRUE animated:YES];
    [self setNewRule];
}

@end
