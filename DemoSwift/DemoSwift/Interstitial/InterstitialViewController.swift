//
//  InterstitialViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 17/8/2022.
//

import UIKit
import BlueStackSDK

class InterstitialViewController: UIViewController , MNGAdsAdapterInterstitialDelegate , MNGClickDelegate {
    
    
    @IBOutlet weak var activityindicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var configView: UIView!
    
    @IBOutlet weak var showIntersButton: UIButton!
    @IBOutlet weak var displayIntersButton: UIButton!
    
    
    @IBOutlet weak var ovelayBtn: UIButton!
    @IBOutlet weak var interBtn: UIButton!
    
    var interstitialAdsFactory: MNGAdsSDKFactory!
    var autoDisplay : Bool = false
    
    var childVC : ChildInterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAdsFactory = MNGAdsSDKFactory()
        
        self.showIntersButton.layer.borderWidth = 1
        self.showIntersButton.layer.borderColor = UIColor.lightGray.cgColor
        self.showIntersButton.layer.cornerRadius = self.showIntersButton.frame.size.height / 2
        
        self.displayIntersButton.layer.borderWidth = 1
        self.displayIntersButton.layer.borderColor = UIColor.lightGray.cgColor
        self.displayIntersButton.layer.cornerRadius = self.displayIntersButton.frame.size.height / 2
        
      //  self.addVC()
        
    }

    // MARK: - add View Controller Child
    
    func addVC()  {
        childVC = ChildInterViewController()
        childVC?.view.frame = CGRect(x: 50, y: 270, width: UIScreen.main.bounds.width - 100, height: 290)
        childVC?.view.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.view.addSubview(childVC!.view)
        self.addChild(childVC!)
        
    }
  
    // MARK: - OpenMenu button

     
    @IBAction func openMenu(_ sender: Any) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    
    @IBAction func openCloseConfig(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.configView.isHidden = sender.isSelected
    }
    
    
    // MARK: - Inters Button Actions
   
    @IBAction func showInters(_ sender: UIButton) {
        if interstitialAdsFactory.isInterstitialReady() {
            if sender.tag == 0 {
                interstitialAdsFactory.showAd(fromRootViewController: APP_DELEGATE.drawerViewController, animated: true)
            } else if sender.tag == 1 {
                interstitialAdsFactory.displayInterstitial()
            }
        }
    }
    
   
    // MARK: - Inters Button Actions
    @IBAction func createInters(_ sender: UIButton) {
        
        if interstitialAdsFactory.isBusy {
             print("Ads Factory is busy")
             interstitialAdsFactory.releaseMemory()
            return
        }
        
        interstitialAdsFactory.interstitialDelegate = self
        interstitialAdsFactory.clickDelegate = self
        interstitialAdsFactory.viewController = self

        let preferencess = MNGPreference.init()
        
        self.activityindicatorView.startAnimating()
        self.displayIntersButton.isHidden  = true
        self.showIntersButton.isHidden = true
        
        if sender.tag == 1 {
            autoDisplay = false
            interstitialAdsFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID)"
            interstitialAdsFactory.loadInterstitial(withPreferences: preferencess, autoDisplayed: false)
        } else {
            autoDisplay = true
            interstitialAdsFactory.placementId = "/\(MNG_ADS_APP_ID!)\( DemoSwiftConstants.PLACEMENTS.MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID)"
            interstitialAdsFactory.loadInterstitial(withPreferences: preferencess, autoDisplayed: true)
        }
        
        APP_DELEGATE.drawerViewController?.statusBarStyle = .lightContent
    }
    
    
    // MARK: - MNGAdsAdapterInterstitialDelegate
    
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad")
        if autoDisplay {
            self.showIntersButton.isHidden = true
            self.displayIntersButton.isHidden = true
        } else {
            self.showIntersButton.isHidden = false
            self.displayIntersButton.isHidden = false
        }
       
        self.activityindicatorView.stopAnimating()
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear")
        self.showIntersButton.isHidden = true
        self.displayIntersButton.isHidden = true
    }
    
    func adsAdapterInterstitialDidShown(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidShown");
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        NSLog("\(String(describing: error))")
        self.activityindicatorView.stopAnimating()
    }
    
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("----->Inter1 clicked")
    }
    
    
    
    
    
    
}
