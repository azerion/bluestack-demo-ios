//
//  SwiftViewController.swift
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/14/15.
//  Edited by Hussein Dimessi on 1/10/17.
//  Copyright (c) 2015 MNG. All rights reserved.
//

import UIKit
//import MAdvertiseCMP
import AdSupport

//import UserPrivacy


let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

class SwiftViewController: UIViewController, MNGAdsAdapterBannerDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate,MNGClickDelegate,BluestackThumbnailAdDelegate {
    
    @IBOutlet weak var nativeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialContextLabel: UILabel!
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var showIntersButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bannerFactory: MNGAdsSDKFactory!
    var nativeAdFactory: MNGAdsSDKFactory!
    var interstitialAdsFactory: MNGAdsSDKFactory!
    var thumbnailAdFactory: MNGAdsSDKFactory!

    var badgeView: UIView? = nil
    var adChoiceBadgeView: UIView? = nil
    var nativeObject: MNGNAtiveObject? = nil
    
    init() {
        super.init(nibName: "SwiftViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let idfa : NSUUID? = ASIdentifierManager.shared().advertisingIdentifier as NSUUID
//        let idVendor : String? = UIDevice.current.identifierForVendor?.uuidString
//        
        // Banner setup
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.placementId = PLACEMENTS.MNG_ADS_BANNER_PLACEMENT_ID
        bannerFactory.bannerDelegate = self
        bannerFactory.viewController = self
        let preference = Utils.getTestPreferences()
        bannerFactory.loadBanner(inFrame: CGRect(x:0, y:60,width:self.view.frame.size.width,height: 50), withPreferences: preference)
        
        // NativeAd setup
        nativeView.isHidden = true
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory.placementId = PLACEMENTS.MNG_ADS_NATIVEAD_PLACEMENT_ID
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.clickDelegate = self
        nativeAdFactory.viewController = self
        let preferences = Utils.getTestPreferences()
        nativeAdFactory.loadNative(withPreferences: preferences)
        // Interstitial setup
        if APP_DELEGATE.sharedLocationManager == nil {
           APP_DELEGATE.sharedLocationManager = CLLocationManager()
            if APP_DELEGATE.sharedLocationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                APP_DELEGATE.sharedLocationManager.requestWhenInUseAuthorization()
            }
            APP_DELEGATE.sharedLocationManager.startUpdatingLocation()
        }
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
        interstitialAdsFactory.viewController = APP_DELEGATE.drawerViewController
        interstitialAdsFactory.placementId = PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID

        let preferencess = Utils.getTestPreferences()
        interstitialAdsFactory.loadInterstitial(withPreferences: preferencess, autoDisplayed: true)
        
        
//        thumbnailAdFactory  = MNGAdsSDKFactory()
//        thumbnailAdFactory.placementId = PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID
//        thumbnailAdFactory.viewController =  APP_DELEGATE.drawerViewController
//        thumbnailAdFactory.thumbnailAdDelegate = self;
//        thumbnailAdFactory.loadThumbnail(withPreferences: preferences)
//        
    }

    @IBAction func loadThumbnail(_ sender: Any) {
        thumbnailAdFactory  = MNGAdsSDKFactory()
        thumbnailAdFactory.placementId = PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.thumbnailAdDelegate = self;
        let preferencess = Utils.getTestPreferences()

        thumbnailAdFactory.loadThumbnail(withPreferences: preferencess)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerViewController.openMenu()
    }
    
    @IBAction func createInters(_ sender: UIButton) {
        if interstitialAdsFactory != nil {
            if  interstitialAdsFactory.isBusy {
                NSLog("Ads Factory is busy")
                return
            }
            interstitialAdsFactory.releaseMemory()
        }
        
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory.interstitialDelegate = self
        interstitialAdsFactory.viewController = APP_DELEGATE.drawerViewController
        if sender.tag == 1 {
            interstitialAdsFactory.placementId = PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID
        }else{
            interstitialAdsFactory.placementId = PLACEMENTS.MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID
        }
        
        let preferences = Utils.getTestPreferences()
        interstitialAdsFactory.loadInterstitial(withPreferences: preferences, autoDisplayed: false)
        self.activityIndicator.startAnimating()
        self.showIntersButton.isHidden = true
    }
    
    @IBAction func showInters(_ sender: UIButton) {
        if interstitialAdsFactory.isInterstitialReady() {
            interstitialAdsFactory.displayInterstitial()
            interstitialAdsFactory.showAd(fromRootViewController:APP_DELEGATE.drawerViewController , animated: true)

        }
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
    func adsAdapterInterstitialDidShown(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidShown")

    }
    // MARK: - MNGAdsAdapterBannerDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        adView.frame = CGRect(x:0, y:self.view.frame.size.height - 50,width:self.view.frame.size.width,height: 50)
        self.view.addSubview(adView)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        //
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
        
        self.nativeObject?.registerView(forInteraction: self.nativeView, withMediaView: self.backgroundImage, withIconImageView: self.iconeImage, with: APP_DELEGATE.drawerViewController, withClickableView: self.callToActionButton)
        
        self.nativeView.isHidden = false


    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool){
        NSLog("\(String(describing: error))")
    }
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        
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
}
