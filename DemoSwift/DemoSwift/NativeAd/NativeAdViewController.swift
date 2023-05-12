//
//  NativeAdViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 17/8/2022.
//

import UIKit
import BlueStackSDK



class NativeAdViewController: UIViewController , MNGAdsAdapterNativeDelegate, MNGClickDelegate {
    
    @IBOutlet weak var nativeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialContextLabel: UILabel!
    
    
    @IBOutlet weak var nativeViewWithout: UIView!
    @IBOutlet weak var iconeImageWithout: UIImageView!
    @IBOutlet weak var callToActionButtonWithout: UIButton!
    @IBOutlet weak var descriptionLabelWithout: UILabel!
    @IBOutlet weak var titleLabelWithout: UILabel!
    @IBOutlet weak var socialContextLabelWithout: UILabel!
    
    
    var cover : Bool = false
    
    var nativeAdFactory: MNGAdsSDKFactory!
    var badgeView: UIView? = nil
    var adChoiceBadgeView: UIView? = nil
    var nativeObject: MNGNAtiveObject? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nativeView.isHidden = true
        self.nativeViewWithout.isHidden = true
        
    }
    
    func loadNativeAd(){
        // NativeAd setup
        nativeView.isHidden = true
        nativeAdFactory = MNGAdsSDKFactory()
        if cover {
            nativeAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_NATIVEAD_PLACEMENT_ID)"
        } else {
            nativeAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_NATIVEAD_WITHOUTCOVER_PLACEMENT_ID)"
        }
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.clickDelegate = self
        nativeAdFactory.viewController = self
        let preferences = MNGPreference.init()
        nativeAdFactory.loadNative(withPreferences: preferences,withCover:cover)
    }
    
    // MARK: - Buttons Actions
    
    
    @IBAction func nativeAdWithCoverTapped(_ sender: UIButton) {
        cover = true
        self.loadNativeAd()
        
    }
    
    
    @IBAction func nativeAdWithoutCoverTapped(_ sender: UIButton) {
        cover = false
        self.loadNativeAd()
    }
    
    
    // MARK: - Menu Open
    
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    // MARK: - MNGAdsAdapterNativeDelegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad nativeObject: MNGNAtiveObject!) {
        if cover {
            self.setupCoverView(nativeObject: nativeObject)
        } else {
            self.setupWithoutCoverView(nativeObject: nativeObject)
        }
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool){
        NSLog("\(String(describing: error))")
        APP_DELEGATE.displayToast(message: "NativeAd  did fail")
    }
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        APP_DELEGATE.displayToast(message: "NativeAd  adsAdapter Clicked")
    }
    
    //MARK: -fill the nativeAd with Cover
    func setupCoverView(nativeObject : MNGNAtiveObject)  {
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
        self.nativeViewWithout.isHidden = true
    }
    
    //MARK: -fill the nativeAd without Cover
    func setupWithoutCoverView(nativeObject : MNGNAtiveObject)  {
        nativeViewWithout.layer.borderWidth = 1
        nativeViewWithout.layer.borderColor = UIColor.lightGray.cgColor
        titleLabelWithout.text = nativeObject.title
        socialContextLabelWithout.text = nativeObject.socialContext
        descriptionLabelWithout.text = nativeObject.body
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
            self.nativeViewWithout.addSubview(badgeView!)
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
            self.nativeViewWithout.addSubview(adChoiceBadgeView!)
        }
        
        // download images
        self.iconeImageWithout.image = nil
        self.iconeImageWithout.layer.cornerRadius = 16
        self.iconeImageWithout.clipsToBounds = true
   
        
        self.callToActionButtonWithout.setTitle(self.nativeObject?.callToAction, for: UIControl.State())
        if self.nativeObject?.displayType == MNGDisplayType.appInstall {
            self.callToActionButtonWithout.setImage(#imageLiteral(resourceName: "download"), for: UIControl.State())
        }else if self.nativeObject?.displayType == .content {
            self.callToActionButtonWithout.setImage(#imageLiteral(resourceName: "arrow"), for: UIControl.State())
        }
        self.callToActionButtonWithout.titleLabel?.textAlignment = .center
        
        self.nativeObject?.registerView(forInteraction: self.nativeViewWithout, withMediaView: nil, withIconImageView: self.iconeImageWithout, with: self, withClickableView: self.callToActionButtonWithout)
        
        self.nativeView.isHidden = true
        self.nativeViewWithout.isHidden = false
    }
    

}