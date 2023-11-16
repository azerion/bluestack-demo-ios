//
//  AppDelegate.m
//  DFPAdapterDemo
//
//  Created by Nagib Bin Azad on 25/10/23.
//

#import "AppDelegate.h"
#import <BlueStackDFPMediationAdapter/BlueStackDFPMediationAdapter.h>
#import <BlueStackSDK/MNGAdsSDKFactory.h>

@import GoogleMobileAds;

@interface AppDelegate ()<MNGAdsSDKFactoryDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
        for (NSString *className in status.adapterStatusesByClassName.allKeys) {
            NSLog(@"Adapter: %@  |   Status: %@", className, status.adapterStatusesByClassName[className].description);
        }
    }];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"592345403c65df760b765678d0951151",@"EF48B4E6-93C3-446C-8684-7912C67EB3DB" ];
    [MNGAdsSDKFactory setDebugModeEnabled:YES];
    [MNGAdsSDKFactory setDelegate:self];
    [MNGAdsSDKFactory initWithAppId:@"3180317"];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

-(void)MNGAdsSDKFactoryDidFinishInitializing{
    NSLog(@"MNGAds sucess initialization");

}


-(void)MNGAdsSDKFactoryDidFinishAdaptersInitializing:(BlueStackInitializationStatus *)blueStackInitializationStatus{
    for (BlueStackAdapterStatus* blueStackAdapterStatus in blueStackInitializationStatus.adaptersStatus) {
        NSString* message = [NSString  stringWithFormat:@"adapter name %@ has this status %lu with description %@ ", blueStackAdapterStatus.provider , (unsigned long)blueStackAdapterStatus.state, blueStackAdapterStatus.descriptionStatus] ;
        NSLog(@"%@", message);
    }
}

-(void)MNGAdsSDKFactoryDidFailInitializationWithError:(NSError *)error {
    NSLog(@"MNGAds failed initialization");

}
@end
