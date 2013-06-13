//
//  Cell.m
//  Autonaut
//
//  Created by Robby on 6/3/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "Colors.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.layer.borderWidth = 4.0f;
        self.layer.cornerRadius = 25.0f;
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0f]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0f]];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.layer setBackgroundColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"] CGColor]];
        [self setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
        [self setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
        if(IS_IPAD())
        {
            self.layer.borderWidth = 8.0f;
            self.layer.cornerRadius = 50.0f;
            [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
            [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        }
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void) layoutSubviews{
    [super layoutSubviews];
    NSInteger padding = 40;
    if(IS_IPAD()) padding = 100;
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.bounds.size.width-padding, self.textLabel.frame.size.height);
    [self.layer setBackgroundColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"] CGColor]];
    [[self textLabel] setTextColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    [[self textLabel] setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    self.layer.borderColor = [[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"] CGColor];
}

- (void)setFrame:(CGRect)frame {
    if(IS_IPAD()){
        frame.origin.x += 100;
        frame.size.width -= 2 * 100;
    }
    else{
        frame.origin.x += 40;
        frame.size.width -= 2 * 40;
    }
    [super setFrame:frame];

    self.layer.borderWidth = 4.0f;
    self.layer.cornerRadius = 25.0f;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setBackgroundColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"]];
    [self.layer setBackgroundColor:[[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"on"] CGColor]];
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0f]];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0f]];
    if(IS_IPAD())
    {
        self.layer.borderWidth = 8.0f;
        self.layer.cornerRadius = 50.0f;
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
    }
    [self.detailTextLabel setTextColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setHighlightedTextColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    [self.detailTextLabel setHighlightedTextColor:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"off"]];
    UIView *clear= [[UIView alloc] initWithFrame:CGRectZero];
    [clear setBackgroundColor:[UIColor clearColor]];
    self.selectedBackgroundView = clear;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
