//
//  Automata.h
//  Automatouch
//
//  Created by Robby on 12/31/12.
//  Copyright (c) 2012 Robby Kraft. All rights reserved.
//
//  
//
//

#import <UIKit/UIKit.h>

@interface Automata : NSObject

-(id) initwithRule:(int)ruleNumber
    randomInitials:(BOOL)randomStart
             width:(NSInteger)visibleWidth
            height:(NSInteger)height;
-(NSArray*) arrayFromData;
-(UIImage*) GIFImageFromDataWithLightColor:(UIColor*)light DarkColor:(UIColor*)dark Scale:(CGFloat)scale;
@end