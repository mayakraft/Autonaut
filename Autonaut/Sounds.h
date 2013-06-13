//
//  Sounds.h
//  Autonaut
//
//  Created by Robby on 6/13/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sounds : NSObject{
    SystemSoundID click;
    SystemSoundID touch;
    SystemSoundID bell;
}

+(Sounds*) mixer;
-(void) initialize;

-(void) playTouch;
-(void) playBells;
-(void) playClick;

@end
