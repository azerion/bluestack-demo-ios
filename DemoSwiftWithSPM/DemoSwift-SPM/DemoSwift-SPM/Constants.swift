//
//  Constants.swift
//  DemoSwift
//
//  Created by HtrimechMac on 07/06/2021.
//

import Foundation

//Constants User defaults
let SavedAppId = "SavedappId"
let ConsetFlagBlueSTack = "ConsetFlagBlueSTack"
let CMP_LANGUAGE = "CMP_LANGUAGE"


//Constants Globlales
var MNG_ADS_APP_ID  :String? {
    get {
        return UserDefaults.standard.object(forKey: SavedAppId) as? String
    }
    set {
        print("Saving App Id which is now \(String(describing: MNG_ADS_APP_ID))")
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(newValue, forKey: SavedAppId)
            UserDefaults.standard.synchronize()
        }
    }
    
}

let MNG_ADS_ConsentFlag = UserDefaults.standard.object(forKey: ConsetFlagBlueSTack) as? Int

let MNG_ADS_CMPLanguage = UserDefaults.standard.object(forKey: CMP_LANGUAGE) as? String


public struct DemoSwiftConstants {
    public static let appID = "2598284"//change it later 
    
    public static let menuSize = 214
    
    struct PLACEMENTS {
        
        static let MNG_ADS_BANNER_PLACEMENT_ID = "/banner" //cappingperiod
        static let MNG_ADS_SQUARE_PLACEMENT_ID = "/square"
        static let MNG_ADS_DYNAMICAD_PLACEMENT_ID = "/dynamicAd"
        static let MNG_ADS_NATIVEAD_PLACEMENT_ID = "/nativead"
        static let MNG_ADS_NATIVEAD_WITHOUTCOVER_PLACEMENT_ID = "/nativead_without_cover"
        static let MNG_ADS_INTERSTITIAL_PLACEMENT_ID = "/interstitial"
        static let MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID = "/interstitialOverlay"
        static let MNG_ADS_INFEED_PLACEMENT_ID = "/infeed"
        static let MNG_ADS_REWARDEDVIDEO_PLACEMENT_ID = "/rewardvideo"
        
        static let MNG_ADS_THUMBNAIL_PLACEMENT_ID = "/thumbnailOgury"
        
        
    }
    
    struct PLACEMENTS_MAS {
        
        static let MNG_ADS_BANNER_PLACEMENT_ID = "/bannermng"
        static let MNG_MAS_SQUARE_BANNER_PLACEMENT_ID = "/squaremng"
        static let MNG_ADS_NATIVEAD_PLACEMENT_ID = "/nativeadmng"
        static let MNG_ADS_INTERSTITIAL_PLACEMENT_ID = "/intermng"
        
        
    }
    
    
    struct PLACEMENTS_AppsFire {
        
        static let MNG_ADS_BANNER_PLACEMENT_ID = "/banneraf"
        static let MNG_MAS_SQUARE_BANNER_PLACEMENT_ID = "/squareaf"
        static let MNG_ADS_NATIVEAD_PLACEMENT_ID = "/nativeadaf"
        static let MNG_ADS_INTERSTITIAL_PLACEMENT_ID = "/interaf"
        
        
    }
    
    struct PLACEMENTS_DFP {
        static let BANNER_AD_ADUNIT = "/40369895/71333//FR_DEMO_MNG_ADS_IOS_BANNER_TESTYIELD_IOS_V2"
        static let INTERSTITIEL_AD_ADUNIT = "/40369895/71333//FR_DEMO_MNG_ADS_IOS_INTERTITIAL_TESTYIELD_IOS_V2"
        static let SQUARE_AD_ADUNIT = "/40369895/71333//FR_DEMO_MNG_ADS_IOS_SQUARE_TESTYIELD_IOS_V2"
        static let NATIVE_AD_ADUNIT = "/40369895/71333//32264"
        static let REWARD_AD_ADUNIT = "/40369895/71333"
    }
    
}

