//
//  ScrollViewController.h
//  Autonaut
//
//  Created by Robby on 6/2/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Automata.h"

@interface ScrollViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) Automata *automata;
@property (nonatomic, strong) NSNumber *rule;
@property (nonatomic, strong) NSNumber *random;
@end
