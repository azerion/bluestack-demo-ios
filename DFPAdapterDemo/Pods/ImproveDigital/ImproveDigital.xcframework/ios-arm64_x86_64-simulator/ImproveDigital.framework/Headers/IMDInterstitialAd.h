//
//  IMDInterstitialAd.h
//  ImproveDigital
//
//  Created by Nagib Bin Azad on 10/27/22.
//

#import <Foundation/Foundation.h>
#import <ImproveDigital/IMDInterstitialPlacement.h>
#import <ImproveDigital/IMDFullScreenPresentableAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMDInterstitialAd : NSObject <IMDFullScreenPresentableAd>

typedef void (^IMDInterstitialAdLoadCompletionHandler)(IMDInterstitialAd *_Nullable, IMDError *_Nullable);

@property (strong, nonatomic, readonly, nonnull) IMDInterstitialPlacement *placement;

+ (void)loadAdWithPlacement:(IMDInterstitialPlacement *)placement completionHandler:(nonnull IMDInterstitialAdLoadCompletionHandler)completionHandler;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
