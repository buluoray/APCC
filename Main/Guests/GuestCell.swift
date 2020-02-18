//
//  GuestTableViewCell.swift
//  APCC
//
//  Created by Yusheng Xu on 2/14/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class GuestCell: BaseCell {
    
    
    var businessnNameLabel: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = ""
        iv.font = .systemFont(ofSize: 14, weight: .bold)
        iv.textColor = #colorLiteral(red: 0.2117647059, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.numberOfLines = 4
        iv.lineBreakMode = .byTruncatingTail
        
        return iv
    }()
    
    var countryLabel: TextViewLabel = {
        let iv = TextViewLabel()
        iv.text = ""
        iv.font = .systemFont(ofSize: 14, weight: .bold)
        iv.textColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        iv.textAlignment = .right
        iv.isUserInteractionEnabled = false
        iv.textContainer.lineBreakMode = .byWordWrapping
        
        return iv
    }()
    
    let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "APCC"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override func layoutSubviews() {
        countryLabel.centerContentVertically()
    }
    
    override func setupViews() {
        contentView.addSubview(businessnNameLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(iconView)
        contentView.addConstraintsWithFormat("V:|-24-[v0]-24-|", views: countryLabel)
        contentView.addConstraintsWithFormat("V:[v0]", views: businessnNameLabel)
        contentView.addConstraintsWithFormat("V:[v0(40)]", views: iconView)
        contentView.addConstraintsWithFormat("H:|-12-[v2(40)]-12-[v0]-8-[v1(90)]-12-|", views: businessnNameLabel, countryLabel,iconView)
        businessnNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = #colorLiteral(red: 0.6023199558, green: 0.5987423658, blue: 0.6050719023, alpha: 1)
        layer.shadowOffset = CGSize(width: 2, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
