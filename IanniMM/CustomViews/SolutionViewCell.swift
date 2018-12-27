//
//  SolutionViewCell.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class SolutionViewCell: UITableViewCell {
    /* Properties */
    static var cellIdentifer = "SolutionViewCell"
    
    var elementNameLabel = UILabel.create("", .rgb(51,51,51), .mainFont(.regular, 18.scaled))
    let atomsLabel = UILabel.create("", .rgb(51,51,51), .mainFont(.regular, 18.scaled))
    let molarMassLabel = UILabel.create("", .rgb(51,51,51), .mainFont(.regular, 12.scaled))
    let percentLabel = UILabel.create("", .rgb(51,51,51), .mainFont(.regular, 12.scaled))
    
    // variables for the cell and use getters and setters in order to set the labels when label is changed
    var elementName: String? {
        // when element is set, update the attributed label
        willSet(value) {
            guard let value = value else { return }
            self.elementNameLabel.text = value
        }
    }
    var elementCount: Int? {
        // update label element count when set
        willSet(value) {
            guard let count = value else { return }
            atomsLabel.text = "\(count) atom\(count == 1 ? "s" : "")"
        }
    }
    
    var molarMass: Double? {
        willSet(value) {
            guard let count = value else { return }
            molarMassLabel.text = "\(count) g/mol"
        }
    }
    
    var percent: Double? {
        // update percentage label when this value is set
        willSet(value) {
            guard let percent = value else { return }
            let rounded = String(format: "%.2f", (percent * 100))
            percentLabel.text = "\(rounded)% mass"
        }
    }
    let containerView = UIView()
    /* Initializers*/
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SolutionViewCell.cellIdentifer)
        // add the labels to the view
        if UIScreen.main.isiPhoneXFamily {
            elementNameLabel.font = .mainFont(.regular, 20.scaled)
            atomsLabel.font = .mainFont(.regular, 20.scaled)
            molarMassLabel.font = .mainFont(.extraLight, 14.scaled)
            percentLabel.font = .mainFont(.extraLight, 14.scaled)
        }
        else if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
            elementNameLabel.font = .mainFont(.regular, 16.scaled)
            atomsLabel.font = .mainFont(.regular, 16.scaled)
            molarMassLabel.font = .mainFont(.extraLight, 12.scaled)
            percentLabel.font = .mainFont(.extraLight, 12.scaled)
        }
        
        containerView.addToView(self, .left(10.scaled.pad), .right(10.scaled.pad), .top(6.scaled.pad), .bottom(6.scaled.pad))
        
        elementNameLabel.addToView(containerView, .left(20.scaled.pad), .bottom(self.centerY))
        atomsLabel.addToView(containerView, .right(20.scaled.pad), .bottom(self.centerY))
        molarMassLabel.addToView(containerView, .left(20.scaled.pad), .top(self.centerY))
        percentLabel.addToView(containerView, .right(20.scaled.pad), .top(self.centerY))
        
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.16
        
        self.backgroundColor = .white
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
    }
    
    /* Methods */
    
    /* Delegate Methods */
    
    /* Overridden Methods */
}
