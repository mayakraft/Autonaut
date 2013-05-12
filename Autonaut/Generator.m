//
//  Generator.m
//  Autonaut
//
//  Created by Robby on 5/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "Generator.h"
#import "Automata.h"
#import <QuartzCore/QuartzCore.h>

@implementation Generator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        Automata *randomAutomata = [[Automata alloc] initwithRule:60 randomInitials:YES width:320 height:320];
        UIImageView *randomAutomataView = [[UIImageView alloc] initWithImage:[randomAutomata GIFImageFromDataWithScale:2.0] ];
        [randomAutomataView setFrame:CGRectMake(frame.size.width*.33, frame.size.height*.05, frame.size.width*.6, frame.size.width*.6)];
        randomAutomataView.layer.masksToBounds = NO;
        randomAutomataView.layer.cornerRadius = 8; // if you like rounded corners
        randomAutomataView.layer.shadowOffset = CGSizeMake(5, 7);
        randomAutomataView.layer.shadowRadius = 5;
        randomAutomataView.layer.shadowOpacity = 0.5;
//        [randomAutomataView setFrame:CGRectMake(900, 1500, 160, 160)];
        [self addSubview:randomAutomataView];

        Automata *nonrandomAutomata = [[Automata alloc] initwithRule:60 randomInitials:NO width:320 height:320];
        UIImageView *nonrandomAutomataView = [[UIImageView alloc] initWithImage:[nonrandomAutomata GIFImageFromDataWithScale:2.0] ];
        [nonrandomAutomataView setFrame:CGRectMake(frame.size.width*.33, frame.size.height*.95-frame.size.width*.6, frame.size.width*.6, frame.size.width*.6)];
        nonrandomAutomataView.layer.masksToBounds = NO;
        nonrandomAutomataView.layer.cornerRadius = 8; // if you like rounded corners
        nonrandomAutomataView.layer.shadowOffset = CGSizeMake(5, 7);
        nonrandomAutomataView.layer.shadowRadius = 5;
        nonrandomAutomataView.layer.shadowOpacity = 0.5;
        [self addSubview:nonrandomAutomataView];
    }
    return self;
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
