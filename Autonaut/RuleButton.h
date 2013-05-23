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
}
@property NSInteger ruleNumber;
@property (nonatomic) BOOL state;
@property (nonatomic, weak) NSNumber *rule;

@end
