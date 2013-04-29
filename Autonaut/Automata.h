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

@interface Automata : UIImage

-(UIImage*) initwithRule:(int)ruleNumber
           randomInitials:(BOOL)randomStart
                    width:(NSInteger)visibleWidth
                   height:(NSInteger)height
              retinaScale:(CGFloat)scale;

@end