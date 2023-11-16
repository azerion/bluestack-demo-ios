//
//  IMDFullScreenPresentableAd.h
//  ImproveDigital
//
//  Created by Nagib Bin Azad on 10/24/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ImproveDigital/IMDFullScreenContentDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMDFullScreenPresentableAd <NSObject>

@property (nonatomic, weak, nullable) id<IMDFullScreenContentDelegate> fullScreenContentDelegate;

- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
