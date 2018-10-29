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
    let titleLabel = UILabel.create("This is Frank Ianni", .white, .mainFont(.bold, 24.scaled))
    let separatorLine = UIView()
    let paragraphTextView = UITextView()
    let signOffLabel = UILabel.create("- SCH3UP Sem. 2, Per. 3, 2018", .white, .mainFont(.bold, 14.scaled))
    let closeButton = UIButton()
    var delegate: IanniVCDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    let gradientLayer = CAGradientLayer()
    
    var paragraphString: NSMutableAttributedString {
        let string = NSMutableAttributedString()
        var fontSize = 18.scaled
        if UIScreen.main.isiPhoneXR {
            fontSize = 22.scaled
        }
        let part1 = NSAttributedString(string: "Frank Ianni is a high school chemistry teacher at St. Ignatius High School. He needed a molar mass calculator because he’s too lazy to solve molar masses by himself ", attributes: [NSAttributedStringKey.font: UIFont.mainFont(.light, fontSize) ?? UIFont.systemFont(ofSize: fontSize)])
        let part2 = NSAttributedString(string: "(his laziness really shows on the soccer field)", attributes: [.font: UIFont.mainFont(.black, fontSize) ?? UIFont.systemFont(ofSize: fontSize)])
        let part3 = NSAttributedString(string: ". But we figured even more people needed a molar mass calculator like he did. So here you go, a simple molar mass calculator for all you students and teachers out there.", attributes: [.font: UIFont.mainFont(.light, fontSize) ?? UIFont.systemFont(ofSize: fontSize)])
        
        string.append(part1)
        string.append(part2)
        string.append(part3)
        
        return string
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("x", for: [])
        
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
        self.view.backgroundColor = .white
        gradientLayer.colors = [UIColor.rgb(91,160,94).cgColor, UIColor.rgb(115,206,160).cgColor]
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = self.view.frame
        ianniImageView.layer.cornerRadius = ianniImageView.frame.width / 2
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        paragraphTextView.setContentOffset(.zero, animated: false)
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
        ianniImageView.addToView(self.view, .left(20.scaled.pad), .width(0.25.ratio), .height(ianniImageView.width), .top(48.scaled.pad))
        titleLabel.addToView(self.view, .left(ianniImageView.right, 15.scaled.pad), .right(20.scaled.pad), .centerY(ianniImageView.centerY))
        separatorLine.addToView(self.view, .centerX, .width(0.9.ratio), .top(ianniImageView.bottom, 20.scaled.pad), .height(1.constant))
        paragraphTextView.addToView(self.view, .top(separatorLine.bottom), .bottom(80.scaled.pad), .width(0.9.ratio), .centerX)
        signOffLabel.addToView(self.view, .top(paragraphTextView.bottom), .width(0.9.ratio), .centerX)
        closeButton.addToView(self.view, .centerX, .bottom(UIScreen.main.isiPhoneXFamily ? 20.scaled.pad : 10.scaled.pad), .width(50.scaled.constant), .height(50.scaled.constant))
    }
    
    
    
    func setStyles() {
        titleLabel.numberOfLines = 2
        
        ianniImageView.clipsToBounds = true
        
        separatorLine.backgroundColor = .white
        
        paragraphTextView.backgroundColor = .clear
        paragraphTextView.textColor = .white
        paragraphTextView.setContentOffset(.zero, animated: false)
        
        signOffLabel.textAlignment = .right
        
        closeButton.setTitleColor(.white, for: [])
        closeButton.titleLabel?.font = .mainFont(.light, 36.scaled)
    }
    func hideElements() {
        ianniImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        titleLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        separatorLine.transform = CGAffineTransform(translationX: 0, y:  -UIScreen.main.bounds.height)
        paragraphTextView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        signOffLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        closeButton.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
    }
    func transitionElementsIn() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.separatorLine.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.ianniImageView.transform = .identity
            })
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.titleLabel.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.paragraphTextView.transform = .identity
                })
                UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.signOffLabel.transform = .identity
                })
                UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.closeButton.transform = .identity
                })
                
            })
        })
    }
    
    func transitionElementsOut(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.closeButton.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
        })
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.signOffLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        })
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.paragraphTextView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.titleLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            })
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.ianniImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            })
            UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.separatorLine.transform = CGAffineTransform(translationX: 0, y:  -UIScreen.main.bounds.height)
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
