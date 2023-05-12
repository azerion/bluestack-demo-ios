//
//  MNGAdsConfig.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 3/5/15.
//  Copyright (c) 2015 Mng All rights reserved.
//

#ifndef MNG_Ads_SDK_Demo_MNGAdsConfig_h
#define MNG_Ads_SDK_Demo_MNGAdsConfig_h

#define MNG_ADS_APP_ID [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedappId"]
#define MNG_ADS_BANNER_PLACEMENT_ID [NSString stringWithFormat:@"/%@/banner",MNG_ADS_APP_ID]
#define MNG_ADS_HIMONO_PLACEMENT_ID [NSString stringWithFormat:@"/%@/banneraf",MNG_ADS_APP_ID]
#define MNG_MAS_BANNER_PLACEMENT_ID [NSString stringWithFormat:@"/%@/bannermng",MNG_ADS_APP_ID]
#define MNG_ADS_SQUARE_BANNER_PLACEMENT_ID [NSString stringWithFormat:@"/%@/square",MNG_ADS_APP_ID]
#define MNG_ADS_SASHIMI_PLACEMENT_ID [NSString stringWithFormat:@"/%@/squareaf",MNG_ADS_APP_ID]
#define MNG_MAS_SQUARE_BANNER_PLACEMENT_ID [NSString stringWithFormat:@"/%@/squaremng",MNG_ADS_APP_ID]
#define MNG_ADS_SQUARE_DYNAMIC_PLACEMENT_ID [NSString stringWithFormat:@"/%@/dynamicAd",MNG_ADS_APP_ID]
#define MNG_ADS_INTERSTITIAL_PLACEMENT_ID [NSString stringWithFormat:@"/%@/interstitial",MNG_ADS_APP_ID]
#define MNG_ADS_INTERAF_PLACEMENT_ID [NSString stringWithFormat:@"/%@/interaf",MNG_ADS_APP_ID]
#define MNG_ADS_INTERMAS_PLACEMENT_ID [NSString stringWithFormat:@"/%@/intermng",MNG_ADS_APP_ID]
#define MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID [NSString stringWithFormat:@"/%@/interstitialOverlay",MNG_ADS_APP_ID]
#define MNG_ADS_NATIVE_AD_PLACEMENT_ID [NSString stringWithFormat:@"/%@/nativead",MNG_ADS_APP_ID]
#define MNG_ADS_WITHOUT_NATIVE_AD_PLACEMENT_ID [NSString stringWithFormat:@"/%@/nativead_without_cover",MNG_ADS_APP_ID]

#define MNG_ADS_NATIVE_AF_PLACEMENT_ID [NSString stringWithFormat:@"/%@/nativeadaf",MNG_ADS_APP_ID]
#define MNG_ADS_NATIVE_MAS_PLACEMENT_ID [NSString stringWithFormat:@"/%@/nativeadmng",MNG_ADS_APP_ID]
#define MNG_ADS_REWARD_VIDEO_PLACEMENT_ID [NSString stringWithFormat:@"/%@/rewardvideo",MNG_ADS_APP_ID]
#define MNG_ADS_INFEED_PLACEMENT_ID [NSString stringWithFormat:@"/%@/infeed",MNG_ADS_APP_ID]
#define DEBUG_MODE_ENABLED [[[NSUserDefaults standardUserDefaults]objectForKey:@"SavedDebug"]boolValue]
#define BLUESTACK_THUMBNAIL_PLACEMENT_ID [NSString stringWithFormat:@"/%@/thumbnailMngperf",MNG_ADS_APP_ID]
#define BLUESTACK_THUMBNAIL_OGURY_PLACEMENT_ID [NSString stringWithFormat:@"/%@/thumbnailOgury",MNG_ADS_APP_ID]

#define SET_LAST_CLICK_DATE [((AppDelegate*)[[UIApplication sharedApplication]delegate])setLastClickDate:[NSDate date]];

#define MNG_ADS_ConsentFlag [[NSUserDefaults standardUserDefaults]objectForKey:@"ConsetFlagBlueSTack"]
#define CMP_LANGUAGE [[NSUserDefaults standardUserDefaults]objectForKey:@"CMP_LANGUAGE"]

#endif
