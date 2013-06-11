//
//  SelectionView.m
//  Autonaut
//
//  Created by Robby on 6/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SelectionView.h"
#import "Automata.h"

#define SQUARES 64
#define YOFFSET 100

@implementation SelectionView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"SelectionThingHappened");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSMutableArray *mViews = [[NSMutableArray alloc] init];
        NSMutableArray *mViewsRandom = [[NSMutableArray alloc] init];
        UIView *dark = [[UIView alloc] initWithFrame:CGRectMake(0, -frame.size.height*.5, frame.size.width, frame.size.height*3.85)];
        [dark setBackgroundColor:[UIColor blackColor]];
        [dark setUserInteractionEnabled:YES];
        [self addSubview:dark];
        
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/18.0, YOFFSET, frame.size.width*8/9.0, frame.size.width/9.0*3/2.0)];
        [count setFont:[UIFont fontWithName:@"Helvetica" size:frame.size.width/9.0*3/2.0]];
        [count setTextColor:[UIColor whiteColor]];
        [count setText:@"120/256"];
        [count setTextAlignment:NSTextAlignmentRight];
        [count setBackgroundColor:[UIColor clearColor]];
        [self addSubview:count];
        
        for(int i = 0; i < 256; i++)
        {
            for(int j = 0; j < 2; j++){
                Automata *automata;
                if(j == 0)
                    automata = [[Automata alloc] initwithRule:i randomInitials:NO width:SQUARES height:SQUARES];
                else
                    automata = [[Automata alloc] initwithRule:i randomInitials:YES width:SQUARES height:SQUARES];
                UIButton *rule = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SQUARES+8, SQUARES+8)];
                [rule setImage:[automata ImageWithColorLight:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] Dark:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] Scale:1.0] forState:UIControlStateNormal];
                [rule setCenter:CGPointMake((1+i%8)*frame.size.width/9.0, YOFFSET+((int)((i)/8.0)+2)*frame.size.width/9.0)];
                [rule.layer setBorderColor:[UIColor whiteColor].CGColor];
                [rule.layer setBorderWidth:4.0];
                [rule.layer setCornerRadius:8.0];
                if(j==0){
                    [mViews addObject:rule];
                    [self addSubview:rule];
                }
                else
                    [mViewsRandom addObject:rule];
                
            }
        }
    }
    [self setContentSize:CGSizeMake(frame.size.width, YOFFSET+frame.size.height*2.85)];
    [self setScrollEnabled:YES];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
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
