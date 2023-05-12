//
//  ThumbnailViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import UIKit
import BlueStackSDK

class ThumbnailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,BluestackThumbnailAdDelegate {
  
    
    
    @IBOutlet weak var xMarginTextField: UITextField!
    
    @IBOutlet weak var yMarginTextField: UITextField!
    
    @IBOutlet weak var thumbnailTableView: UITableView!
    
    var thumbnailAdFactory: MNGAdsSDKFactory!
    var position : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thumbnailTableView.delegate = self
        self.thumbnailTableView.dataSource = self
        //init values textfields
        self.xMarginTextField.text = "20"
        self.yMarginTextField.text = "250"
        //init factory
        thumbnailAdFactory  = MNGAdsSDKFactory()
    }

    // MARK: - Open Menu
    
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    //MARK: - buttons actions
    
    @IBAction func topLeftPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        position = 1
        thumbnailAdFactory.thumbnailAdDelegate = self
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID)"
        let preferences = self.getTestPreferences()
        preferences.preferredThumbnailAdChoicePosition = .adChoiceTopLeft
        thumbnailAdFactory.loadThumbnailAd(inMaxWidth: 300, withMaxHeight: 300, withPreferences: preferences)
    }
    
    
    @IBAction func topRightPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        position = 2
        thumbnailAdFactory.thumbnailAdDelegate = self
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID)"
        let preferences = self.getTestPreferences()
        preferences.preferredThumbnailAdChoicePosition = .adChoiceTopRight
        thumbnailAdFactory.loadThumbnailAd(inMaxWidth: 300, withMaxHeight: 300, withPreferences: preferences)
    }
    
    @IBAction func bottomLeftPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        position = 3
        thumbnailAdFactory.thumbnailAdDelegate = self
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID)"
        let preferences = self.getTestPreferences()
        preferences.preferredThumbnailAdChoicePosition = .adChoiceBottomLeft
        thumbnailAdFactory.loadThumbnailAd(inMaxWidth: 300, withMaxHeight: 300, withPreferences: preferences)
        
    }
    
    
    @IBAction func reloadThumbnailPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        position = 0
        thumbnailAdFactory.thumbnailAdDelegate = self
        thumbnailAdFactory.viewController = self
        thumbnailAdFactory.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_THUMBNAIL_PLACEMENT_ID)"
        let preferences = self.getTestPreferences()
        thumbnailAdFactory.loadThumbnail(withPreferences: preferences)
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
    
    //MARK: - Thumbnail Delegate
    
    func adsAdapterThumbnailAdAdLoaded(_ adsAdapter: MNGAdsAdapter!) {
        self.view.endEditing(true)
        let preferences = self.getTestPreferences()
        switch position {
        case 0:
            thumbnailAdFactory.showThumbnail()
            return
        case 1 :
            preferences.preferredThumbnailAdChoicePosition = .adChoiceTopLeft
            break
        case 2 :
            preferences.preferredThumbnailAdChoicePosition = .adChoiceTopRight
            break
        case 3 :
            preferences.preferredThumbnailAdChoicePosition = .adChoiceBottomLeft
            break
        default:
            break
        }
        
        var xmarginText = 120
        var  ymarginText = 120
        
        if self.xMarginTextField.text != nil {
             xmarginText = Int(self.xMarginTextField.text!) ?? 120
        }
        
        if self.yMarginTextField.text != nil {
            ymarginText = Int(self.yMarginTextField.text!) ?? 120
        }
        
        thumbnailAdFactory.showThumbnail(inGravity: preferences, inXMargin: CGFloat(xmarginText), inyMargin: CGFloat(ymarginText))
    }
    
    func adsAdapterThumbnailAdAdError(_ adsAdapter: MNGAdsAdapter!, withError error: Error!) {
        NSLog("error \(String(describing: error))")
    }
    
    func adsAdapterThumbnailAdAdClicked(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    
    func adsAdapterThumbnailAdAdClosed(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    func adsAdapterThumbnailAdAdDisplayed(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    
    //MARK: - UITableView Delegate / Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
}
