//
//  SettingsView.m
//  Autonaut
//
//  Created by Robby on 6/4/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "SettingsView.h"
#import "Cell.h"
#import "Colors.h"
#import "AutonautIAP.h"
#import <StoreKit/StoreKit.h>

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad
{
    [self setBackgroundColor:[UIColor clearColor]];

    _products = nil;
    [[AutonautIAP sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            NSLog(@"Success! in settings view");
            _products = products;
        }
    }];

    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//-(void) viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] isEqualToString:@"b_w"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"IAP"] isEqualToString:@"purchased"])
        return 5;
    else
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Cell *cell = [[Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if(indexPath.section == 0){
        [[cell textLabel] setText:@"retina"];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue] == 1)
            [[cell detailTextLabel] setText:@"no"];
        else
            [[cell detailTextLabel] setText:@"yes"];
    }
    else if (indexPath.section == 1){
        [[cell textLabel] setText:@"noise"];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"noise"] isEqualToString:@"white"])
            [[cell detailTextLabel] setText:@"white"];
        else
            [[cell detailTextLabel] setText:@"smooth"];
    }
    else if (indexPath.section == 2){
        [[cell textLabel] setText:@"theme"];
        [[cell detailTextLabel] setText:[[[[Colors sharedColors] themes] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]] objectForKey:@"title"]];
    }
    else if (indexPath.section == 3){
        [[cell textLabel] setText:@"okay"];
        [[cell detailTextLabel] setText:@""];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    }
    else if (indexPath.section == 4){
        SKProduct * product = (SKProduct *) _products[0];
        [_priceFormatter setLocale:product.priceLocale];
        NSLog(@"%@",product);
        [[cell textLabel] setText:[_priceFormatter stringFromNumber:product.price]];
        [[cell detailTextLabel] setText:@""];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
