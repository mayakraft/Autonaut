//
//  AppDelegate.h
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *interestingRandom;
@property (strong, nonatomic) NSArray *interestingSingle;

@property (strong, nonatomic) NSSet *inAppProductIdentifiers;
-(NSString *)purchaseColorsProductIdentifier;

@end
