//
//  TestMFViewController.swift
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 25/06/2020.
//  Copyright © 2020 Bensalah Med Amine. All rights reserved.
//

import UIKit
import BlueStackSDK

class TestMFViewController: UIViewController , MNGAdsAdapterBannerDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate,MNGClickDelegate,MNGAdsAdapterInfeedDelegate,UITableViewDelegate,UITableViewDataSource {
  

    @IBOutlet weak var inFeedTableView: UITableView!
     var bannerFactory: MNGAdsSDKFactory!
     var infeedFactory: MNGAdsSDKFactory!
     var interstitialAdsFactory: MNGAdsSDKFactory!
     var nativeAdFactory: MNGAdsSDKFactory!
     var nativeObjectlocal: MNGNAtiveObject? = nil
     var infeedView : UIView!
     var heightInfeed :CGFloat = 0
    
    init() {
        super.init(nibName: "TestMFViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    fileprivate func loadAds() {
        // Banner setup
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_BANNER_PLACEMENT_ID)"
        bannerFactory.bannerDelegate = self
        bannerFactory.viewController = self
        let preference = self.getTestPreferences()
        bannerFactory.loadBanner(inFrame: CGRect(x:0, y:60,width:self.view.frame.size.width,height: 50), withPreferences: preference)
        
//         infeed setup
        infeedFactory = MNGAdsSDKFactory()
        infeedFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_INFEED_PLACEMENT_ID)"
        infeedFactory.infeedDelegate = self
        infeedFactory.viewController = self
        let frameInfeed : MAdvertiseInfeedFrame = MAdvertiseInfeedFrame.init(widthDP: self.view.frame.size.width, andInfeedRatio: INFEED_RATIO_16_9)
        infeedFactory.loadInfeed(in: frameInfeed, withPreferences: preference)
        
        // Do any additional setup after loading the view.
        
        
        
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
        interstitialAdsFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID)"
        interstitialAdsFactory.loadInterstitial(withPreferences: preference, autoDisplayed: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        MNGAdsSDKFactory.initWithAppId("2334616")
        self.inFeedTableView.delegate = self
        self.inFeedTableView.dataSource = self
        let nib :UINib = UINib.init(nibName: "NativeAdTableViewCell", bundle: nil)
        inFeedTableView.register(nib, forCellReuseIdentifier: "nativeCell")
        loadAds()
    }

    @IBAction func openMenu(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerViewController?.openMenu()
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
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        adView.frame = CGRect(x:0, y:self.view.frame.size.height - 50,width:self.view.frame.size.width,height: 50)
        self.view.addSubview(adView)
    }
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        
    }

    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, infeedDidLoad adView: UIView!, preferredHeight: CGFloat) {
        heightInfeed = preferredHeight
        adView.frame = CGRect.init(x: 0, y: 0, width: adView.frame.size.width, height: preferredHeight)
        infeedView = adView
        self.inFeedTableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
    }
     func adsAdapter(_ adsAdapter: MNGAdsAdapter!, infeedDidFailWithError error: Error!) {
        infeedView = nil
        loadNativeAd()
        self.inFeedTableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 10
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 2:
            let cell : UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "")
            if (infeedView != nil) {
                infeedView .removeFromSuperview()
                infeedView.autoresizingMask = .flexibleHeight
                infeedView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: heightInfeed)
                cell.addSubview(infeedView)
            }else{
               let cellNative : NativeAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "nativeCell", for: indexPath) as! NativeAdTableViewCell
                if (self.nativeObjectlocal != nil) {
                    cellNative.initWithNative(nativeObject: nativeObjectlocal!)
                    return cellNative
                }

            }
            
            cell.selectionStyle = .none
            return cell
        default:
            
        var cell2 = tableView.dequeueReusableCell(withIdentifier: "x")
        if (cell2 != nil) {
            return cell2!
            }
        cell2 = UITableViewCell.init(style: .default, reuseIdentifier: "x")
        let imageView :UIImageView = UIImageView.init(image: UIImage.init(named: "article"))
        imageView.frame =  CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        cell2!.addSubview(imageView)
        return cell2!
        }
    
         
      }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            if infeedView != nil {
                return self.view.frame.size.width * (3/5)
            }else if (self.nativeObjectlocal != nil ){
                return  380
            }
            return 0
        }else {
              return 60;
        }
        
    }
    @IBAction func relaodBtnPressed(_ sender: Any) {
         loadAds()
    }
    func loadNativeAd() {
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_NATIVEAD_PLACEMENT_ID)"
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.clickDelegate = self
        nativeAdFactory.viewController = self
        let preferences = self.getTestPreferences()
        nativeAdFactory.loadNative(withPreferences: preferences)
        
    }
    
    // MARK: - MNGAdsAdapterNativeDelegate
       
       func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad nativeObject: MNGNAtiveObject!) {
        self.nativeObjectlocal = nativeObject
       self.inFeedTableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
       }
       
       func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool){
           NSLog("\(String(describing: error))")
        self.nativeObjectlocal = nil
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
