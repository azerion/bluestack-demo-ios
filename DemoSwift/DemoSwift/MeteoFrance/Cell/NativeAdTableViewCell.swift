//
//  NativeAdTableViewCell.swift
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 25/06/2020.
//  Copyright © 2020 Bensalah Med Amine. All rights reserved.
//

import UIKit
import BlueStackSDK

class NativeAdTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nativeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialContextLabel: UILabel!
    var badgeView: UIView? = nil
    var adChoiceBadgeView: UIView? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func initWithNative(nativeObject:MNGNAtiveObject) {
             nativeView.layer.borderWidth = 1
             nativeView.layer.borderColor = UIColor.lightGray.cgColor
             titleLabel.text = nativeObject.title
             socialContextLabel.text = nativeObject.socialContext
             descriptionLabel.text = nativeObject.body
             if self.badgeView != nil {
                 self.badgeView?.removeFromSuperview()
             }
//             self.nativeObject = nativeObject
        badgeView = nativeObject.badgeView
             if (badgeView != nil) {
                 var frame = badgeView?.frame
                 frame?.origin.y = 3
                 frame?.origin.x = 3
                 badgeView?.frame = frame!
                 self.nativeView.addSubview(badgeView!)
             }
             
             if adChoiceBadgeView != nil {
                 adChoiceBadgeView?.removeFromSuperview()
             }
             adChoiceBadgeView = nativeObject.adChoiceBadgeView
             if adChoiceBadgeView != nil {
                 var frame = adChoiceBadgeView?.frame
                 let widhtFrame = frame!.size.width - 3
                 frame?.origin.y = 3
                 frame?.origin.x = self.nativeView.frame.size.width - widhtFrame
                 adChoiceBadgeView?.frame = frame!
                 self.nativeView.addSubview(adChoiceBadgeView!)
             }
             
             // download images
             self.backgroundImage.image = nil
             self.iconeImage.image = nil
             self.iconeImage.layer.cornerRadius = 16
             self.iconeImage.clipsToBounds = true
        
             
             self.callToActionButton.setTitle(nativeObject.callToAction, for: UIControl.State())
             if nativeObject.displayType == MNGDisplayType.appInstall {
                 self.callToActionButton.setImage(#imageLiteral(resourceName: "download"), for: UIControl.State())
             }else if nativeObject.displayType == .content {
                 self.callToActionButton.setImage(#imageLiteral(resourceName: "arrow"), for: UIControl.State())
             }
             self.callToActionButton.titleLabel?.textAlignment = .center
             
             nativeObject.registerView(forInteraction: self.nativeView, withMediaView: self.backgroundImage, withIconImageView: self.iconeImage, with: APP_DELEGATE.drawerViewController, withClickableView: self.callToActionButton)
             
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
