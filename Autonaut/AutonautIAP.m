//
//  AutonautIAP.m
//  Autonaut
//
//  Created by Robby on 6/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "AutonautIAP.h"

@implementation AutonautIAP
+(AutonautIAP *) sharedInstance{
    static dispatch_once_t onceToken;
    static AutonautIAP *sharedInstance;
    dispatch_once(&onceToken, ^{
        NSSet *productIdentifiers = [NSSet setWithObject:@"com.robbykraft.cellular.colors"];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end
