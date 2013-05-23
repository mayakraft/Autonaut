//
//  Generator.h
//  Autonaut
//
//  Created by Robby on 5/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Generator : UIView{
    NSArray *buttons;
    UIImageView *randomAutomataView;
    UIImageView *nonrandomAutomataView;
    NSInteger retina;
}
@property (nonatomic, strong) NSNumber *rule;
-(void) setNewRule;
@end
