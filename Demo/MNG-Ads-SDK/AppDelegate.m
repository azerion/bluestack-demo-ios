//
//  AppDelegate.m
//  MNG-Ads-SDK
//
//  Created by Mng on 12/9/14.
//  Copyright (c) 2014 Mng. All rights reserved.
//

#import "AppDelegate.h"
#import "MABDrawerViewController.h"
#import "BannerViewController.h"
#import "MenuViewController.h"

#import "SplashViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AVFoundation/AVFoundation.h>

#import <AdSupport/ASIdentifierManager.h>


@import Firebase;
@interface AppDelegate ()
@end

@implementation AppDelegate {
    AVPlayerItem *playerItem;
    AVPlayer *player;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  
    
    if (!MNG_ADS_APP_ID) {
        [[NSUserDefaults standardUserDefaults]setObject:DEFAULT_MNG_ADS_APP_ID
                                                 forKey:@"SavedappId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
        
    if (!MNG_ADS_ConsentFlag) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:2]
                                                 forKey:@"ConsetFlagBlueSTack"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (!CMP_LANGUAGE) {
        [[NSUserDefaults standardUserDefaults]setObject:@"fr"
                                                 forKey:@"CMP_LANGUAGE"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    if (![APP_DELEGATE sharedLocationManager]) {
        APP_DELEGATE.sharedLocationManager = [[CLLocationManager alloc]init];
        if([[APP_DELEGATE sharedLocationManager]respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [APP_DELEGATE.sharedLocationManager requestWhenInUseAuthorization];
        }
        [APP_DELEGATE.sharedLocationManager startUpdatingLocation];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SplashViewController *splashVC = [[SplashViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:splashVC];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] applicationState];

    //Log the value
    [FIRApp configure];
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"%@", idfaString);
    APP_DELEGATE.firstCallSplash = YES;
    
//    NSString * iabSpecialFeaturesOptInsSubString = [@"11" substringFromIndex:0];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    self.firstCallSplash = NO;
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of t he changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(self.firstCallSplash ? @" ‼️MNGAdsSDKLog Yes" : @" ‼️MNGAdsSDKLog No");
    if (![self.window.rootViewController isKindOfClass:SplashViewController.class]){
        if (!self.firstCallSplash) {
            [[InterstitialManager sharedManager]showInterstitial];
            NSLog(@"‼️MNGAdsSDKLog firstCallSplash");
        }
        NSLog(@"‼️MNGAdsSDKLog applicationDidBecomeActive");

    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
   

}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
}


- (void)play {
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://cdn.nrjaudio.fm/audio1/fr/30001/mp3_128.mp3?origine=fluxradios"]];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    [player play];
}

- (void)stop {
    [player pause];
}



@end
