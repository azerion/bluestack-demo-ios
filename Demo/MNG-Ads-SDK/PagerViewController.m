//
//  PagerViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 1/13/17.
//  Copyright © 2017 MNG. All rights reserved.
//

#import "PagerViewController.h"
#import "InfeedViewController.h"

@interface PagerViewController () {
    UIPageViewController *pageViewController;
}

@end

@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createPageViewController];
    [self setUpPageControl];
}

- (void)createPageViewController {
    pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    PagerNativeViewController *firstVC = [[PagerNativeViewController alloc]initWithNibName:@"PagerNativeViewController" bundle:nil];
    firstVC.index = 0 ;
    [firstVC.view setFrame:CGRectMake(0, 0, _pageContainerView.frame.size.width, _pageContainerView.frame.size.height)];
    NSArray *startingVCs = [[NSArray alloc]initWithObjects:firstVC, nil];
    [pageViewController setViewControllers:startingVCs
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:false
                                completion:nil];
    [self addChildViewController:pageViewController];
    [_pageContainerView addSubview:pageViewController.view];
    [pageViewController.view setFrame:CGRectMake(0, 0, _pageContainerView.frame.size.width, _pageContainerView.frame.size.height)];
    [pageViewController didMoveToParentViewController:self];
    
}

- (void)setUpPageControl {
    
    UIPageControl *appearance = [UIPageControl
                                 appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:PagerViewController.class, nil]];
    [appearance setPageIndicatorTintColor: [UIColor lightGrayColor]];
    [appearance setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [appearance setBackgroundColor:[UIColor clearColor]];
    [appearance setFrame:CGRectZero];
}

#pragma mar - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(PagerNativeViewController *)viewController {
    if (viewController.index == 0) return nil;
    if (viewController.index == 2) {
        InfeedViewController *vc = [[InfeedViewController alloc]init];
        vc.index = viewController.index - 1;
        return vc;
    }else{
        PagerNativeViewController *previousVC = [[PagerNativeViewController alloc]initWithNibName:@"PagerNativeViewController" bundle:nil];
        previousVC.index = viewController.index - 1;
        return previousVC;
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(PagerNativeViewController *)viewController {
    if (viewController.index == 4) return nil;
    if (viewController.index == 0) {
        InfeedViewController *vc = [[InfeedViewController alloc]init];
        vc.index = viewController.index + 1;
        return vc;
    }else{
        PagerNativeViewController *nextVC = [[PagerNativeViewController alloc]initWithNibName:@"PagerNativeViewController" bundle:nil];
        nextVC.index = viewController.index + 1;
        return nextVC;
    }
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (IBAction)openMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

@end
