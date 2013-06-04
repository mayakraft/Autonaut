//
//  Cell.m
//  Autonaut
//
//  Created by Robby on 6/3/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"INIT WITH STYLE");
        self.layer.borderWidth = 8.0f;
        self.layer.cornerRadius = 50.0f;
//        [self.layer setMasksToBounds:YES];
//        [self.layer setOpaque:YES];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void) layoutSubviews{
    [super layoutSubviews];
    [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 100;
    frame.size.width -= 2 * 100;
    [super setFrame:frame];

    self.layer.borderWidth = 8.0f;
    self.layer.cornerRadius = 50.0f;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:66.0f]];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
