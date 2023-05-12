//
//  RewardedVideoViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import UIKit
import BlueStackSDK

class RewardedVideoViewController: UIViewController , MAdvertiseAdapterRewardedVideoAdDelegate {
    
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var logContainer: UIView!
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    
    var videoAd : MAdvertiseRewardedVideoAd?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoAd = MAdvertiseRewardedVideoAd(placementID: "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_REWARDEDVIDEO_PLACEMENT_ID)")
        showButton.isHidden = true
 
    }


    
    // MARK: - Open Menu
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func loadAd(_ sender: UIButton) {
        showButton.isHidden = true
        logTextView.text = ""
        videoAd?.delegate = self
        videoAd?.load()
    }
    
    
    @IBAction func showAd(_ sender: UIButton) {
        
        logTextView.text = ""
        var message = "Video rewarded is not AdValid "
        
        if videoAd?.isAdValid ?? false {
            message = "Video rewarded is AdValid "
            videoAd?.showAd(fromRootViewController: self, animated: true)
        }else {
            message = "Video rewarded is not AdValid "
        }
        
        APP_DELEGATE.displayToast(message: message)
        
    }
    
    // MARK: - VideoAd Delegate
    func adsAdapterRewardedVideoAdDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        showButton.isHidden = false
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, rewardedVideoAdDidFailWithError error: Error!) {
        showButton.isHidden = true
        
    }
    
    func adsAdapterRewardedVideoAdDidClose(_ adsAdapter: MNGAdsAdapter!) {
        showButton.isHidden = true
    }
    
    func adsAdapterRewardedVideoAdComplete(_ adsAdapter: MNGAdsAdapter!, with reward: MAdvertiseReward!) {
        var message = "Video rewarded "
        if reward != nil {
            message = "\(message) \n type: \(String(describing: reward!.type!)) \n amount: \(String(describing: reward!.amount!))"
        }
        logTextView.text = message
        APP_DELEGATE.displayToast(message: message)
    }
    
    
}
