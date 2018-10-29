//
//  SolutionVC.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

protocol SolutionVCDelegate:class {
    func solutionVCWillHome()
}

class SolutionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /* Properties */
    enum SolutionState { case shown, hidden, showingPreview }
    var delegate: SolutionVCDelegate?
    var state: SolutionState = .hidden {
        willSet {
            if state != .hidden && newValue == .hidden {
                self.tableView.x1Anchor = .left(self.view.right)
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                self.molarMassLabelViewContainer.x1Anchor = .right(self.view.left)
                self.molarMassLabel.x1Anchor = .left(self.view.right)
                self.molarMassLabel.x2Anchor = .right(self.view.right, (UIScreen.main.isiPadLandscape ? -UIScreen.main.bounds.height : -UIScreen.main.bounds.width).pad)
                self.homeButton.y1Anchor = .bottom(self.view.top)
                UIView.animate(withDuration: 0.5, delay: 0.01, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.molarMassLabel.text = ""
                    self.view.isHidden = true
                }
            }
            else if state != .shown && newValue == .shown {
                self.view.isHidden = false
                molarMassLabel.x1Anchor = .left(molarMassLabelViewContainer.left, 10.scaled.pad)
                molarMassLabel.x2Anchor = nil
                molarMassLabelViewContainer.x1Anchor = .left
                molarMassLabelViewContainer.widthALAnchor = .width(20.scaled.constant)
            }
            else if state != .showingPreview && newValue == .showingPreview {
                self.view.isHidden = false
                molarMassLabelViewContainer.y1Anchor = .top(molarMassLabel.top, (-5).scaled.pad)
                self.homeButton.y2Anchor = nil
                self.homeButton.y1Anchor = .top(38.scaled.pad)
                self.tableView.x1Anchor = .left
                self.tableView.x2Anchor = .right
                self.tableView.y2Anchor = .bottom(molarMassLabelViewContainer.top, 15.scaled.pad)

                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    var homeButton = UIButton()

    var sortedElements: [(Element,Int)] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var molarMass: Double?
    let tableView = UITableView()
    let molarMassLabelViewContainer = UIView()
    var molarMassLabel = UILabel.create("", .rgb(197,255,195), .mainFont(.light, 18.scaled))
    /* Initializers*/
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(nibName: nil, bundle: nil)
        molarMassLabelViewContainer.addToView(self.view, .bottom, .right(self.view.left), .width(0.constant), .top(molarMassLabelViewContainer.bottom))
        molarMassLabelViewContainer.backgroundColor = .rgb(93,165,102)
        molarMassLabel.addToView(self.view, .right(molarMassLabelViewContainer.right), .bottom(molarMassLabelViewContainer.bottom, 5.scaled.pad))
        
        tableView.backgroundColor = .clear
        tableView.register(SolutionViewCell.self, forCellReuseIdentifier: SolutionViewCell.cellIdentifer)
        tableView.rowHeight = 60.scaled
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        homeButton.setTitle("Home", for: [])
        homeButton.setTitleColor(.rgb(197,255,195), for: [])
        homeButton.setImage(createArrowImage(height: 16.scaled), for: [])
        homeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5.scaled, bottom: 0, right: -5)
        homeButton.titleLabel?.font = .mainFont(.extraLight, 18.scaled)
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        homeButton.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDown)
        homeButton.addTarget(self, action: #selector(buttonExit(sender:)), for: .touchDragExit)
        homeButton.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDragEnter)
        homeButton.addTarget(self, action: #selector(buttonExit(sender:)), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonSelected), for: .touchUpInside)
        
        homeButton.addToView(self.view, .bottom(self.view.top), .left(UIScreen.main.isiPhoneXFamily ? 20.scaled.pad :  20.scaled.pad), .height(16.scaled.constant))
        tableView.addToView(self.view, .top(homeButton.bottom, 15.scaled.pad), .left(self.view.right), .right(self.view.right, (-UIScreen.main.bounds.width).pad), .bottom(5.scaled.pad))
    }
    
    
    func createArrowImage(height: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: height / 2, height: height))
        let imagePath = UIBezierPath()
        imagePath.move(to: CGPoint(x: height / 2, y: 0))
        imagePath.addLine(to: CGPoint(x: 0, y: height / 2))
        imagePath.addLine(to: CGPoint(x: height / 2, y: height))
        imagePath.lineWidth = 1.0
        imagePath.lineCapStyle = .round
        UIColor.rgb(197,255,195).setStroke()
        imagePath.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // receive data from other view controller
    public func receive(periodicTable: PeriodicTable) {
        // solve molar mass
        let result = periodicTable.calculateMolarMassWithPercents(formula: periodicTable.currentFormulaString)
        sortedElements = result.0.sorted(by: { $0.0.atomicNumber < $1.0.atomicNumber })
        self.molarMass = result.1

        tableView.reloadData()
    }
    
    func setMolarMassLabel(value: Double) {
        self.molarMass = value
        if "\(value) g/mol" != self.molarMassLabel.text {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.molarMassLabel.alpha = 0.0
            }) { _ in
                self.molarMassLabel.text = "\(value) g/mol"
                self.molarMassLabelViewContainer.widthALAnchor = .width(self.molarMassLabel.width, 20.scaled.pad)
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    self.molarMassLabel.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    /* Methods */
    
    /* Delegate Methods */
    //returns # of elements in the view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedElements.count
    }
    
    // render each cell of the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SolutionViewCell.cellIdentifer, for: indexPath) as! SolutionViewCell
        let element = sortedElements[indexPath.row].0
        let count = sortedElements[indexPath.row].1
        cell.elementName = element.name
        cell.elementCount = count
        cell.molarMass = element.atomicMass
        guard let mass = molarMass else {
            cell.percent = 0.0
            return cell
        }
        let percentOutput = element.atomicMass * Double(count) / mass
        cell.percent = round(percentOutput * 10000) / 10000 // round to 4 decimal places
        
        return cell
    }
    
    @objc func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
            sender.alpha = 0.5
        }, completion: nil)
    }
    @objc func buttonExit(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
            sender.alpha = 1.0
        }, completion: nil)
    }
    @objc func homeButtonSelected() {
        self.state = .hidden
        delegate?.solutionVCWillHome()
    }
    
    /* Overridden Methods */
}
