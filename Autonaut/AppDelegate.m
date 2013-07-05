//
//  AppDelegate.m
//  Autonaut
//
//  Created by Robby on 4/21/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "AppDelegate.h"
#import "Automata.h"
#import "Sounds.h"
#import "Colors.h"
#import "InAppPurchaseHelper.h"

@implementation AppDelegate
@synthesize interestingRandom;
@synthesize interestingSingle;

- (NSSet *)inAppProductIdentifiers {
    return [NSSet setWithObjects:[self purchaseColorsProductIdentifier], nil];
}

- (NSString *)purchaseColorsProductIdentifier {
    return @"com.robbykraft.cellular.colors";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    NSDictionary *interesting = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Interesting" ofType:@"plist"]];
    interestingSingle = [interesting objectForKey:@"single"];
    interestingRandom = [interesting objectForKey:@"random"];
    
    [[Sounds mixer] initialize];
    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
//       ([UIScreen mainScreen].scale == 2.0)) 
//        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"retina"];
//     else
    bool flag = 0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"com.robbykraft.cellular.colors"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"com.robbykraft.cellular.colors"];
        flag = 1;
    }
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

    // prevent crashing program into gaining access to a theme:
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"com.robbykraft.cellular.colors"] boolValue]  &&
       ![[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] isEqualToString:@"b_w"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"b_w" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self loadColors];
    [self buildPictures];
    
    //IAP
    [InAppPurchaseHelper sharedInstance];

    NSLog(@"ApplicationDidFinishLaunchingWithOptions did finish");
    return YES;
}

-(void) loadColors
{
    NSDictionary *b_w = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], @"off",
                         [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], @"on",
                         [UIColor colorWithRed:186/255.0 green:179/255.0 blue:167/255.0 alpha:1.0], @"complement",
                         @"b&w", @"title", nil];
    NSDictionary *ice = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.27 green:0.29 blue:0.64 alpha:1.0], @"off",
                         [UIColor colorWithRed:0.85 green:0.88 blue:0.97 alpha:1.0], @"on",
                         [UIColor colorWithRed:0.16 green:0.79 blue:0.84 alpha:1.0], @"complement",
                         @"ice", @"title", nil];
    NSDictionary *stone = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.09 green:0.21 blue:0.46 alpha:1.0], @"off",
                           [UIColor colorWithRed:0.91 green:0.93 blue:0.81 alpha:1.0], @"on",
                           [UIColor colorWithRed:0.84 green:0.79 blue:0.06 alpha:1.0], @"complement",
                           @"stone", @"title", nil];
    NSDictionary *moss = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.15 green:0.45 blue:0.30 alpha:1.0], @"off",
                          [UIColor colorWithRed:0.84 green:0.77 blue:0.28 alpha:1.0], @"on",
                          [UIColor colorWithRed:0.70 green:0.54 blue:0.60 alpha:1.0], @"complement",
                          @"moss", @"title", nil];
    NSDictionary *zelda = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0], @"off",
                          [UIColor colorWithRed:1.00 green:0.78 blue:0.49 alpha:1.0], @"on",
                          [UIColor colorWithRed:0.84 green:0.18 blue:0.00 alpha:1.0], @"complement",
                          @"zelda", @"title", nil];
    NSDictionary *water = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.27 green:0.00 blue:1.0 alpha:1.0], @"off",
                          [UIColor colorWithRed:0.65 green:0.70 blue:0.80 alpha:1.0], @"on",
                          [UIColor colorWithRed:0.32 green:0.62 blue:1.0 alpha:1.0], @"complement",
                          @"water", @"title", nil];
    NSDictionary *brick = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.95 green:0.20 blue:0.00 alpha:1.0], @"off",
                           [UIColor colorWithRed:0.99 green:0.57 blue:0.16 alpha:1.0], @"on",
                           [UIColor colorWithRed:1.00 green:0.85 blue:0.15 alpha:1.0], @"complement",
                           @"brick", @"title", nil];
    NSDictionary *arcade = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.32 green:0.78 blue:0.94 alpha:1.0], @"off",
                           [UIColor colorWithRed:0.92 green:0.25 blue:0.08 alpha:1.0], @"on",
                           [UIColor colorWithRed:1.00 green:0.75 blue:0.29 alpha:1.0], @"complement",
                           @"arcade", @"title", nil];
    NSDictionary *clay = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.38 green:0.03 blue:0.00 alpha:1.0], @"off",
                          [UIColor colorWithRed:0.97 green:0.62 blue:0.39 alpha:1.0], @"on",
                          [UIColor colorWithRed:0.71 green:0.34 blue:0.18 alpha:1.0], @"complement",
                          @"clay", @"title", nil];
  
    [[Colors sharedColors] setThemes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                      b_w, @"b_w",
                                      clay, @"clay",
                                      ice, @"ice",
                                      moss, @"moss",
                                      stone, @"stone",
                                      water, @"water",
                                      brick, @"brick",
                                      arcade, @"arcade",
                                      zelda, @"zelda",nil]];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
