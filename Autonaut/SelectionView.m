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

#define YOFFSET 100

@implementation SelectionView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"SelectionThingHappened");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int SQUARES = 64;
        float retina = 2.0;
        
        while (SQUARES*8 > frame.size.width) SQUARES/=2.0;
        NSLog(@"Squares: %d",SQUARES);
        interestingSingle = @[@18, @22, @26, @30, @45, @60, @73, @75, @82, @86, @89, @90, @101, @102, @105, @110, @124, @126, @129, @135, @137, @146, @149, @150, @153, @154, @161, @165, @167, @169, @181, @182, @193, @195, @210, @218, @225];

        interestingRandom = @[@9, @18, @22, @26, @30, @41, @45, @54, @60, @62, @73, @75, @82, @86, @89, @90, @97, @100, @101, @105, @106, @107, @109, @110, @118, @120, @121, @122, @124, @126, @129, @131, @135, @137, @145, @146, @147, @149, @150, @151, @153, @154, @161, @165, @166, @167, @169, @180, @181, @182, @183, @193, @195, @210, @225];
        
        NSMutableArray *mViewsSingle = [[NSMutableArray alloc] init];
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
                    automata = [[Automata alloc] initwithRule:i randomInitials:NO width:SQUARES*retina height:SQUARES*retina];
                else
                    automata = [[Automata alloc] initwithRule:i randomInitials:YES width:SQUARES*retina height:SQUARES*retina];
                UIButton *rule = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SQUARES+SQUARES/8.0, SQUARES+SQUARES/8.0)];
                [rule setImage:[automata ImageWithColorLight:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] Dark:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] Scale:retina] forState:UIControlStateNormal];
                [rule setCenter:CGPointMake((1+i%8)*frame.size.width/9.0, YOFFSET+((int)((i)/8.0)+2)*frame.size.width/9.0)];
                [rule.layer setBorderColor:[UIColor whiteColor].CGColor];
                [rule.layer setBorderWidth:SQUARES/16.0];
                [rule.layer setCornerRadius:SQUARES/8.0];
                if(j==0){
                    [mViewsSingle addObject:rule];
                }
                else{
                    [self addSubview:rule];
                    [mViewsRandom addObject:rule];
                }
            }
        }
        viewsRandom = [[NSArray alloc] initWithArray:mViewsRandom];
        viewsSingle = [[NSArray alloc] initWithArray:mViewsSingle];
        [self setContentSize:CGSizeMake(frame.size.width, YOFFSET+frame.size.height*2.85)];
        [self setScrollEnabled:YES];
    }
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
