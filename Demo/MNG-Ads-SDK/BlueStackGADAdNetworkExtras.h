//
//  BlueStackGADAdNetworkExtras.h
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 18/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>


@interface BlueStackGADAdNetworkExtras :  NSObject <GADAdNetworkExtras>

@property(nonatomic) NSString  * keywords;
@property(nonatomic) NSDictionary<NSString *, NSString *> *customTargetingBlueStack;

@end

