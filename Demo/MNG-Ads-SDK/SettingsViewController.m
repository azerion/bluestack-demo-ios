//
//  SettingsViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Bensalah Med Amine on 16/12/2016.
//  Copyright © 2016 MAdvertise. All rights reserved.
//

#import "SettingsViewController.h"
@import MAdvertiseCMP;
#import <AdSupport/ASIdentifierManager.h>
@interface SettingsViewController  ()
@property (weak, nonatomic) IBOutlet UITextField *consentFlagTextfiled;

@end

@implementation SettingsViewController {
    AVPlayer *avPlayerq;
    AVPlayerLayer *videoLayer ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appidTextField.text = MNG_ADS_APP_ID;
    self.debugSwitch.on = DEBUG_MODE_ENABLED;
    _tcfTextView.delegate = self;
    _idfaTextView.delegate = self ;
    
    NSNumber * consentFlag = MNG_ADS_ConsentFlag ;
    _consentFlagTextfiled.text = [NSString stringWithFormat:@"%@",[consentFlag stringValue] ] ;
    _tcfTextView.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_TCString"];
    _idfaTextView.text = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    _GoogleConsentTextview.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_AddtlConsent"];
    [self getExternalPurposes];
    [self getPurposes];
    [self debugAllIabTcfKeyCache] ;
    _cmpLanguageTextField.text = CMP_LANGUAGE ;
    CMPConsentManager.sharedInstance.delegate = self;
   
    
    _vendorsTexTfield.text = @"746,755";
    _externalVendorsTextfield.text = @"8,9";
    _idExtPurposetextField.text = @"5";
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString  * madvertiseconsentProvided = [[NSUserDefaults standardUserDefaults]objectForKey:@"madvertiseconsentProvided"];
    [Utils displayToastWithMessage:madvertiseconsentProvided];
}
-(void)viewDidAppear:(BOOL)animated {
    APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)consentManagerRequestsToShowConsentTool:(CMPConsentManager * _Nonnull)consentManager forVendorList:(CMPVendorList * _Nonnull)vendorList {
    if ([CMPConsentManager.sharedInstance showConsentToolFromController:self withPopup:YES]) {
    }
}

-(void)tcfOnConsentStringDidChange:(TCFString *)newTcfConsentString consentProvided:(NSString *)consentProvided {
    NSLog(@"------> Consent String changed : %@", newTcfConsentString.tcfString);
//    NSLog(@"------> consentProvided changed : %@", consentProvided);

    [Utils displayToastWithMessage:consentProvided];

    _tcfTextView.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_TCString"];
    _GoogleConsentTextview.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_AddtlConsent"];
    [self getExternalPurposes];
    [self debugAllIabTcfKeyCache] ;
    [self getPurposes];
    
}

-(void)didAcceptAllTcfConsentString{
     [Utils displayToastWithMessage:@"didAcceptAllTcfConsentString"];
    
}
-(void)didRefuseAllTcfConsentString{
     [Utils displayToastWithMessage:@"didRefuseAllTcfConsentString"];
    
}
-(void)consentManagerDidFailWithErrorWithError:(NSError *)error{
    [Utils displayToastWithMessage:error.localizedDescription];
    NSLog(@"------> consentManagerDidFailWithErrorWithError : %@", error.localizedDescription);

}
- (void)consentManagerRequestsToPresentPrivacyPolicyWithUrl:(NSString*)url{
    [Utils displayToastWithMessage:url];
}
- (IBAction)gdprsettings:(UIButton*)sender {
    if (sender.tag == 0) {
          if ([CMPConsentManager.sharedInstance showConsentToolFromController:self withPopup:NO]) {
            APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;
        }
      
    } else if (sender.tag == 1) {
          if ([CMPConsentManager.sharedInstance showConsentToolFromController:self withPopup:YES]) {
                    APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;

        }
    }
    
}


- (IBAction)OpenMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}
- (IBAction)submit:(id)sender {
    [self.appidTextField endEditing:YES];
    [self.cmpLanguageTextField endEditing:YES];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:[_consentFlagTextfiled.text intValue]]
                                             forKey:@"ConsetFlagBlueSTack"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *newAppId = self.appidTextField.text;
    if (!newAppId || [newAppId isEqualToString:@""]) {
        NSLog(@"put a valid appId");
        return;
    }
    
  
    NSString * oldAppId = [[NSUserDefaults standardUserDefaults] objectForKey: @"SavedappId" ];
    if (![newAppId isEqualToString:oldAppId]) {
        [[NSUserDefaults standardUserDefaults]setObject:newAppId
                                                 forKey:@"SavedappId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [MNGAdsSDKFactory setDelegate:self];
        [MNGAdsSDKFactory initWithAppId:newAppId];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@(self.debugSwitch.on)
                                             forKey:@"SavedDebug"];
    [[NSUserDefaults standardUserDefaults]setObject:_cmpLanguageTextField.text
                                             forKey:@"CMP_LANGUAGE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [MNGAdsSDKFactory setDebugModeEnabled:DEBUG_MODE_ENABLED];
    
}

-(void)MNGAdsSDKFactoryDidFinishInitializing{
    NSLog(@"MNGAds sucess initialization");
  
    [Utils displayToastWithMessage:@"MNGAds sucess initialization"];

}

-(void)MNGAdsSDKFactoryDidFailInitializationWithError:(NSError *)error {
    NSLog(@"MNGAds failed initialization");
    [Utils displayToastWithMessage:@"MNGAds failed initialization"];
}

- (IBAction)AcceptAllPressed:(id)sender {
    [CMPConsentManager.sharedInstance acceptAllConsentTool];
        NSLog(@"------> Consent String ALL Accepted : %@",  [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_TCString"]);
    
     _GoogleConsentTextview.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_AddtlConsent"];
     [self getExternalPurposes];
   [self debugAllIabTcfKeyCache] ;
    [self getPurposes];

    
}
- (IBAction)refuseAllPressed:(id)sender {
    [CMPConsentManager.sharedInstance refuseAllConsentTool];
     NSLog(@"------> IABTCF_TCString : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_TCString"]);
     _GoogleConsentTextview.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_AddtlConsent"];
     [self getExternalPurposes];
    [self debugAllIabTcfKeyCache] ;
    [self getPurposes];
}


-(void)debugAllIabTcfKeyCache{
    
    NSLog(@"------> IABTCF_CmpSdkID : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_CmpSdkID"]);
    
    
    NSLog(@"------> IABTCF_CmpSdkVersion : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_CmpSdkVersion"]);
    
    NSLog(@"------> IABTCF_PolicyVersion : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PolicyVersion"]);
    
     NSLog(@"------> IABTCF_gdprApplies : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_gdprApplies"]);
    
     NSLog(@"------> IABTCF_PublisherCC : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherCC"]);
    
     NSLog(@"------> IABTCF_PurposeOneTreatment : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PurposeOneTreatment"]);
    
     NSLog(@"------> IABTCF_UseNonStandardStacks : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_UseNonStandardStacks"]);
    
     NSLog(@"------> IABTCF_VendorConsents : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_VendorConsents"]);
    
     NSLog(@"------> IABTCF_VendorLegitimateInterests : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_VendorLegitimateInterests"]);
    
    NSLog(@"------> IABTCF_PurposeConsents : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PurposeConsents"]);
    
    NSLog(@"------> IABTCF_PurposeLegitimateInterests : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PurposeLegitimateInterests"]);
    
    NSLog(@"------> IABTCF_SpecialFeaturesOptIns : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_SpecialFeaturesOptIns"]);
    
    NSLog(@"------> IABTCF_PublisherConsent : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherConsent"]);
    
     NSLog(@"------> IABTCF_PublisherRestrictions1 : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherRestrictions1"]);
    
     NSLog(@"------> IABTCF_PublisherRestrictions2 : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherRestrictions2"]);
    
     NSLog(@"------> IABTCF_PublisherRestrictions3 : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherRestrictions3"]);
    
     NSLog(@"------> IABTCF_PublisherRestrictions4 : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherRestrictions4"]);
    
    NSLog(@"------> IABTCF_PublisherRestrictions5 : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_PublisherRestrictions5"]);
    
    NSLog(@"------> IABTCF_Madvertise_ExternalVendors : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_Madvertise_ExternalVendors"]);
    
     NSLog(@"------> IABTCF_TCString : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"IABTCF_TCString"]);

}


- (void)getExternalPurposes {
    NSArray * purposeIDs =    [CMPConsentManager.sharedInstance getExternalPurposesIDs];
    
    _externalPurposeId.text = [NSString stringWithFormat:@"%@",[purposeIDs description]];
}

- (IBAction)showExternalPurposes:(id)sender {
    [self getExternalPurposes];
}
- (IBAction)showPurposeIDs:(id)sender {
    [self getPurposes];

}

- (void)getPurposes {
    NSArray * purposeIDs =    [CMPConsentManager.sharedInstance getPurposesIDs];

    _purposeTextField.text = [NSString stringWithFormat:@"%@",[purposeIDs description]];
    
}
- (NSArray*)getIdsFromString:(NSString *)input {
    NSMutableArray * idArray = [[NSMutableArray alloc]init];
    if (input.length != 0 ){
        NSArray *arrayOfComponents = [input componentsSeparatedByString:@","];
        if (arrayOfComponents.count != 0) {
            for (int i = 0 ; i < arrayOfComponents.count; i++) {
                if ([arrayOfComponents[i] intValue] != 0) {
                    [idArray addObject:[NSNumber numberWithInt:[arrayOfComponents[i] intValue]]];
                }
            }
        }
    }
    
    
    return idArray;
}

- (IBAction)updateExtenalPurposes:(id)sender {
    
    NSArray *arrayOfvendor=[self getIdsFromString:_vendorsTexTfield.text];
    NSArray *arrayOfExternalVendor=[self getIdsFromString:_externalVendorsTextfield.text];
    NSArray *arrayOfExternalPurpose =[self getIdsFromString:_idExtPurposetextField.text];

    [CMPConsentManager.sharedInstance updateExternalPurposesIDs:arrayOfExternalPurpose vendors:arrayOfvendor externalvendors:arrayOfExternalVendor type:_updateexternalSwitch.isOn];
    [self debugAllIabTcfKeyCache];

    [self.view endEditing:YES];

}


@end
