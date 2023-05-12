//
//  CarousselViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 22/8/2022.
//

import UIKit
import BlueStackSDK

class CarousselViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, MNGAdsAdapterNativeCollectionDelegate ,MNGClickDelegate , UIScrollViewDelegate{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var carrouselScrollView : UIScrollView?
    
    var nativeCollectionAdsFactory: MNGAdsSDKFactory!
    var nativeWithcover : Bool = true
    var elementsList : [UIView] = []
    var nativeAdCount : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadCollectionNativeAd(cover: true)
    }
    
    
    
    //MARK: -load Collection nativeAd
    func loadCollectionNativeAd(cover : Bool)  {
        nativeCollectionAdsFactory = MNGAdsSDKFactory()
        nativeCollectionAdsFactory.nativeCollectionDelegate = self
        nativeCollectionAdsFactory.clickDelegate = self
        nativeCollectionAdsFactory.viewController = APP_DELEGATE.drawerViewController
        nativeCollectionAdsFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_NATIVEAD_PLACEMENT_ID)"
        let preferences = self.getTestPreferences()
        nativeCollectionAdsFactory.createNativeCollection(5, withPreferences: preferences, withCover: cover)
        print("numberofRunningFactories is \(MNGAdsSDKFactory.numberOfRunningFactory())")
    }
    
    //MARK: - get Preferences
    func getTestPreferences() ->MNGPreference {
        let preference = MNGPreference()
        preference.keyWord = "target=mngadsdemo;version=3.0.4;semantic=https://www.google.com"
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        preference.age = 60
        return preference
    }
    
    
    // MARK: - Open MENU
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    // MARK: - Buttons Actions
    @IBAction func loadCollectionWithCoverAction(_ sender: UIButton) {
        nativeWithcover = true
        self.loadCollectionNativeAd(cover: true)
    }
    
    @IBAction func loadCollectionWithoutCoverAction(_ sender: UIButton) {
        nativeWithcover = false
        self.loadCollectionNativeAd(cover: false)
    }
    
    
    //MARK: - UITableView Delegate / Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2  && carrouselScrollView != nil {
            
            let  cell = UITableViewCell(style: .default, reuseIdentifier: "")
            carrouselScrollView?.removeFromSuperview()
            carrouselScrollView?.autoresizingMask =  [.flexibleHeight]
            carrouselScrollView?.frame = CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: cell.frame.size.height)
            cell.contentView.addSubview(carrouselScrollView!)
            return cell
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2  && carrouselScrollView != nil{
            if nativeWithcover {
                return 250
            } else {
                return 100
            }
        } else {
            return 160
        }
        
    }
    
    
    //MARK: -Collection nativeAd
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeCollectionDidLoad adView: [Any]!) {
        NSLog("native collection did load")
        self.initScrollViewWithNativeCollection(nativeCollection: adView)
        //Reload tableview
        let indexPath = IndexPath(row: 2, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeCollectionDidFailWithError error: Error!) {
        NSLog("error \(String(describing: error))")
    }
    
    //MARK: -configure the scrollView
    func initScrollViewWithNativeCollection(nativeCollection : [Any]) {
        
        var heightScroll : CGFloat = 0.0
        if nativeWithcover {
            heightScroll = 250
        } else {
            heightScroll = 100
        }
        
        self.carrouselScrollView = UIScrollView(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width, height: heightScroll))
        
        self.carrouselScrollView?.isPagingEnabled = true
        self.carrouselScrollView?.bounces = false
        self.carrouselScrollView?.clipsToBounds = false
        self.carrouselScrollView?.delegate = self
        self.carrouselScrollView?.showsHorizontalScrollIndicator = false
        
        guard let nativeAdsCollection = nativeCollection as? [MNGNAtiveObject] else {
            return
        }
        nativeAdCount = nativeAdsCollection.count
        var x  = 0.0
        let margin = 10.0
        let width = self.view.frame.size.width - 30
        
        for nativeAd in nativeAdsCollection {
            let v = CarrouselNativeView (frame:CGRect(x: x, y: 0, width:width , height:  heightScroll))
           
            self.initView(v: v, withNativeObject: nativeAd)
            self.carrouselScrollView?.addSubview(v)
            x = x + width + margin
            elementsList.append(v)
            if nativeWithcover {
                nativeAd.registerView(forInteraction: v, withMediaView: v.backgroundImage, withIconImageView: v.iconeImage, with: APP_DELEGATE.drawerViewController, withClickableView: v)
            } else {
                nativeAd.registerView(forInteraction: v, withMediaView: nil, withIconImageView: v.iconeImage, with: APP_DELEGATE.drawerViewController, withClickableView: v)
            }
            //constraints to v
//            v.translatesAutoresizingMaskIntoConstraints = false
//            v.widthAnchor.constraint(equalToConstant: self.view.frame.width - 30).isActive = true
//            v.heightAnchor.constraint(equalToConstant: heightScroll).isActive = true
//            //constraints to carrouselScrollView
//            v.centerYAnchor.constraint(equalTo: self.carrouselScrollView!.centerYAnchor, constant: 0).isActive = true
//
//            v.bottomAnchor.constraint(equalTo: self.carrouselScrollView!.bottomAnchor, constant: 0).isActive = true
            
            
        }
        
        self.carrouselScrollView?.contentSize = CGSize(width: x, height: heightScroll)
        
    }
    
    func initView(v: CarrouselNativeView, withNativeObject nativeObject : MNGNAtiveObject) {
        v.backgroundImage.frame = v.frame
        v.titleLabel.text = nativeObject.title
        v.descriptionLabel.text = nativeObject.body
        v.iconeImage.layer.cornerRadius = 16
        v.iconeImage.clipsToBounds = true
        
        v.callToActionButton.setTitle(nativeObject.callToAction, for: .normal)
        if nativeObject.displayType == .appInstall {
            v.callToActionButton.setImage(UIImage(named: "download"), for: .normal)
        }else if nativeObject.displayType == .content {
            v.callToActionButton.setImage(UIImage(named: "arrow"), for: .normal)
        }
        
        v.callToActionButton.titleLabel?.textAlignment = .center
        
        let badgeView = nativeObject.badgeView
        if badgeView != nil {
            var frame = badgeView!.frame
            frame.origin.x = 3
            frame.origin.y = 3
            badgeView!.frame = frame
            v.addSubview(badgeView!)
        }
        
        let adChoiceBadgeView = nativeObject.adChoiceBadgeView
        if adChoiceBadgeView != nil {
            var frame = adChoiceBadgeView!.frame
            frame.origin.x = v.frame.size.width - frame.size.width - 3
            frame.origin.y = 3
            adChoiceBadgeView!.frame = frame
            adChoiceBadgeView?.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
            adChoiceBadgeView?.backgroundColor = .white
            v.addSubview(adChoiceBadgeView!)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.carrouselScrollView {
            return
        }
        
        let targetX = scrollView.contentOffset.x
        let targetIndex = targetX / ( scrollView.frame.size.width - 30)
        
        for i in 0 ..< nativeAdCount {
            let v = elementsList[i]
            var scale = 1 - (0.05*abs(CGFloat(i)-targetIndex));
            if (scale>1) {
                scale = 1;
            }else if(scale < 0.95){
                scale = 0.95;
            }
            var scaley = 1 - (0.25*abs(CGFloat(i)-targetIndex));
            if (scaley>1) {
                scaley = 1;
            }else if(scaley < 0.75){
                scaley = 0.75;
            }
            v.transform = CGAffineTransform(scaleX: scale, y: scaley);
        }
        
    }
    
}
