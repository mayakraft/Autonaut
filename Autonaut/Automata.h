//
//  Automata.h
//  Automatouch
//
//  Created by Robby on 12/31/12.
//  Copyright (c) 2012 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Automata : UIImage

@property (retain) UIImage *image;
@property bool* cells;

-(Automata*) initwithRule:(int)ruleNumber width:(int)width height:(int)height singlePoint:(BOOL)singlePoint;
-(UIImage*) getImage;

@end