//
//  IMDAdNetworkStatus.h
//  ImproveDigital
//
//  Created by Nagib Bin Azad on 17/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMDInitializationState) {
    IMDInitializationStateNotReady = 0,
    IMDInitializationStateReady = 1
};

@interface IMDAdNetworkStatus : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) IMDInitializationState state;
@property (nonatomic, strong, readonly) NSString *networkDescription;

+ (instancetype)initializeWithName:(NSString *)name state:(IMDInitializationState)state description:(NSString *)description;

@end

NS_ASSUME_NONNULL_END
