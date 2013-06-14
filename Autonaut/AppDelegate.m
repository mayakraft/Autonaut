//
//  AppDelegate.m
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "AppDelegate.h"
#import "AutonautIAP.h"
#import "Automata.h"
#import "Sounds.h"

@implementation AppDelegate
@synthesize interestingRandom;
@synthesize interestingSingle;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"ApplicationDidFinishLaunchingWithOptions");
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
//    [AutonautIAP sharedInstance];
    
    NSDictionary *interesting = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Interesting" ofType:@"plist"]];
    interestingSingle = [interesting objectForKey:@"single"];
    interestingRandom = [interesting objectForKey:@"random"];
    
    [[Sounds mixer] initialize];
    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
//       ([UIScreen mainScreen].scale == 2.0)) 
//        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"retina"];
//     else
    bool flag = 0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"version"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@1.2 forKey:@"version"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"retina"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"retina"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"sound"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"b_w" forKey:@"theme"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"noise"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"white" forKey:@"noise"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"retinaSpeedWarning"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"retinaSpeedWarning"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"foundSingle"] == nil){
        NSMutableArray *rules = [NSMutableArray array];
        for(int i = 0; i < 256; i++){
            if([interestingSingle containsObject:[NSNumber numberWithInteger:i]])
                [rules addObject:@0];
            else
                [rules addObject:@2];
        }
        // program begins at rule 30
        [rules setObject:@1 atIndexedSubscript:30];
        [[NSUserDefaults standardUserDefaults] setObject:rules forKey:@"foundSingle"];
        flag = 1;
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"foundRandom"] == nil){
        NSMutableArray *rulesRandom = [NSMutableArray array];
        for(int i = 0; i < 256; i++){
            if([interestingRandom containsObject:[NSNumber numberWithInteger:i]])
                [rulesRandom addObject:@0];
            else
                [rulesRandom addObject:@2];
        }
        // program begins at rule 30
        [rulesRandom setObject:@1 atIndexedSubscript:30];
        [[NSUserDefaults standardUserDefaults] setObject:rulesRandom forKey:@"foundRandom"];
        flag = 1;
    }
    if(flag)
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    // nsuserdefaults key "rule" is the current rule number

    [self buildPictures];
    return YES;
}

-(void)buildPictures
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* random_18 = [documentsDirectory stringByAppendingPathComponent:@"random_18.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:random_18])
        return;
    
    NSString *imageName;
    NSString *imagePath;
    Automata *automata;
    int SQUARES = 64;
    float retina;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
        retina = 2.0;
    else
        retina = 1.0;
    
    while (SQUARES*8 > [[UIScreen mainScreen] bounds].size.width) SQUARES/=2.0;
    
    for(int i = 0; i < 256; i++)
    {
        for(int j = 0; j < 2; j++){
            BOOL found = false;
            if(j == 0){
                for(NSNumber *element in interestingRandom)
                    if(i == [element integerValue])
                        found = true;
            }
            else{
                for(NSNumber *element in interestingSingle)
                    if(i == [element integerValue])
                        found = true;
            }
            if(found){
                if(j == 0){
                    automata = [[Automata alloc] initwithRule:i randomInitials:YES width:SQUARES*retina height:SQUARES*retina];
                    imageName = [NSString stringWithFormat:@"random_%d.png",i];
                }
                else{
                    automata = [[Automata alloc] initwithRule:i randomInitials:NO width:SQUARES*retina height:SQUARES*retina];
                    imageName = [NSString stringWithFormat:@"single_%d.png",i];
                }
                imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                UIImage *image = [automata ImageWithColorLight:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] Dark:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] Scale:retina];
                NSData* imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:imagePath atomically:YES];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"ApplicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"ApplicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
