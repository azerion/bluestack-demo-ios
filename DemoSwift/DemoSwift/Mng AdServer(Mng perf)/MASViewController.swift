//
//  MASViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 17/8/2022.
//

import UIKit
import BlueStackSDK

class MASViewController: UIViewController , MNGAdsAdapterBannerDelegate,MNGAdsAdapterRefreshDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate , MNGClickDelegate {
    
    //Native Ad elements
    @IBOutlet weak var nativeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialContextLabel: UILabel!
    
    
    @IBOutlet weak var bannerBtn: UIButton!
    @IBOutlet weak var squareBtn: UIButton!
    @IBOutlet weak var interBtn: UIButton!
    @IBOutlet weak var nativeBtn: UIButton!
    
    //factories
    var bannerFactory: MNGAdsSDKFactory?
    var nativeAdFactory: MNGAdsSDKFactory?
    var interstitialAdsFactory: MNGAdsSDKFactory?
    
    //banner
    var bannerView: UIView?
    //nativeAd
    var badgeView: UIView? = nil
    var adChoiceBadgeView: UIView? = nil
    var nativeObject: MNGNAtiveObject? = nil
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    func getTestPreferences() ->MNGPreference {
        let preference = MNGPreference()
        preference.keyWord = "target=mngadsdemo;version=3.0.4;semantic=https://www.google.com"
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        preference.age = 60
        return preference
    }
    
    // MARK: - Open Menu
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    // MARK: - Banner Action
    
    @IBAction func createHimono(_ sender: UIButton) {
        bannerBtn.setTitleColor(UIColor(red: 0.60, green: 0.15, blue: 0.92, alpha: 1.0), for: .normal)
        squareBtn.setTitleColor(UIColor.white, for: .normal)
        nativeBtn.setTitleColor(UIColor.white, for: .normal)
        interBtn.setTitleColor(UIColor.white, for: .normal)
        
        if bannerFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            return
        }
        nativeView.isHidden = true
        bannerView?.removeFromSuperview()
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory?.bannerDelegate = self
        bannerFactory?.refreshDelegate = self
        bannerFactory?.clickDelegate = self
        bannerFactory?.viewController = self
        bannerFactory?.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS_MAS.MNG_ADS_BANNER_PLACEMENT_ID)"
        
        var size : MNGAdSize
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        size = isIpad ? kMNGAdSizeDynamicLeaderboard : kMNGAdSizeDynamicBanner
        
        let preferences = self.getTestPreferences()
        bannerFactory?.loadBanner(inFrame: size, withPreferences: preferences)
    }
    
    // MARK: - square Action
    
    @IBAction func createSashimi(_ sender: UIButton) {
        squareBtn.setTitleColor(UIColor(red: 0.60, green: 0.15, blue: 0.92, alpha: 1.0), for: .normal)
        bannerBtn.setTitleColor(UIColor.white, for: .normal)
        nativeBtn.setTitleColor(UIColor.white, for: .normal)
        interBtn.setTitleColor(UIColor.white, for: .normal)
        
        if bannerFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            return
        }
        nativeView.isHidden = true
        bannerView?.removeFromSuperview()
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory?.bannerDelegate = self
        bannerFactory?.refreshDelegate = self
        bannerFactory?.clickDelegate = self
        bannerFactory?.viewController = self
        bannerFactory?.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS_MAS.MNG_MAS_SQUARE_BANNER_PLACEMENT_ID)"
        
        let size : MNGAdSize = kMNGAdSizeMediumRectangle
        
        let preferences = self.getTestPreferences()
        bannerFactory?.loadBanner(inFrame: size, withPreferences: preferences)
        
    }
    
    
    // MARK: - NativeAd Action
    
    @IBAction func createNativeAd(_ sender: UIButton) {
        
        nativeObject = nil
        nativeBtn.setTitleColor(UIColor(red: 0.60, green: 0.15, blue: 0.92, alpha: 1.0), for: .normal)
        bannerBtn.setTitleColor(UIColor.white, for: .normal)
        squareBtn.setTitleColor(UIColor.white, for: .normal)
        interBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        bannerView?.removeFromSuperview()
        nativeView.isHidden = true
        
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory?.placementId = "/\(MNG_ADS_APP_ID!)\( DemoSwiftConstants.PLACEMENTS_MAS.MNG_ADS_NATIVEAD_PLACEMENT_ID)"
        nativeAdFactory?.nativeDelegate = self
        nativeAdFactory?.clickDelegate = self
        nativeAdFactory?.viewController = self
        let preferences = self.getTestPreferences()
        nativeAdFactory?.loadNative(withPreferences: preferences,withCover:true)
        
        
    }
    
    // MARK: - Interstitial Action
    @IBAction func createInterstitial(_ sender: Any) {
        
        interBtn.setTitleColor(UIColor(red: 0.60, green: 0.15, blue: 0.92, alpha: 1.0), for: .normal)
        bannerBtn.setTitleColor(UIColor.white, for: .normal)
        squareBtn.setTitleColor(UIColor.white, for: .normal)
        nativeBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        bannerView?.removeFromSuperview()
        nativeView.isHidden = true
        
        if interstitialAdsFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            return
        }
        
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory?.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS_MAS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID)"
        interstitialAdsFactory?.interstitialDelegate = self
        interstitialAdsFactory?.clickDelegate = self
        interstitialAdsFactory?.viewController = self
        let preferences = self.getTestPreferences()
        interstitialAdsFactory?.loadInterstitial(withPreferences: preferences, autoDisplayed: true)
    }
    
    
    // MARK: - MNGAdsAdapterBannerDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        bannerView?.removeFromSuperview()
        bannerView = adView;
        bannerView!.frame = CGRect(x:(self.view.frame.size.width - adView.frame.size.width) / 2, y:self.view.frame.size.height - preferredHeight - 44,width:adView.frame.size.width,height: preferredHeight)
        self.view.addSubview(bannerView!)
    }

    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        NSLog("banner did fail with error \(String(describing: error))")
        APP_DELEGATE.displayToast(message: "banner failed")
    }
    
    func adsAdapterBannerDidRefresh(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("banner refreshed")
        APP_DELEGATE.displayToast(message: "banner refreshed")
    }
    
    // MARK: - MNGAdsAdapterInterstitialDelegate
    
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad")
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear")
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        NSLog("\(String(describing: error))")
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
    
    
}
