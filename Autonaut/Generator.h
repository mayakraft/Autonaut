//
//  Generator.h
//  Autonaut
//
//  Created by Robby on 5/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Generator : UIView{
    NSArray *buttons;
    NSInteger retina;
    AVAudioPlayer *sweep;
}
@property (nonatomic, strong) NSNumber *rule;
@property (nonatomic, strong) UIImageView *randomAutomataView;
@property (nonatomic, strong) UIImageView *nonrandomAutomataView;

-(void) setNewRule;
@end
