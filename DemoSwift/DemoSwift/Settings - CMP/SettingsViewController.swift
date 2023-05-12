//
//  SettingsViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 19/8/2022.
//

import UIKit
import MAdvertiseCMP
import BlueStackSDK

class SettingsViewController: UIViewController, CMPConsentManagerDelegate , MNGAdsSDKFactoryDelegate {
    
    
    @IBOutlet weak var appIdTextField: UITextField!
    
    
    @IBOutlet weak var consentFlagTextfield: UITextField!
    
    
    
    @IBOutlet weak var cmpLanguageTextField: UITextField!
    
    
    @IBOutlet weak var debugSwitch: UISwitch!
    
    
    @IBOutlet weak var updateExternalSwitch: UISwitch!
    
    
    @IBOutlet weak var idExtPurposeTextField: UITextField!
    
    
    @IBOutlet weak var externalVendorsTextField: UITextField!

    
    @IBOutlet weak var vendorsTextField: UITextField!
    
    
    static let consentStringKey = "IABTCF_TCString"
    static let madvertiseConsentStringKey = "MadvertiseConsent_ConsentString"
    
    var storedConsentString: String?
    var storedMadvertiseConsentString: String?
    

    @IBOutlet weak var tcfTextView: UITextView!
    
    @IBOutlet weak var idfaTextView: UITextView!
    @IBOutlet weak var googleTextView: UITextView!
    
    @IBOutlet weak var externalpurposesTextView: UITextView!
    
    
    @IBOutlet weak var purposeTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        
        CMPConsentManager.shared.delegate = self
        
        // Configure the CMPConsentManager shared instance.
        let cmpLanguage = CMPLanguage(string: "fr") ?? CMPLanguage.DEFAULT_LANGUAGE
        
        CMPConsentManager.shared.configure("MAdvertiseCMPSettingsTCFV2_config_fr", language: cmpLanguage, appId: DemoSwiftConstants.appID, publisherCC: "FR",autoClose:true)
        
        
        updateTextViews()
        self.idExtPurposeTextField.text = "5";
        self.externalVendorsTextField.text = "8,9";
        self.vendorsTextField.text = "746,755";
       
        
        //gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let madvertiseconsentProvided = UserDefaults.standard.object(forKey: "madvertiseconsentProvided") as? String
        APP_DELEGATE.displayToast(message: madvertiseconsentProvided ?? "")
    }
    
    //MARK: -setup textfields
    func setUpTextFields()  {
        //app Id
        self.appIdTextField.text = MNG_ADS_APP_ID
        //Debug Mode
        let debugOn = UserDefaults.standard.bool(forKey: "SavedDebug")
        self.debugSwitch.isOn = debugOn
        
        //Consent number
        self.consentFlagTextfield.text = String(format: "%d", MNG_ADS_ConsentFlag ?? 1)
        //CMP Language
        self.cmpLanguageTextField.text = MNG_ADS_CMPLanguage
        
        
    }
    
    fileprivate func updateTextViews() {
        tcfTextView.text = UserDefaults.standard.object(forKey: "IABTCF_TCString") as? String
        googleTextView.text = UserDefaults.standard.object(forKey: "IABTCF_AddtlConsent") as? String
        idfaTextView.text = UUID().uuidString
        getPurposes()
        getExternalPurpose()
        debugAllIabTcfKeyCache()
    }
    
    func getExternalPurpose()  {
        let purposeArray = CMPConsentManager.shared.getExternalPurposesIDs() as [Int]
        externalpurposesTextView.text = purposeArray.description
        
    }
    
    func getPurposes(){
        let purposeIds = CMPConsentManager.shared.getPurposesIDs() as [Int]
        purposeTextView.text = purposeIds.description
    }
    
    
    // MARK: - CMPConsentManagerDelegate
    
    func consentManagerRequestsToShowConsentTool(_ consentManager: CMPConsentManager, forVendorList vendorList: CMPVendorList) {
        NSLog("CMP Requested ConsentTool Display");
        
        // You should display the consent tool UI, when user is ready…
        let _ = consentManager.showConsentTool(fromController: self, withPopup: true)
        
        // Since the vendor list is provided in parameter of this delegate method, you can also build your own UI to ask for
        // user consent and simply save the resulting consent string in the relevant IAB keys (see the IAB specification for
        // more details about this).
        //
        // To generate a valid IAB consent string easily, you can use the CMPConsentString class.
    }
    
    func tcfOnConsentStringDidChange(_ newTcfConsentString: TCFString, consentProvided: String) {
        print("-------->TCFString did change")
        APP_DELEGATE.displayToast(message: consentProvided)
        updateTextViews()
    }
    
    
    func consentManagerDidFailWithError(error: Error) {
        APP_DELEGATE.displayToast(message: error.localizedDescription)
        NSLog("consentManagerDidFailWithErrorWithError \(error.localizedDescription)")
    }
    
    func consentManagerRequestsToPresentPrivacyPolicy(url: String) {
        APP_DELEGATE.displayToast(message: url)
    }
    // MARK: Show consent tool action
    
    @IBAction func showConsentToolButtonTapped(_ sender: UIButton) {
        // Showing the consent tool manually
        switch sender.tag {
        case 0:
            if !CMPConsentManager.shared.showConsentTool(fromController: self, withPopup: false) {
                
                // Note: showing the consent tool might fail for several reasons (check the API documentation for more information).
                // For better user experience, it is advised to display an error if the consent tool can't be opened when it has been
                // requested by the user.
                let alert = UIAlertController(title: "Service unavailable",
                                              message: "Setting your privacy preferences is not possible at the moment, please try again later",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
        case 1:
            if !CMPConsentManager.shared.showConsentTool (fromController: self, withPopup: true){
                
                // Note: showing the consent tool might fail for several reasons (check the API documentation for more information).
                // For better user experience, it is advised to display an error if the consent tool can't be opened when it has been
                // requested by the user.
                let alert = UIAlertController(title: "Service unavailable",
                                              message: "Setting your privacy preferences is not possible at the moment, please try again later",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            
        default:
            break
        }
        
    }
    
    @IBAction func acceptAllBtnPressed(_ sender: Any) {
        CMPConsentManager.shared.acceptAllConsentTool()
        updateTextViews()
        APP_DELEGATE.displayToast(message: "didAcceptAllTcfConsentString")
    }
    @IBAction func refuseAllBtnPressed(_ sender: Any) {
        CMPConsentManager.shared.refuseAllConsentTool()
        updateTextViews()
        APP_DELEGATE.displayToast(message: "didRefuseAllTcfConsentString")
    }
    @IBAction func showExternalPurposeBtnPressed(_ sender: Any) {
        getExternalPurpose()
    }
    
    
    
    @IBAction func showPurposesIDs(_ sender: UIButton) {
        self.getPurposes()
    }
    
    
    
    @IBAction func updateExternalPurposes(_ sender: UIButton) {
        
        let arrayOfExternalPurpose = self.getIdsFromString(input: self.idExtPurposeTextField.text!)
        let arrayOfExternalVendors = self.getIdsFromString(input: self.externalVendorsTextField.text!)
        let arrayOfVendors = self.getIdsFromString(input: self.vendorsTextField.text!)
        
        
        CMPConsentManager.shared.updateExternalPurposesIDs(arrayOfExternalPurpose, vendors: arrayOfVendors, externalvendors: arrayOfExternalVendors, type: self.updateExternalSwitch.isOn)
        self.debugAllIabTcfKeyCache()
        self.view.endEditing(true)
        
    }
    
    //MARK: - get Ids from textfields
    func getIdsFromString(input: String) ->[Int] {
        var result: [Int] = []
        if input.count > 0 {
            let arrayOfComponents = input.components(separatedBy: ",")
            for id in arrayOfComponents {
                result.append(Int(id)!)
            }
        }
        return result
    }
    
    func debugAllIabTcfKeyCache(){
        
        
        print("------> IABTCF_CmpSdkID :\(UserDefaults.standard.object(forKey: "IABTCF_CmpSdkID") ?? "IABTCF_CmpSdkID not found")");
        
        
        print("------> IABTCF_CmpSdkVersion :\(UserDefaults.standard.object(forKey: "IABTCF_CmpSdkVersion") ?? "IABTCF_CmpSdkVersion not found")");
        
        print("------> IABTCF_PolicyVersion :\(UserDefaults.standard.object(forKey: "IABTCF_PolicyVersion") ?? "IABTCF_PolicyVersion not found")");
        
        print("------> IABTCF_gdprApplies :\(UserDefaults.standard.object(forKey: "IABTCF_gdprApplies") ?? "IABTCF_gdprApplies not found")");
        
        print("------> IABTCF_PublisherCC :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherCC") ?? "IABTCF_PublisherCC not found")");
        
        print("------> IABTCF_PurposeOneTreatment :\(UserDefaults.standard.object(forKey: "IABTCF_PurposeOneTreatment") ?? "IABTCF_PurposeOneTreatment not found")");
        
        print("------> IABTCF_UseNonStandardStacks :\(UserDefaults.standard.object(forKey: "IABTCF_UseNonStandardStacks") ?? "IABTCF_UseNonStandardStacks not found")");
        
        
        print("------> IABTCF_VendorConsents :\(UserDefaults.standard.object(forKey: "IABTCF_VendorConsents") ?? "IABTCF_VendorConsents not found")");
        
        
        print("------> IABTCF_VendorLegitimateInterests :\(UserDefaults.standard.object(forKey: "IABTCF_VendorLegitimateInterests") ?? "IABTCF_VendorLegitimateInterests not found")");
        
        
        print("------> IABTCF_PurposeConsents :\(UserDefaults.standard.object(forKey: "IABTCF_PurposeConsents") ?? "IABTCF_PurposeConsents not found")");
        
        
        print("------> IABTCF_PurposeLegitimateInterests :\(UserDefaults.standard.object(forKey: "IABTCF_PurposeLegitimateInterests") ?? "IABTCF_PurposeLegitimateInterests not found")");
        
        print("------> IABTCF_SpecialFeaturesOptIns :\(UserDefaults.standard.object(forKey: "IABTCF_SpecialFeaturesOptIns") ?? "IABTCF_SpecialFeaturesOptIns not found")");
        
        print("------> IABTCF_PublisherConsent :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherConsent") ?? "IABTCF_PublisherConsent not found")");
        
        print("------> IABTCF_PublisherRestrictions1 :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherRestrictions1") ?? "IABTCF_PublisherRestrictions1 not found")");
        
        
        print("------> IABTCF_PublisherRestrictions2 :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherRestrictions2") ?? "IABTCF_PublisherRestrictions2 not found")");
        
        print("------> IABTCF_PublisherRestrictions3 :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherRestrictions3") ?? "IABTCF_PublisherRestrictions3 not found")");
        
        
        print("------> IABTCF_PublisherRestrictions4 :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherRestrictions4") ?? "IABTCF_PublisherRestrictions4 not found")");
        
        print("------> IABTCF_PublisherRestrictions5 :\(UserDefaults.standard.object(forKey: "IABTCF_PublisherRestrictions5") ?? "IABTCF_PublisherRestrictions5 not found")");
        
        
        print("------> IABTCF_Madvertise_ExternalVendors :\(UserDefaults.standard.object(forKey: "IABTCF_Madvertise_ExternalVendors") ?? "IABTCF_Madvertise_ExternalVendors not found")");
        
        print("------> IABTCF_TCString :\(UserDefaults.standard.object(forKey: "IABTCF_TCString") ?? "IABTCF_TCString not found")");
        
    }
    
    // MARK: - Menu open
    
    @IBAction func openMenu(_ sender: Any) {
        APP_DELEGATE.drawerViewController?.openMenu()
    }
    
    
    
    @IBAction func submit(_ sender: Any) {
        self.appIdTextField.endEditing(true)
        self.cmpLanguageTextField.endEditing(true)
        
        //set the new value of consent
        let consentFlagValue = Int(self.consentFlagTextfield.text ?? "")
        UserDefaults.standard.set(consentFlagValue, forKey: ConsetFlagBlueSTack)
        //debug mode
        UserDefaults.standard.set(self.debugSwitch.isOn, forKey: "SavedDebug")
        MNGAdsSDKFactory.getVersion()
        MNGAdsSDKFactory.setDebugModeEnabled(self.debugSwitch.isOn)
        //cmp language
        UserDefaults.standard.set(self.cmpLanguageTextField.text ?? "fr", forKey: CMP_LANGUAGE)
        //APPID
        let newAppId = self.appIdTextField.text
        guard let newAppId = newAppId else {
            return
        }
        if newAppId == "" {
            NSLog("put a valid appId");
            return;
        }
        
        let oldAppId  = UserDefaults.standard.object(forKey: SavedAppId) as? String
        
        if newAppId != oldAppId {
            MNG_ADS_APP_ID = newAppId
            MNGAdsSDKFactory.setDelegate(self)
            MNGAdsSDKFactory.initWithAppId(newAppId)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    //MARK: -MNGADS SDK Factory delegate
    func mngAdsSDKFactoryDidFinishInitializing() {
        NSLog("MNGAds sucess initialization");
        APP_DELEGATE.displayToast(message: "MNGAds sucess initialization")
    }
    
    func mngAdsSDKFactoryDidFailInitializationWithError(_ error: Error!) {
        NSLog("MNGAds failed initialization");
        APP_DELEGATE.displayToast(message: "MNGAds failed initialization");
    }
    
    
    
}
