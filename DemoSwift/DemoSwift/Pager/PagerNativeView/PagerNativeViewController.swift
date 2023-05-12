//
//  PagerNativeViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 19/8/2022.
//

import UIKit
import BlueStackSDK

class PagerNativeViewController: UIViewController, MNGAdsAdapterNativeDelegate {
    
    
    @IBOutlet weak var pubView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var callToActionButton: UIButton!
    
    @IBOutlet weak var badgeContainer: UIView!
    
    @IBOutlet weak var adChoiceContainer: UIView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    var index : Int = 0
    var nativeAdsFactory : MNGAdsSDKFactory!
    var badgeView : UIView?
    var adChoiceBadgeView : UIView?
    var _nativeObject : MNGNAtiveObject?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pubView.isHidden = true
        if index == 2 {
            indicatorView.startAnimating()
            nativeAdsFactory = MNGAdsSDKFactory()
            nativeAdsFactory.nativeDelegate = self
            nativeAdsFactory.viewController = self
            nativeAdsFactory.placementId = "/\(DemoSwiftConstants.appID)/nativead"
            var preferences = self.getTestPreferences()
            nativeAdsFactory.loadNative(withPreferences: preferences)
        }
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


    // MARK: - Native Ad delegate
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad adView: MNGNAtiveObject!) {
        indicatorView.stopAnimating()
        _nativeObject = adView
        self.pubView.layer.borderWidth = 1
        self.titleLabel.text = _nativeObject?.title
        self.descriptionLabel.text = _nativeObject?.body
        
        if badgeView != nil {
            badgeView?.removeFromSuperview()
        }
        badgeView = _nativeObject?.badgeView
        self.badgeContainer.addSubview(badgeView!)
        
        if adChoiceBadgeView != nil {
            adChoiceBadgeView?.removeFromSuperview()
        }
        adChoiceBadgeView = _nativeObject?.adChoiceBadgeView
        if let adChoiceBadgeView = adChoiceBadgeView {
            adChoiceContainer.addSubview(adChoiceBadgeView)
        }
       
        
        // download images
        self.backgroundImage.image = nil
        self.iconImage.image = nil
        self.iconImage.layer.cornerRadius = 16
        self.iconImage.clipsToBounds = true
   
        
        self.callToActionButton.setTitle(_nativeObject!.callToAction, for: UIControl.State())
        if self._nativeObject!.displayType == MNGDisplayType.appInstall {
            self.callToActionButton.setImage(#imageLiteral(resourceName: "download"), for: UIControl.State())
        }else if self._nativeObject!.displayType == .content {
            self.callToActionButton.setImage(#imageLiteral(resourceName: "arrow"), for: UIControl.State())
        }
        self.callToActionButton.titleLabel?.textAlignment = .center
        
        self._nativeObject?.registerView(forInteraction: self.pubView, withMediaView: self.backgroundImage, withIconImageView: self.iconImage, with: self, withClickableView: self.callToActionButton)
        self.pubView.isHidden = false
        
        
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool) {
        indicatorView.stopAnimating()
        NSLog("\(String(describing: error))")
    }

}
