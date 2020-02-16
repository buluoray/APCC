//
//  GuestSectionHeaderView.swift
//  APCC
//
//  Created by Yusheng Xu on 2/15/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class GuestSectionHeader: UICollectionReusableView {
    
     var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 33, weight: .medium)
        label.sizeToFit()
        label.backgroundColor = .themeColor
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
     }()
    
    static var identifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        label.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    override func layoutSubviews() {
        label.layer.cornerRadius = label.frame.width/2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
