//
//  Sounds.m
//  Autonaut
//
//  Created by Robby on 6/13/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "Sounds.h"

@implementation Sounds

static Sounds *_mixer;

+(Sounds*)mixer
{
    if(_mixer == nil)
        _mixer = [[super allocWithZone:NULL] init];
    return _mixer;
}
-(void) initialize
{
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/click.wav", [[NSBundle mainBundle] resourcePath]]], &click);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/touch.wav", [[NSBundle mainBundle] resourcePath]]], &touch);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bells.mp3", [[NSBundle mainBundle] resourcePath]]], &bell);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/shutter.mp3", [[NSBundle mainBundle] resourcePath]]], &shutter);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/pop.mp3", [[NSBundle mainBundle] resourcePath]]], &pop);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sweep.mp3", [[NSBundle mainBundle] resourcePath]]], &sweep);
}
-(void) playTouch{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (touch);
}
-(void) playBells{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (bell);
}
-(void) playClick{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (click);
}
-(void) playShutter{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (shutter);
}
-(void) playPop{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (pop);
}
-(void) playSweep{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue])
        AudioServicesPlaySystemSound (sweep);
}

@end
