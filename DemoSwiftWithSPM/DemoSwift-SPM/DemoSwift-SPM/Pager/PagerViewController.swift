//
//  PagerViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 19/8/2022.
//

import UIKit
import BlueStackSDK

class PagerViewController: UIViewController , UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
   
    
    @IBOutlet weak var pageContainerView: UIView!
    
    var pageViewController : UIPageViewController?
    
    var pagersArrayViewControllers: [UIViewController] = [PagerNativeViewController(), InfeedViewController(), PagerNativeViewController(),PagerNativeViewController(),PagerNativeViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPager()
        self.setUpPageControl()
    }


    func createPager()  {
        pageViewController  = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        
        if let firstVC = pagersArrayViewControllers.first , let pagerVC = firstVC as? PagerNativeViewController {
            pagerVC.index = 0
            pagerVC.view.frame = CGRect(x: 0, y: 0, width: pageContainerView.frame.size.width, height: pageContainerView.frame.size.height)
            pageViewController?.setViewControllers([pagerVC], direction: .forward, animated: true, completion: nil)
            pageViewController?.view.backgroundColor = .clear
            pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.pageContainerView.frame.size.width, height: self.pageContainerView.frame.size.height)
            self.pageContainerView.addSubview(pageViewController!.view)
            self.addChild(pageViewController!)
            pageViewController?.didMove(toParent: self)
        }
        
        
    }
    
    func setUpPageControl()  {
        let appearence = UIPageControl.appearance(whenContainedInInstancesOf: [PagerViewController.self])
        appearence.pageIndicatorTintColor = .lightGray
        appearence.currentPageIndicatorTintColor = .black
        appearence.backgroundColor = .clear
        appearence.frame = CGRect.zero
        
    }
    
    // MARK: - Pager delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pagersArrayViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pagersArrayViewControllers.count > previousIndex else {
            return nil
        }
        
        return pagersArrayViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pagersArrayViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pagersArrayViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        if pagersArrayViewControllers[nextIndex] is PagerNativeViewController {
            let pagerVC = pagersArrayViewControllers[nextIndex] as! PagerNativeViewController
            pagerVC.index = nextIndex
        }
        
        return pagersArrayViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Menu open
    
    @IBAction func openMenu(_ sender: UIButton) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    
    
}
