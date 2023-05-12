//
//  SwiftViewController.swift
//  DemoSwift
//  Created by HtrimechMac on 04/06/2021.
//  Copyright (c) 2021 MNG. All rights reserved.
//

import UIKit
import MAdvertiseCMP
import BlueStackSDK


let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

class SwiftViewController: UIViewController, MNGAdsAdapterBannerDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate,MNGClickDelegate,BluestackThumbnailAdDelegate, CMPConsentManagerDelegate {
    
    @IBOutlet weak var nativeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialContextLabel: UILabel!
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var bannerView: UIView!

    @IBOutlet weak var showIntersButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bannerFactory: MNGAdsSDKFactory!
    var nativeAdFactory: MNGAdsSDKFactory!
    var interstitialAdsFactory: MNGAdsSDKFactory!
    
    var badgeView: UIView? = nil
    var adChoiceBadgeView: UIView? = nil
    var nativeObject: MNGNAtiveObject? = nil
    
    var thumbnailAdFactory: MNGAdsSDKFactory!
    
    @IBOutlet weak var thumbnailBtn: UIButton!
    init() {
        super.init(nibName: "SwiftViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Banner setup
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.placementId = "/\(DemoSwiftConstants.appID)/bannerogury"
        bannerFactory.viewController = self
        bannerFactory.bannerDelegate = self
        let preference = MNGPreference.init()
        preference.age = 25
        preference.keyWord = "brand=myBrand;category=sport";//Separator in case of multiple entries is ; key=value
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        bannerFactory.loadBanner(inFrame: kMNGAdSizeBanner, withPreferences: preference)
        
        // NativeAd setup
        nativeView.isHidden = true
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory.placementId = "/\(DemoSwiftConstants.appID)/nativead"
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.clickDelegate = self
        nativeAdFactory.viewController = self
        let preferences = MNGPreference.init()
        nativeAdFactory.loadNative(withPreferences: preferences,withCover:true)
     
        let showIntersLayer = self.showIntersButton.layer
        showIntersLayer.cornerRadius = self.showIntersButton.frame.size.height / 2
        showIntersLayer.borderWidth = 1
        showIntersLayer.borderColor = UIColor(red: 114/255, green: 213/255, blue: 206/255, alpha: 1).cgColor
        showIntersLayer.masksToBounds = true
        
        
        if interstitialAdsFactory != nil {
            if  interstitialAdsFactory.isBusy {
                NSLog("Ads Factory is busy")
                return
            }
            interstitialAdsFactory.releaseMemory()
        }
        
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory.interstitialDelegate = self
        interstitialAdsFactory.viewController = self
        interstitialAdsFactory.placementId = "/\(DemoSwiftConstants.appID)/interogury"

        let preferencess = MNGPreference.init()
        interstitialAdsFactory.loadInterstitial(withPreferences: preferencess, autoDisplayed: true)
        
        CMPConsentManager.shared.delegate = self

        // Configure the CMPConsentManager shared instance.
//        let cmpLanguage = CMPLanguage(string: "fr") ?? CMPLanguage.DEFAULT_LANGUAGE
///        CMPConsentManager.shared.configure("MAdvertiseCMPSettingsTCFV2_config_fr", language: cmpLanguage, appId: "APPid", publisherCC: "FR")
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func createInters(_ sender: UIButton) {
        // NativeAd setup
        nativeView.isHidden = true
        if interstitialAdsFactory != nil {
            if  interstitialAdsFactory.isBusy {
                NSLog("Ads Factory is busy")
                return
            }
            interstitialAdsFactory.releaseMemory()
        }
        
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory.interstitialDelegate = self
        interstitialAdsFactory.viewController = self
        if sender.tag == 1 {
            interstitialAdsFactory.placementId = "/\(DemoSwiftConstants.appID)/amazonapsinter"
        }else{
            interstitialAdsFactory.placementId = "/\(DemoSwiftConstants.appID)/interstitialOverlay"
        }
        
        let preference = MNGPreference.init()
        interstitialAdsFactory.loadInterstitial(withPreferences: preference, autoDisplayed: false)
        self.activityIndicator.startAnimating()
        self.showIntersButton.isHidden = true
    }
    
    @IBAction func showInters(_ sender: UIButton) {
        
        if interstitialAdsFactory.isInterstitialReady() {
            interstitialAdsFactory.displayInterstitial()

        }
    }
    
    // MARK: - Menu Button
    @IBAction func openMenu(_ sender: Any) {
        APP_DELEGATE.drawerViewController?.openMenu()
        
    }
    
    
    // MARK: - MNGAdsAdapterInterstitialDelegate
    
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad")
        self.showIntersButton.isHidden = false
        self.activityIndicator.stopAnimating()
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear")
        self.showIntersButton.isHidden = true
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        NSLog("\(String(describing: error))")
        self.activityIndicator.stopAnimating()
     
        
    }
    
    
    @IBAction func loadBanner(_ sender: Any) {
        // NativeAd setup
        nativeView.isHidden = true
        // Banner setup
        if bannerView != nil {
            bannerView.removeFromSuperview()
            bannerView = nil
        }
       
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.placementId = "/\(DemoSwiftConstants.appID)/bannersmart"
        //for tests inappbiding = banner_inappbidding // banner Mngperf = bannermng
        bannerFactory.viewController = self
        bannerFactory.bannerDelegate = self;

        let preference = MNGPreference.init()
        bannerFactory.loadBanner(inFrame: kMNGAdSizeBanner, withPreferences: preference)
        
    }
    // MARK: - MNGAdsAdapterBannerDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        bannerView = adView;
        
        bannerView.frame = CGRect(x:(self.view.frame.size.width - adView.frame.size.width) / 2, y:self.view.frame.size.height - preferredHeight - 44,width:adView.frame.size.width,height: preferredHeight)
        self.view.addSubview(bannerView)
    }
//    func adsAdapter(_ adsAdapter: MNGAdsAdapter! , bannerDidcha)  {
//
//    }
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        //
    }
    
    
    @IBAction func loadNativeAd(_ sender: Any) {
        // NativeAd setup
        nativeView.isHidden = true
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory.placementId = "/\(DemoSwiftConstants.appID)/nativead"
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.clickDelegate = self
        nativeAdFactory.viewController = self
        let preferences = MNGPreference.init()
        nativeAdFactory.loadNative(withPreferences: preferences)
        
    }
    
    // MARK: - MNGAdsAdapterNativeDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad nativeObject: MNGNAtiveObject!) {
        nativeView.layer.borderWidth = 1
        nativeView.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.text = nativeObject.title
        socialContextLabel.text = nativeObject.socialContext
        descriptionLabel.text = nativeObject.body
        if self.badgeView != nil {
            self.badgeView?.removeFromSuperview()
        }
        self.nativeObject = nativeObject
        badgeView = self.nativeObject?.badgeView
        if (badgeView != nil) {
            var frame = badgeView?.frame
            frame?.origin.y = 3
            frame?.origin.x = 3
            badgeView?.frame = frame!
            self.nativeView.addSubview(badgeView!)
        }
        
        if adChoiceBadgeView != nil {
            adChoiceBadgeView?.removeFromSuperview()
        }
        adChoiceBadgeView = self.nativeObject?.adChoiceBadgeView
        if adChoiceBadgeView != nil {
            var frame = adChoiceBadgeView?.frame
            let widhtFrame = frame!.size.width - 3
            frame?.origin.y = 3
            frame?.origin.x = self.nativeView.frame.size.width - widhtFrame
            adChoiceBadgeView?.frame = frame!
            self.nativeView.addSubview(adChoiceBadgeView!)
        }
        
        // download images
        self.backgroundImage.image = nil
        self.iconeImage.image = nil
        self.iconeImage.layer.cornerRadius = 16
        self.iconeImage.clipsToBounds = true
   
        
        self.callToActionButton.setTitle(self.nativeObject?.callToAction, for: UIControl.State())
        if self.nativeObject?.displayType == MNGDisplayType.appInstall {
            self.callToActionButton.setImage(#imageLiteral(resourceName: "download"), for: UIControl.State())
        }else if self.nativeObject?.displayType == .content {
            self.callToActionButton.setImage(#imageLiteral(resourceName: "arrow"), for: UIControl.State())
        }
        self.callToActionButton.titleLabel?.textAlignment = .center
        
        self.nativeObject?.registerView(forInteraction: self.nativeView, withMediaView: self.backgroundImage, withIconImageView: self.iconeImage, with: self, withClickableView: self.callToActionButton)
        self.nativeView.isHidden = false

    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool){
        NSLog("\(String(describing: error))")
    }
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        
    }
 
    @IBAction func infeedVC(_ sender: Any) {
        let  vc:   InfeedViewController = InfeedViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func loadThumbnail(_ sender: Any) {
        thumbnailAdFactory  = MNGAdsSDKFactory()
        thumbnailAdFactory.placementId = "/\(DemoSwiftConstants.appID)/thumbnailOgury"
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.thumbnailAdDelegate = self;
        let preferences = MNGPreference.init()
        thumbnailAdFactory.loadThumbnail(withPreferences: preferences)
    }
    
    
    func adsAdapterThumbnailAdAdLoaded(_ adsAdapter: MNGAdsAdapter!) {
        thumbnailAdFactory.showThumbnail()
        
    }
    func adsAdapterThumbnailAdAdError(_ adsAdapter: MNGAdsAdapter!, withError error: Error!) {
        
    }
    func adsAdapterThumbnailAdAdClicked(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    func adsAdapterThumbnailAdAdClosed(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    func dealloc() {
        
    }
    
    func consentManagerRequestsToShowConsentTool(_ consentManager: CMPConsentManager, forVendorList vendorList: CMPVendorList) {
        NSLog("CMP Requested ConsentTool Display");

        // You should display the consent tool UI, when user is ready…
//        if let controller = self.window?.rootViewController {
//            let _ = consentManager.showConsentTool(fromController: controller, withPopup: true)
//        }
//        let _ = consentManager.showConsentTool(fromController: self, withPopup: true)
    }
}
