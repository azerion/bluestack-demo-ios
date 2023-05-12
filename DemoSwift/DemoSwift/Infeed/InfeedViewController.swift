//
//  InfeedViewController.swift
//  DemoSwift
//
//  Created by HtrimechMac on 07/06/2021.
//

import UIKit
import BlueStackSDK

class InfeedViewController:  UIViewController , UITableViewDelegate, UITableViewDataSource , MNGAdsSDKFactoryDelegate, MNGAdsAdapterInfeedDelegate   {
     
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    let infeedRow = 6

    var infeedFactory: MNGAdsSDKFactory?
    var infeedView : UIView?
    var  myString = "cell"
    
    var index : Int = 0
    
    @IBOutlet weak var infeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Register the table view cell class and its reuse id
        infeedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        infeedTableView.delegate = self
        infeedTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         loadInfeed()

    }
    
    @IBAction func reloadInfeed(_ sender: Any) {
        loadInfeed()
    }
    // MARK: - Infeed
    func loadInfeed()  {
        if infeedView != nil {
            infeedView?.removeFromSuperview()
            infeedView = nil
            infeedTableView.reloadData()
            
        }
        infeedFactory = MNGAdsSDKFactory()
        infeedFactory?.placementId = "/\(MNG_ADS_APP_ID!)\( DemoSwiftConstants.PLACEMENTS.MNG_ADS_INFEED_PLACEMENT_ID)"
        infeedFactory?.infeedDelegate = self
        infeedFactory?.viewController = self
        let infeedFrame = MAdvertiseInfeedFrame(widthDP: self.view.frame.size.width, andInfeedRatio:INFEED_RATIO_16_9)
        infeedFactory?.loadInfeed(in: infeedFrame, withPreferences: nil)
    }
    
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, infeedDidLoad adView: UIView!) {
          print("infeed loaded")
          infeedView = adView
        infeedView!.frame = CGRect(x:(self.view.bounds.size.width - infeedView!.bounds.size.width )/2, y: 0, width: infeedView!.frame.size.width, height: infeedView!.frame.size.height)
        //refresh the indexPath
        let indexPath = IndexPath(row: infeedRow, section: 0)
        infeedTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, infeedDidFailWithError error: Error!) {
        print(error as Any)
        if infeedView != nil {
            infeedView?.removeFromSuperview()
            infeedView = nil
            infeedTableView.reloadData()
        }
            
    }
    
    
     // MARK: - Actions
    
    @IBAction func returnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableView Delegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == infeedRow {
            
            if infeedView != nil {
                infeedView!.removeFromSuperview()
                let cell:UITableViewCell =  UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                cell.contentView.clipsToBounds  = true
                cell.contentView.addSubview(infeedView!)
                cell.selectionStyle = .none
                return cell
            }
            
        }
        
        
        // create a new cell if needed or reuse an old one
//        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        let cell:UITableViewCell =  UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        // set the text from the data model
        cell.textLabel?.text = "Test Infeed"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == infeedRow {
            if infeedView != nil {
                return self.view.frame.size.width * (3/5)
            }else {
                return 0
            }
            
        }else {
            return 60
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == infeedRow {
//            if infeedView != nil {
//                return self.view.frame.size.width * (3/5)
//            }else {
//                return 0
//            }
//
//        }else {
//            return 60
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func openMenu(_ sender: Any) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    func dealloc()  {
        infeedFactory?.releaseMemory()
        infeedView = nil
    }
}
