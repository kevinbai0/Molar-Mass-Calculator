//
//  IanniVCViewController.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-09-22.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

protocol IanniVCDelegate:class {
    func ianniVCRemoveFromSuperview()
}

class IanniVC: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    let ianniImageView = UIImageView(image: UIImage(named: "ianni"))
    let titleLabel = UILabel.create("This is Frank Ianni", .rgb(51,51,51), .mainFont(.bold, 24.scaled))
    
    let paragraphContainerView = UIView()
    let paragraphTextView = UITextView()
    let closeButton = UIButton()
    var delegate: IanniVCDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var paragraphString: NSMutableAttributedString {
        let string = NSMutableAttributedString()
        let fontSize = UIScreen.main.isiPhoneXFamily ? 13.5.scaled : 14.scaled

        let paragraphAttribute = NSMutableParagraphStyle()
        paragraphAttribute.lineSpacing = 4.scaled
        let rightParagraphStyle = NSMutableParagraphStyle()
        rightParagraphStyle.lineSpacing = 4.scaled
        rightParagraphStyle.alignment = .right
        let part1 = NSAttributedString(string: "Frank Ianni is a high school chemistry teacher at St. Ignatius High School. He needed a molar mass calculator because he’s too lazy to solve molar masses by himself ", attributes: [.font: UIFont.mainFont(.regular, fontSize) ?? UIFont.systemFont(ofSize: fontSize), .paragraphStyle: paragraphAttribute])
        let part2 = NSAttributedString(string: "(his laziness really shows on the soccer field)", attributes: [.font: UIFont.mainFont(.regular, fontSize) ?? UIFont.systemFont(ofSize: fontSize), .paragraphStyle: paragraphAttribute])
        let part3 = NSAttributedString(string: ". But we figured even more people needed a molar mass calculator like he did. So here you go, a simple molar mass calculator for all you students and teachers out there.", attributes: [.font: UIFont.mainFont(.regular, fontSize) ?? UIFont.systemFont(ofSize: fontSize), .paragraphStyle: paragraphAttribute])
        let part4 = NSAttributedString(string: "\n\n- SCH3UP Sem. 2, Per. 3, 2018", attributes: [.font: UIFont.mainFont(.regular, 12.scaled) ?? UIFont.systemFont(ofSize: 12.scaled), .paragraphStyle: rightParagraphStyle])
        
        string.append(part1)
        string.append(part2)
        string.append(part3)
        string.append(part4)
        
        return string
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("< Home", for: [])
        closeButton.titleLabel?.font = .mainFont(.regular, 18.scaled)
        closeButton.setTitleColor(.rgb(51,51,51), for: [])
        paragraphTextView.textContainerInset = UIEdgeInsets(top: 15.scaled, left: 15.scaled, bottom: 15.scaled, right: 15.scaled)
        paragraphTextView.isEditable = false
        paragraphTextView.isScrollEnabled = false
        paragraphTextView.attributedText = paragraphString
        
        closeButton.addTarget(self, action: #selector(exit(sender:)), for: .touchUpInside)
        
        setStyles()
        setLayout()
        hideElements()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ianniImageView.layer.cornerRadius = ianniImageView.frame.width / 2
        paragraphTextView.setContentOffset(.zero, animated: false)
        paragraphContainerView.layer.shadowPath = UIBezierPath(rect: paragraphContainerView.bounds).cgPath
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 1.0
        }) { _ in
            self.transitionElementsIn()
        }
    }
    
    @objc func exit(sender: UIButton) {
        transitionElementsOut() {
            self.delegate?.ianniVCRemoveFromSuperview()
        }
    }
    
    func setLayout() {
        ianniImageView.addToView(self.view, .right(20.scaled.pad), .width(UIScreen.main.isiPadPortrait ? 0.2.ratio : 0.25.ratio), .height(ianniImageView.width), .top(64.scaled.pad))
        titleLabel.addToView(self.view, .left(20.scaled.pad), .right(ianniImageView.left, 15.scaled.pad), .centerY(ianniImageView.centerY))
        
        paragraphContainerView.addToView(self.view, .top(titleLabel.bottom, 20.scaled.pad), .bottom(UIScreen.main.isiPhoneXFamily ? 50.scaled.pad : 20.scaled.pad), .width(0.9.ratio), .centerX)
        paragraphTextView.addToView(paragraphContainerView, .left, .right, .top, .bottom)
        closeButton.addToView(self.view, .left(20.scaled.pad), .top(28.scaled.pad))
    }
    
    
    
    func setStyles() {
        titleLabel.numberOfLines = 2
        if UIScreen.main.isiPhoneXFamily {
            titleLabel.font = .mainFont(.bold, 22.scaled)
        }
        else if UIScreen.main.isiPadPortrait {
            titleLabel.font = .mainFont(.bold, 30.scaled)
        }
        
        ianniImageView.clipsToBounds = true
        
        paragraphTextView.textColor = .rgb(51,51,51)
        paragraphTextView.setContentOffset(.zero, animated: false)
        
        paragraphContainerView.backgroundColor = .white
        paragraphContainerView.layer.shadowColor = UIColor.black.cgColor
        paragraphContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        paragraphContainerView.layer.shadowRadius = 10
        paragraphContainerView.layer.shadowOpacity = 0.16
    }
    func hideElements() {
        ianniImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        titleLabel.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        paragraphContainerView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        closeButton.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height / 3)
    }
    func transitionElementsIn() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.closeButton.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.ianniImageView.transform = .identity
                self.titleLabel.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.paragraphContainerView.transform = .identity
                })
            })
        })
    }
    
    func transitionElementsOut(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.paragraphContainerView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.titleLabel.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                self.ianniImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            })
            UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.closeButton.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height / 3)
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.alpha = 0.0
                }, completion: { _ in
                    completion()
                })
            })
        })
    }
}
