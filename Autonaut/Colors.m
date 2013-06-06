//
//  Colors.m
//  Autonaut
//
//  Created by Robby on 6/6/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "Colors.h"

@implementation Colors

@synthesize themes;

static Colors *_sharedColors;

+(Colors*) sharedColors
{
    if(_sharedColors == nil)
        _sharedColors = [[super allocWithZone:NULL] init];
    return _sharedColors;
}
@end
