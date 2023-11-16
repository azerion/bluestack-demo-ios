//
//  SCSRemoteConfigManager.h
//  SCSCoreKit
//
//  Created by Thomas Geley on 27/09/2017.
//  Copyright © 2017 Smart AdServer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SCSCoreKit/SCSRemoteConfigManagerProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCSRemoteConfigManagerDelegate;
@protocol SCSPropertyCacheManager;
@class SCSRemoteConfig;

@interface SCSRemoteConfigManager : NSObject <SCSRemoteConfigManagerProtocol>

/**
 Public initializer.
 
 @param delegate The delegate to be informed about requests results.
 @param baseURL The remote config URL's base URL.
 @param path The remote config URL's path.
 @param queryStringParameters A dictionary of query string parameters that must be used to call the remote config URL.
 
 @return An initialized instance of SCSRemoteConfigManager
 */
- (instancetype)initWithDelegate:(nullable id <SCSRemoteConfigManagerDelegate>)delegate baseURL:(NSString *)baseURL path:(NSString *)path queryStringParameters:(nullable NSDictionary *)queryStringParameters __deprecated;

/**
 Public initializer.
 
 @note If the `path` parameter contains the `[SITEID_PLACEHOLDER]` macro, it will be automaticall replaced before each
 fetch call by the requested site id. If no such macro exists, the path will be used as-is.
 
 @param delegate The delegate to be informed about requests results.
 @param cacheManager The cacheManager instance to use. If nil, a default implementation of SCSCacheManager will be used.
 @param baseURL The remote config URL's base URL.
 @param path The remote config URL's path.
 @param queryStringParameters A dictionary of query string parameters that must be used to call the remote config URL.
 @param sdkVersionId The current SDKVersionId, used for cache purpose.
 
 @return An initialized instance of SCSRemoteConfigManager
 */
- (instancetype)initWithDelegate:(nullable id <SCSRemoteConfigManagerDelegate>)delegate
                    cacheManager:(nullable id<SCSPropertyCacheManager>)cacheManager
                         baseURL:(NSString *)baseURL
                            path:(NSString *)path
           queryStringParameters:(nullable NSDictionary *)queryStringParameters
                    sdkVersionId:(int)sdkVersionId __deprecated;

/**
 Public initializer.
 
 @note If the `path` parameter contains the `[SITEID_PLACEHOLDER]` macro, it will be automaticall replaced before each
 fetch call by the requested site id. If no such macro exists, the path will be used as-is.
 
 @param delegate The delegate to be informed about requests results.
 @param cacheManager The cacheManager instance to use. If nil, a default implementation of SCSCacheManager will be used.
 @param baseURL The remote config URL's base URL.
 @param path The remote config URL's path.
 @param queryStringParameters A dictionary of query string parameters that must be used to call the remote config URL.
 @param sdkVersionId The current SDKVersionId, used for cache purpose.
 @param defaultRemoteConfig The default config that will be returned if the cache is empty for the current site id if any, nil otherwise.
 
 @return An initialized instance of SCSRemoteConfigManager
 */
- (instancetype)initWithDelegate:(nullable id <SCSRemoteConfigManagerDelegate>)delegate
                    cacheManager:(nullable id<SCSPropertyCacheManager>)cacheManager
                         baseURL:(NSString *)baseURL
                            path:(NSString *)path
           queryStringParameters:(nullable NSDictionary *)queryStringParameters
                    sdkVersionId:(int)sdkVersionId
             defaultRemoteConfig:(nullable SCSRemoteConfig *)defaultRemoteConfig;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END