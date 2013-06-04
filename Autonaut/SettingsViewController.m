//
//  SettingsViewController.m
//  Autonaut
//
//  Created by Robby on 5/23/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "SettingsViewController.h"
#import "Cell.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@""];
    UIView *background = [[UIView alloc] init];
    [background setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundView:background];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

//-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor blackColor]];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    [title setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2.0, 22)];
//    [title setTextAlignment:NSTextAlignmentCenter];
//    [title setText:@"SETTINGS"];
//    [title setBackgroundColor:[UIColor clearColor]];
//    [title setTextColor:[UIColor whiteColor]];
//    [view addSubview:title];
//    return view;
//}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPAD())
        return 100;
    else
        return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    Cell *cell = [[Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    if(indexPath.section == 0){
        [[cell textLabel] setText:@"retina"];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] integerValue] == 1)
            [[cell detailTextLabel] setText:@"no"];
        else
            [[cell detailTextLabel] setText:@"yes"];
    }
    else if (indexPath.section == 1){
        [[cell textLabel] setText:@"width"];
        [[cell detailTextLabel] setText:@"×3"];
    }
    else if (indexPath.section == 2){
           [[cell textLabel] setText:@"height"];
            [[cell detailTextLabel] setText:@"×1"];
    }
    else if (indexPath.section == 3){
            [[cell textLabel] setText:@"noise"];
            [[cell detailTextLabel] setText:@"white"];
    }
    else if (indexPath.section == 4){
            [[cell textLabel] setText:@"reset defaults"];
            [[cell detailTextLabel] setText:@""];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        if([cell.detailTextLabel.text isEqualToString:@"no"]){
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                    ([UIScreen mainScreen].scale == 2.0)){
                [cell.detailTextLabel setText:@"yes"];
                [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"retina"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else{
            [cell.detailTextLabel setText:@"no"];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"retina"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else if (indexPath.section == 3){
        if([cell.detailTextLabel.text isEqualToString:@"white"])
            [cell.detailTextLabel setText:@"perlan"];
        else
            [cell.detailTextLabel setText:@"white"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
