//
//  Generator.h
//  Autonaut
//
//  Created by Robby on 5/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol GeneratorDelegate

@optional
-(void)goSelection:(id)sender;

@end

@interface Generator : UIView{
    NSArray *buttons;
    NSInteger retina;
    AVAudioPlayer *sweep;
    UIButton *selectionButton;
    AVAudioPlayer *bellSound;
}
@property (nonatomic, assign) id<GeneratorDelegate> delegate;
@property (nonatomic, strong) NSNumber *rule;
@property (nonatomic, strong) UIImageView *randomAutomataView;
@property (nonatomic, strong) UIImageView *nonrandomAutomataView;

-(void) setNewRule;
-(void) updateColors;
-(void) updateRuleButtonsAnimated:(NSNumber*)animated;
-(void) updateImageViews;
@end
