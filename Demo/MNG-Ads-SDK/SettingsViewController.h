//
//  SettingsViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Bensalah Med Amine on 16/12/2016.
//  Copyright © 2016 MAdvertise. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SettingsViewController : UIViewController <CMPConsentManagerDelegate,UITextViewDelegate,MNGAdsSDKFactoryDelegate>
- (IBAction)OpenMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *appidTextField;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;
- (IBAction)submit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *tcfTextView;
@property (weak, nonatomic) IBOutlet UITextView *idfaTextView;

@property (weak, nonatomic) IBOutlet UITextView *GoogleConsentTextview;
@property (weak, nonatomic) IBOutlet UITextView *externalPurposeId;
@property (weak, nonatomic) IBOutlet UITextField *cmpLanguageTextField;
@property (weak, nonatomic) IBOutlet UITextView *purposeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *updateexternalSwitch;
@property (weak, nonatomic) IBOutlet UITextField *idExtPurposetextField;
@property (weak, nonatomic) IBOutlet UITextField *externalVendorsTextfield;

@property (weak, nonatomic) IBOutlet UITextField *vendorsTexTfield;


@end

