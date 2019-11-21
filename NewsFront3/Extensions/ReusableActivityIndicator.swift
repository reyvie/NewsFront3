//
//  ResuableActivityIndicator.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/20/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import Foundation
import UIKit

class ReusableActivityIndicator: UIViewController{
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    func activityIndicator(_ title: String) {

        self.strLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.effectView.removeFromSuperview()

        self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        self.strLabel.text = title
        self.strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        self.effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 50)
       // effectView.frame = CGRect(x: view.frame.midX, y: view.frame.midY , width: 50, height: 50)
        self.effectView.layer.cornerRadius = 10
        self.effectView.layer.masksToBounds = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.startAnimating()

        self.effectView.contentView.addSubview(activityIndicator)
        self.effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        self.strLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.effectView.removeFromSuperview()
        
    }
}
