//
//  CarrouselNativeView.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 22/8/2022.
//

import UIKit

class CarrouselNativeView: UIView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconeImage: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var view: UIView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "CarrouselNativeView", bundle: .main)
        let nibView = nib.instantiate(withOwner : self, options: nil)[0] as! UIView
        return nibView
    }
    
}
