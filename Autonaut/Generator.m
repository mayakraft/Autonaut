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

@implementation Generator
@synthesize rule;

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
        
        rule = [NSNumber numberWithInteger:60];

        randomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, self.frame.size.height*.05, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:randomAutomataView];

        
        nonrandomAutomataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.33, self.frame.size.height*.95-self.frame.size.width*.6, self.frame.size.width*.6, self.frame.size.width*.6)];
        [self addSubview:nonrandomAutomataView];

//        [randomAutomataView setBackgroundColor:[UIColor orangeColor]];
//        [nonrandomAutomataView setBackgroundColor:[UIColor orangeColor]];
        
        NSInteger ruleButtonHeight = frame.size.height/11;
        NSMutableArray *buttonsMutable = [NSMutableArray array];
        for(int i = 0; i < 8; i++){
            RuleButton *button = [[RuleButton alloc] initWithFrame:CGRectMake(20, ruleButtonHeight+i*(ruleButtonHeight*1.2), ruleButtonHeight*3/2.0, ruleButtonHeight)];
            [button setRuleNumber:i];
            [button addTarget:self action:@selector(ruleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button setRule:rule];
            [button setState:0];
            [buttonsMutable addObject:button];
        }
        buttons = buttonsMutable;
    }
    return self;
}

-(void)viewDidLoad
{
    NSLog(@"ViewDidLoad");
}

-(void) updateImageViews
{
    Automata *randomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:YES width:randomAutomataView.frame.size.width*retina height:randomAutomataView.frame.size.height*retina];
    [randomAutomataView setImage:[randomAutomata GIFImageFromDataWithScale:retina]];
    
    Automata *nonrandomAutomata = [[Automata alloc] initwithRule:[rule integerValue] randomInitials:NO width:nonrandomAutomataView.frame.size.width*retina height:nonrandomAutomataView.frame.size.height*retina];
    [nonrandomAutomataView setImage:[nonrandomAutomata GIFImageFromDataWithScale:retina]];

}

-(void) setNewRule{
    NSInteger base10 = 0;
    for(int i = 0; i < 8; i++){
        if([(RuleButton*)[buttons objectAtIndex:i] state])
            base10+=pow(2.0, i);
    }
    rule = [NSNumber numberWithInteger:base10];
    NSLog(@"NewRULE: %@",rule);
    [self performSelectorInBackground:@selector(updateImageViews) withObject:nil];
//    [self updateImageViews];
}

-(IBAction)ruleButtonPress:(RuleButton*)sender
{
    NSLog(@"Button Pressed: %d",[sender ruleNumber]);
    if([sender state]) [sender setState:FALSE];
    else [sender setState:TRUE];
    [self setNewRule];
    if([sweep isPlaying])
        [sweep pause];
    [sweep setCurrentTime:0.0];
    [sweep play];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
