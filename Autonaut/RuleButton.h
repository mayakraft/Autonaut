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
    UIView *oldBottom;
}
@property NSInteger ruleNumber;
@property (nonatomic) BOOL state;

-(void) setState:(BOOL)s animated:(BOOL)animated;
-(void) updateStateAnimated:(NSNumber*)animated;

@end
