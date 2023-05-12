//
//  FourInOneViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 19/8/2022.
//

import UIKit
import BlueStackSDK

class FourInOneViewController: UIViewController ,MNGAdsAdapterBannerDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate, UITableViewDelegate, UITableViewDataSource {
  

    
    //MARK: -UI Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerContainer: UIView!
    
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nativeAdView: UIView!
    
    @IBOutlet weak var nativeAdIcon: UIImageView!
    
    @IBOutlet weak var nativeAdTitle: UILabel!
    
    @IBOutlet weak var nativeAdBody: UILabel!
    
    @IBOutlet weak var nativeAdCallToAction: UIButton!
    
    @IBOutlet weak var nativeAdBadgeContainer: UIView!
    
    
    @IBOutlet weak var nativeAdConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: -Factories
    var bannerFactory: MNGAdsSDKFactory!
    var squareFactory: MNGAdsSDKFactory!
    var nativeAdFactory: MNGAdsSDKFactory!
    var interstitialAdsFactory: MNGAdsSDKFactory!
    
    //MARK: -Views
    var bannerView : UIView?
    var squareView : UIView?
    var nativeObject : MNGNAtiveObject?
    var bannerHeight : CGFloat = 0.0
    
    
    //MARK: Variables
    var elementNbr : Int = 0
    
    
    //MARK: -View didload
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.simulateCallWS()
        self.createInterstitial()
    }
    
    //MARK: -WS Simulation
    func simulateCallWS() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            self.elementNbr = 40
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
            self.createSquare()
        }
    }

  
    //MARK: -OPEN Menu
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    
    //MARK: -Banner
    func createBanner() {
        bannerFactory = MNGAdsSDKFactory()
        bannerFactory.bannerDelegate = self
        bannerFactory.viewController = self
        bannerFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_BANNER_PLACEMENT_ID)"
        bannerFactory.loadBanner(inFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:50))
    }
    
    //MARK: -Square
    func createSquare(){
        squareFactory = MNGAdsSDKFactory()
        squareFactory.bannerDelegate = self
        squareFactory.viewController = self
        squareFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_DYNAMICAD_PLACEMENT_ID)"
        squareFactory.loadBanner(inFrame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 50))
        
    }
    
    //MARK: -Banner Delegate
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        NSLog("adsAdapterBannerDidLoad:");
        if adsAdapter == bannerFactory {
            bannerView = adView
            adView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: preferredHeight)
            self.bannerContainer.addSubview(adView)
            UIView.animate(withDuration: 0.3) {
                self.bannerHeightConstraint.constant = preferredHeight
                self.view.layoutIfNeeded()
            }
            self.createNativeAd()
        } else {
            squareView = adView
            bannerHeight = preferredHeight
            self.tableView.reloadRows(at:[IndexPath(row: 7, section: 0)] , with: .automatic)
        }
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidChangeFrame frame: CGRect) {
        bannerHeight = frame.size.height
        self.tableView.reloadRows(at:[IndexPath(row: 2, section: 0)] , with: .automatic)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        print("error \(String(describing: error))")
        if adsAdapter == bannerFactory {
            self.createNativeAd()
        }
    }
    
    
    
    //MARK: -Interstitial
    func createInterstitial()  {
       interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory.interstitialDelegate = self
        interstitialAdsFactory.viewController = self
        interstitialAdsFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID)"
        interstitialAdsFactory.loadInterstitial()
    }
    
    //MARK: -Interstitial Delegate
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad");
        self.createBanner()
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear");
    }
    
    func adsAdapterInterstitialDidShown(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidShown");
    }
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        print("Inters Error didfail \(String(describing: error))");
        self.createBanner()
    }
    
    //MARK: -Native Ad
    func createNativeAd(){
        
        nativeAdFactory = MNGAdsSDKFactory()
        nativeAdFactory.nativeDelegate = self
        nativeAdFactory.viewController = self
        nativeAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_NATIVEAD_PLACEMENT_ID)"
        nativeAdFactory.loadNative()
    }
    
    //MARK: -Native Ad Delegate
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad adView: MNGNAtiveObject!) {
        
        nativeObject = adView
        self.nativeAdTitle.text = nativeObject?.title
        self.nativeAdBody.text = nativeObject?.body
        
        if (nativeObject?.badgeView != nil) {
            self.nativeAdBadgeContainer.addSubview(nativeObject!.badgeView)
        }
        
        // download images
        self.nativeAdIcon.image = nil
        self.nativeAdIcon.layer.cornerRadius = 9
        self.nativeAdIcon.clipsToBounds = true
        
        
        self.nativeAdCallToAction.setTitle(self.nativeObject?.callToAction, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.nativeAdConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
        if self.nativeObject?.displayType == MNGDisplayType.appInstall {
            self.nativeAdCallToAction.setImage(#imageLiteral(resourceName: "download"), for: UIControl.State())
        }else if self.nativeObject?.displayType == .content {
            self.nativeAdCallToAction.setImage(#imageLiteral(resourceName: "arrow"), for: UIControl.State())
        }
        self.nativeAdCallToAction.titleLabel?.textAlignment = .center
        
        self.nativeObject!.registerView(forInteraction: self.nativeAdView, withMediaView: self.nativeAdBadgeContainer, withIconImageView: self.nativeAdIcon, with: self, withClickableView: self.nativeAdView)
        
        adsAdapter.releaseMemory()
    }
    
   
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool) {
        print("error \(String(describing: error))")
        adsAdapter.releaseMemory()
    }
 
    
    
    //MARK: - UITableView Delegate / Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return elementNbr
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 7 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "")
            if cell != nil {
                return cell!
            }
            cell = UITableViewCell(style: .default, reuseIdentifier: "")
            if squareView != nil {
                squareView?.removeFromSuperview()
                squareView?.autoresizingMask = [.flexibleHeight]
                squareView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: cell!.frame.size.height)
                cell?.contentView.addSubview(squareView!)
                
            }
            return cell!
        } else {
            
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "1")
                if cell != nil {
                    return cell!
                }
                cell = UITableViewCell(style: .default, reuseIdentifier: "1")
                cell?.textLabel?.text   = "Best practice Mngads : optimized use case for several ad formats on one page."
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell!
            }
            var cell = tableView.dequeueReusableCell(withIdentifier: "x")
            if cell != nil {
                return cell!
            }
            cell = UITableViewCell(style: .default, reuseIdentifier: "x")
            let image = UIImageView(image: UIImage(named: "article"))
            image.autoresizingMask = [.flexibleHeight , .flexibleWidth ]
            image.frame = cell!.bounds
            cell!.contentView.addSubview(image)
            return cell!
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            if squareView != nil {
                return bannerHeight
            }
            return 0
        } else {
            return 60
        }
    }
    

}
