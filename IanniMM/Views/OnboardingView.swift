//
//  OnboardingView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    /* Properties */
    let ianniImageView = UIImageView(image: UIImage(named: "ianni"))
    let ianniCircleView = UIView()

    var mainImageView = UIImageView()
    let titleLabel = UILabel.create("", .white, .mainFont(.regular, 32.scaled))
    let subHeadingLabel = UILabel.create("", .rgb(197,255,195), .mainFont(.regular, 16.scaled))
    let gradientLayer = CAGradientLayer()
    /* Initializers*/
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(title: String, subHeading: String, image: UIImage?, totalViews: Int) {
        super.init(frame: CGRect.zero)
        gradientLayer.colors = [UIColor.rgb(91,160,94).cgColor, UIColor.rgb(115,206,160).cgColor]
        self.layer.addSublayer(gradientLayer)
        mainImageView = UIImageView(image: image)
        ianniImageView.clipsToBounds = true
        ianniCircleView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        mainImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        // add views to superview and determine their positioning based on device
        
        titleLabel.addToView(self, .top(28.scaled.pad), .centerX)
        
        subHeadingLabel.numberOfLines = 4
        subHeadingLabel.textAlignment = .center
        
        subHeadingLabel.text = subHeading
        subHeadingLabel.addToView(self, .top(titleLabel.bottom, 10.scaled.pad), .left(20.scaled.pad), .right(20.scaled.pad), .height(64.scaled.pad))
        
        
        mainImageView.addToView(self, .width(0.7.ratio), .top(titleLabel.bottom, 20.scaled.pad), .centerX)
    }
    
    /* Methods */
    
    /* Delegate Methods */
    
    /* Overridden Methods */
    override func layoutSubviews() {
        // set corner radius of view when updating screen
        super.layoutSubviews()
        ianniCircleView.layer.cornerRadius = ianniCircleView.frame.width / 2
        ianniImageView.layer.cornerRadius = ianniImageView.frame.width / 2
        self.gradientLayer.frame = self.bounds
    }
}
