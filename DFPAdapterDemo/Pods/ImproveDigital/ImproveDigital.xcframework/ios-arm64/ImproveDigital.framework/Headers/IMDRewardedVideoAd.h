//
//  IMDRewardedVideoAd.h
//  ImproveDigital
//

#import <Foundation/Foundation.h>
#import <ImproveDigital/IMDRewardEarnedDelegate.h>
#import <ImproveDigital/IMDFullScreenPresentableAd.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^IMDRewardedVideoAdLoadCompletionHandler)(IMDRewardedVideoAd *_Nullable, IMDError *_Nullable);

@interface IMDRewardedVideoAd : NSObject <IMDFullScreenPresentableAd>

@property (strong, nonatomic, readonly, nonnull) NSString *placementId;

@property (nonatomic, weak, nullable) id<IMDRewardEarnedDelegate> rewardEarnedDelegate;

+ (void)loadAdWithPlacementId:(nonnull NSString *)placementId completionHandler:(nonnull IMDRewardedVideoAdLoadCompletionHandler)completionHandler;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
