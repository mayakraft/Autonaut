//
//  ViewController.h
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Generator.h"

@interface ViewController : UIViewController <UITableViewDelegate, GeneratorDelegate, UIAlertViewDelegate>
- (IBAction) unwindToViewController: (UIStoryboardSegue*) segue;
-(void) startPurchase;
-(void) finishPurchase;
@end
