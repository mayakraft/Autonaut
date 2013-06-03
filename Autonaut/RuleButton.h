//
//  RuleButton.h
//  Autonaut
//
//  Created by Robby on 5/12/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleButton : UIButton
{
    UIView *left;
    UIView *center;
    UIView *right;
    UIView *bottom;
    UIImageView *blackfuzz;
    UIImageView *whitefuzz;
}
@property NSInteger ruleNumber;
@property (nonatomic) BOOL state;

-(void) setState:(BOOL)s animated:(BOOL)animated;

@end
