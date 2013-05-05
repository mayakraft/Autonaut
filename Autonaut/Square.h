//
//  Square.h
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Square : UIView
@property (nonatomic) NSNumber* state;
-(void) randomState;
-(void) setState:(NSNumber*)stateToBe;
@end
