//
//  DFPDemoViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import UIKit
import GoogleMobileAds
import BlueStackSDK


class DFPDemoViewController: UIViewController , GADBannerViewDelegate,GADNativeAdDelegate, GADNativeAdLoaderDelegate, GADFullScreenContentDelegate {
    
    
    
    @IBOutlet weak var interButton: UIButton!
    

    @IBOutlet weak var squareView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial : GADInterstitialAd?
    var rewardedAd : GADRewardedAd?
    var adloader : GADAdLoader?
    
    @IBOutlet weak var nativeAdPlaceholder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nativeAdPlaceholder.isHidden = true
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
            ["3dfeb1de1a684fa0bc69fba5d32dd785"]
        
    }


    // MARK: - Navigation
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    
    // MARK: - reset ads
    func resetAds(){
        self.nativeAdPlaceholder.isHidden = true
        self.interstitial = nil
    }
    
    //MARK: - Prepare request
    func prepareRequest() -> GADRequest {
        
        let request = GADRequest()
        let keyword = "target=mngadsdemo;version=4.0.0"
        let json = ["age" :"25",
                    "consent" :"test",
                    "gender" :"test2"]
        let extras  = BlueStackGADAdNetworkExtras(keywords: keyword, customTargetingBlueStack: json)
        request.register(extras)
        return request
        
    }
    // MARK: - Banner/Square
    @IBAction func createBanner(_ sender: UIButton) {
        
        self.resetAds()
        
        let request = self.prepareRequest()
        
        
        bannerView.adUnitID = DemoSwiftConstants.PLACEMENTS_DFP.BANNER_AD_ADUNIT
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adSize = GADAdSizeBanner
        bannerView.load(request)
    }
    
    @IBAction func createSquare(_ sender: UIButton) {
        self.resetAds()
        
        let request = self.prepareRequest()
        
        squareView.adUnitID = DemoSwiftConstants.PLACEMENTS_DFP.SQUARE_AD_ADUNIT
        squareView.delegate = self
        squareView.rootViewController = self
        squareView.adSize = GADAdSizeBanner
        squareView.load(request)
        
    }
    
    // MARK: - GADBannerViewDelegate
    
    // Called when an ad request loaded an ad.
      func adViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
          if GADAdSizeEqualToSize(bannerView.adSize, GADAdSizeMediumRectangle ) {
              self.squareView = bannerView
          } else {
              self.bannerView = bannerView
          }
      }

      // Called when an ad request failed.
    private func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: NSError) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
      }
    
    
    // MARK: - Native Ad
    @IBAction func createNativeAd(_ sender: UIButton) {
        
        self.resetAds()
        
        adloader = GADAdLoader(adUnitID:DemoSwiftConstants.PLACEMENTS_DFP.NATIVE_AD_ADUNIT , rootViewController: self, adTypes: [], options: nil)
        
        let request = self.prepareRequest()
        adloader?.delegate = self
        adloader?.load(request)
        
    }
    // MARK: - GADnativeAdloader delegate
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAdPlaceholder.isHidden = false
        //config of the native ad
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        NSLog("Native Ad did fail")
    }
    
    
    // MARK: - Interstitial
    @IBAction func createInterstitial(_ sender: UIButton) {
        if interstitial != nil {
            interstitial!.present(fromRootViewController:self)
        } else {
            self.requestInter()
        }
    }
    
    
    func requestInter() {
        self.resetAds()
        
        let request = GAMRequest()
        
        GADInterstitialAd.load(withAdUnitID:DemoSwiftConstants.PLACEMENTS_DFP.INTERSTITIEL_AD_ADUNIT,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial!.fullScreenContentDelegate = self
            self.interButton.setTitle("Show Interstitial", for: .normal)
        })
    }
    
  // MARK: - Interstitial : GADInterstitialDelegate  delegate
                               
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
        self.interButton.setTitle("Load Interstitial", for: .normal)
    }
    
    @IBAction func createRewardedVideo(_ sender: UIButton) {
    }
    
    
    
}


//MARK: Extra

class BlueStackGADAdNetworkExtras : NSObject, GADAdNetworkExtras{
    
    let keywords : String
    let customTargetingBlueStack : [String:String]
    
    
     init(keywords : String, customTargetingBlueStack : [String:String]){
        self.keywords = keywords
        self.customTargetingBlueStack = customTargetingBlueStack
        super.init()
    }
    
}
