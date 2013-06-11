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
#import "SelectionView.h"

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

        sweep = [[AVAudioPlayer alloc] initWithContentsOfURL:
                      [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sweep.mp3", [[NSBundle mainBundle] resourcePath]]] error:nil];

        retina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue];
        retina = 1;

        randomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, (self.frame.size.height-self.frame.size.width*1.2)*.33, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:randomAutomataView];
        
        nonrandomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, self.frame.size.height-(self.frame.size.height-self.frame.size.width*1.2)*.33-self.frame.size.width*.6, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:nonrandomAutomataView];
        
        NSInteger ruleButtonHeight = frame.size.height/12;
        NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
        for(int i = 0; i < 8; i++){
            RuleButton *button = [[RuleButton alloc] initWithFrame:CGRectMake(self.frame.size.width*.15-ruleButtonHeight*3/4.0, ruleButtonHeight*1.82+i*(ruleButtonHeight*1.2), ruleButtonHeight*3/2.0, ruleButtonHeight)];
            [button setRuleNumber:7-i];
            [button setState:0];
            [button addTarget:self action:@selector(ruleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonsMutable addObject:button];
        }
        buttons = buttonsMutable;
        
        UIButton *selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [selectionButton setCenter:CGPointMake([[buttons objectAtIndex:7] center].x, [[buttons objectAtIndex:7] center].y+80)];
        [selectionButton setTitleColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] forState:UIControlStateNormal];
        [selectionButton setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
        [selectionButton.layer setBorderColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor]];
        [selectionButton.layer setBorderWidth:4.0];
        [selectionButton.layer setCornerRadius:22.0];
        [selectionButton.layer setMasksToBounds:YES];
        [selectionButton setTitle:@"120" forState:UIControlStateNormal];
        [[selectionButton titleLabel] setFont:[UIFont boldSystemFontOfSize:28]];
        
        [selectionButton addTarget:delegate action:@selector(goSelection:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:selectionButton];
    }
    return self;
}

-(void) updateColors{
    for(RuleButton *button in buttons)
        [button updateStateAnimated:@0];
}
-(void)viewDidLoad{
    NSLog(@"ViewDidLoad");
}

-(void) updateImageViews
{
    NSLog(@"UpdatingImageViews");
    Automata *randomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:YES width:randomAutomataView.frame.size.width*retina height:randomAutomataView.frame.size.height*retina];
    randomAutomataView.layer.magnificationFilter = kCAFilterNearest;
    [randomAutomataView setImage:[randomAutomata ImageWithColorLight:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                                      Dark:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
                                                                          Scale:retina]];
//    [randomAutomataView setImage:[randomAutomata GIFImageFromDataWithScale:retina]];
    
    Automata *nonrandomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:NO width:nonrandomAutomataView.frame.size.width*retina height:nonrandomAutomataView.frame.size.height*retina];
    nonrandomAutomataView.layer.magnificationFilter = kCAFilterNearest;
    [nonrandomAutomataView setImage:[nonrandomAutomata ImageWithColorLight:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]
                                                                            Dark:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]
                                                                                Scale:retina]];
//    [nonrandomAutomataView setImage:[nonrandomAutomata GIFImageFromDataWithScale:retina]];

}

-(void) setRule:(NSNumber *)r{
    NSLog(@"Custom Set Rule Function");
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
    {
        [[buttons objectAtIndex:i] setState:binaryRule[i] animated:NO];
    }
}

-(void) setNewRule{
    NSInteger base10 = 0;
    for(int i = 0; i < 8; i++){
        if([(RuleButton*)[buttons objectAtIndex:i] state])
            base10+=pow(2.0, i);
    }
    rule = [NSNumber numberWithInteger:base10];
    NSLog(@"NewRULE: %@",rule);
    [[NSUserDefaults standardUserDefaults] setObject:rule forKey:@"rule"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelectorInBackground:@selector(updateImageViews) withObject:nil];
//    [self updateImageViews];
}

-(IBAction)ruleButtonPress:(RuleButton*)sender
{
    NSLog(@"RI:LE %@",rule);
    NSLog(@"Button Pressed: %d",[sender ruleNumber]);
    if([sender state]) [sender setState:FALSE animated:YES];
    else [sender setState:TRUE animated:YES];
    [self setNewRule];
//    if([sweep isPlaying])
//        [sweep pause];
//    [sweep setCurrentTime:0.0];
//    [sweep play];
}

@end
