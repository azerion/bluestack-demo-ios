//
//  MenuViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 17/8/2022.
//

import UIKit

class MenuViewController: UIViewController {

    
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollview.contentSize = CGSize(width: DemoSwiftConstants.menuSize, height: 925)
    }


    // MARK: - Navigation
    
    
    @IBAction func openInfeedViewController(_ sender: UIButton) {
        
        APP_DELEGATE.drawerViewController?.closeMenu()
        let  infeedVC:   InfeedViewController = InfeedViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([infeedVC], animated: false)
        
    }
    
    @IBAction func openNativeAdViewController(_ sender: UIButton) {
        
        APP_DELEGATE.drawerViewController?.closeMenu()
        let nativeAdVC  = NativeAdViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([nativeAdVC], animated: false)
        
    }
    
    
    @IBAction func openInterstitialViewController(_ sender: UIButton) {
        
        APP_DELEGATE.drawerViewController?.closeMenu()
        let interstitialVC  = InterstitialViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([interstitialVC], animated: false)
    }
    
    
    
    @IBAction func openBannerViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let bannerVC  = BannerViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([bannerVC], animated: false)
    }
    
    @IBAction func openTestMFViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let testMFVC  = TestMFViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([testMFVC], animated: false)
    }
    
    @IBAction func openMASViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let masVC  = MASViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([masVC], animated: false)
    }
    
 
    
    @IBAction func openThumbnailViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let ThumbnailVC  = ThumbnailViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([ThumbnailVC], animated: false)
    }
    
    
    @IBAction func openRewardedVideoViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let RewardedVC  = RewardedVideoViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([RewardedVC], animated: false)
    }
    
    
    @IBAction func openFourInOneViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let FourInOneVC  = FourInOneViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([FourInOneVC], animated: false)
    }
    
    
    @IBAction func openSettingsViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let SettingsVC  = SettingsViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([SettingsVC], animated: false)
    }
    
    @IBAction func openPagerViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let pagerVC  = PagerViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([pagerVC], animated: false)
    }
    
    @IBAction func openAppsfireViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let appsfireVC  = AppsfireViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([appsfireVC], animated: false)
    }
    
    
    @IBAction func openCarousselViewController(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.closeMenu()
        let carousselVC  = CarousselViewController()
        APP_DELEGATE.appDelegateNavigationController?.setViewControllers([carousselVC], animated: false)
    }
    
    
    
    
    
    
    
}
