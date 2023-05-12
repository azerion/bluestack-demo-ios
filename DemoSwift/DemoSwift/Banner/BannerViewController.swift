//
//  BannerViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 17/8/2022.
//

import UIKit
import AVFoundation
import MAdvertiseCMP
import BlueStackSDK 

class BannerViewController: UIViewController , MNGAdsAdapterBannerDelegate,MNGClickDelegate , MNGAdsAdapterRefreshDelegate ,CMPConsentManagerDelegate{
    
    
    @IBOutlet weak var configView: UIView!
    
    @IBOutlet weak var squareBtn: UIButton!
    @IBOutlet weak var bannerBtn: UIButton!
    
    @IBOutlet weak var zoneLabel: UILabel!
    
    
    var bannerFactory: MNGAdsSDKFactory!
    var bannerView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerFactory = MNGAdsSDKFactory()
        
        setUpLocation()
        
        CMPConsentManager.shared.delegate = self
        let cmpLanguage = CMPLanguage(string: MNG_ADS_CMPLanguage == "" ? "fr" :MNG_ADS_CMPLanguage  ?? "fr" )
        
        CMPConsentManager.shared.configure("MAdvertiseCMPSettingsTCFV2_config_fr", language: cmpLanguage!, appId: MNG_ADS_APP_ID ?? DemoSwiftConstants.appID, publisherCC: "FR",autoClose:true)
        
    }
    
    
    //MARK: -location
    func setUpLocation(){
        
        if APP_DELEGATE.sharedLocationManager == nil {
           APP_DELEGATE.sharedLocationManager = CLLocationManager()
            if APP_DELEGATE.sharedLocationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) ?? false {
                APP_DELEGATE.sharedLocationManager?.requestWhenInUseAuthorization()
            }
            APP_DELEGATE.sharedLocationManager?.startUpdatingLocation()
        }
    }

    // MARK: - Open Menu
    
    
    @IBAction func openCloseConfig(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        self.configView.isHidden = sender.isSelected;
    }
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
        
    }
    
    // MARK: - create Banner
    
    @IBAction func setSize(_ sender: UIButton) {
        if bannerFactory.isBusy {
            NSLog("Ads Factory is busy");
            bannerFactory.releaseMemory()
            return;
        }
        bannerView?.removeFromSuperview()
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.bannerDelegate = self
        bannerFactory.clickDelegate = self
        bannerFactory.refreshDelegate  = self
        bannerFactory.viewController = self
        
        if sender.tag == 250 {
            bannerFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_SQUARE_PLACEMENT_ID)"
        } else {
            bannerFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_BANNER_PLACEMENT_ID)"
        }
      
       
        let preference = MNGPreference.init()
        preference.age = 25
        preference.keyWord = "brand=myBrand;category=sport";//Separator in case of multiple entries is ; key=value
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        bannerFactory.loadBanner(inFrame: kMNGAdSizeBanner, withPreferences: preference)
        
    }
    
    
    // MARK: - MNGAdsAdapterBannerDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        bannerView = adView;
        
        bannerView?.frame = CGRect(x:(self.view.frame.size.width - adView.frame.size.width) / 2, y:self.view.frame.size.height - preferredHeight - 44,width:adView.frame.size.width,height: preferredHeight)
        self.view.addSubview(bannerView!)
    }
//    func adsAdapter(_ adsAdapter: MNGAdsAdapter! , bannerDidcha)  {
//
//    }
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        NSLog("banner failed")
        APP_DELEGATE.displayToast(message: "banner failed")
    }
    
    func adsAdapterBannerDidRefresh(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("banner refreshed")
        APP_DELEGATE.displayToast(message: "banner refreshed")
    }
    
    
    // MARK: - CMPConsentManagerDelegate
    
    func consentManagerRequestsToShowConsentTool(_ consentManager: CMPConsentManager, forVendorList vendorList: CMPVendorList) {
        NSLog("CMP Requested ConsentTool Display");
        
        // You should display the consent tool UI, when user is ready…
        let _ = consentManager.showConsentTool(fromController: self, withPopup: true)
    }
    
    func tcfOnConsentStringDidChange(_ newTcfConsentString: TCFString, consentProvided: String) {
        print("-------->TCFString did change")
        APP_DELEGATE.displayToast(message: consentProvided)
    }
    
    
    func consentManagerDidFailWithError(error: Error) {
        APP_DELEGATE.displayToast(message: error.localizedDescription)
        NSLog("consentManagerDidFailWithErrorWithError \(error.localizedDescription)")
    }
    
    func consentManagerRequestsToPresentPrivacyPolicy(url: String) {
        APP_DELEGATE.displayToast(message: url)
    }
    
    
    //MARK: - Radio
    
    
    @IBAction func play(_ sender: UIButton) {
        APP_DELEGATE.play()
    }
    
    
    @IBAction func stop(_ sender: UIButton) {
        APP_DELEGATE.stop()
    }
    
    
    
    @IBAction func mixedBtn(_ sender: UIButton) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    
    
    @IBAction func duckBtn(_ sender: UIButton) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
}
