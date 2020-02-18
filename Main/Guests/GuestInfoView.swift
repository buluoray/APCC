//
//  GuestInfoView.swift
//  APCC
//
//  Created by Yusheng Xu on 2/16/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class GuestInfoView: UIView {
    
    let bgView = UIView()
    let secondBgView = UIView()
    let separateLineView = UIView()
    var businessNameLabel: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = ""
        iv.font = .systemFont(ofSize: 25, weight: .bold)
        iv.textColor = #colorLiteral(red: 0.2117647059, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.numberOfLines = 7
        iv.lineBreakMode = .byClipping
        iv.adjustsFontSizeToFitWidth = true
        return iv
    }()
    var businessDescriptionLabel: TextViewLabel = {
        let iv = TextViewLabel()
        iv.text = ""
        iv.textAlignment = .left
        iv.font = .systemFont(ofSize: 14, weight: .regular)
        iv.textColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        iv.isScrollEnabled = true
        return iv

    }()
    var businessPromoLabel = LinkLabel()
    
    var representativeLabel: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "REPRESENTATIVES"
        iv.font = .systemFont(ofSize: 13, weight: .bold)
        iv.textColor = .themeColor
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.numberOfLines = 1
        iv.lineBreakMode = .byClipping
        return iv
    }()
    
    
    
    
    func setupView(){
        addSubview(bgView)
        addSubview(secondBgView)
        secondBgView.addSubview(separateLineView)
        secondBgView.addSubview(businessNameLabel)
        secondBgView.addSubview(businessDescriptionLabel)
        secondBgView.addSubview(businessPromoLabel)
        secondBgView.addSubview(representativeLabel)
        //Background Red
        bgView.backgroundColor = .themeColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat("H:|[v0]|", views: bgView)
        bgView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: frame.height/2 - 93).isActive = true
        
        //SecondBackground White
        secondBgView.translatesAutoresizingMaskIntoConstraints = false
        secondBgView.backgroundColor = .white
        
        secondBgView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        secondBgView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -120).isActive = true
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: secondBgView)
        secondBgView.roundAndShadow(radius: 20)
        
        //separateLineView
        separateLineView.backgroundColor = .lightGray
        
        secondBgView.addConstraintsWithFormat("H:|[v0]|", views: separateLineView)
        separateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separateLineView.centerYAnchor.constraint(equalTo: secondBgView.centerYAnchor, constant: 40).isActive = true
        
        
        //BusinessNameLbel
        
        secondBgView.addConstraintsWithFormat("H:|-30-[v0]-30-|", views: businessNameLabel)
        businessNameLabel.topAnchor.constraint(equalTo: secondBgView.topAnchor, constant: 35).isActive = true
        
        //BusinessDescriptionLabel
        
        secondBgView.addConstraintsWithFormat("H:|-30-[v0]-30-|", views: businessDescriptionLabel)
        businessDescriptionLabel.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor, constant: 24).isActive = true
        businessDescriptionLabel.bottomAnchor.constraint(equalTo: businessPromoLabel.topAnchor, constant: -18).isActive = true
        
        //BusinessPromoLabel
        
        secondBgView.addConstraintsWithFormat("H:|-30-[v0]", views: businessPromoLabel)
        businessPromoLabel.bottomAnchor.constraint(equalTo: separateLineView.topAnchor, constant: -16).isActive = true
        
        //Representative Label
        secondBgView.addConstraintsWithFormat("H:|-30-[v0]", views: representativeLabel)
        representativeLabel.topAnchor.constraint(equalTo: separateLineView.bottomAnchor, constant: 15).isActive = true

        
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        secondBgView.roundAndShadow(radius: 20)
        businessNameLabel.sizeToFit()
        businessNameLabel.frame = CGRect(x: 0, y: 0, width: secondBgView.frame.width - 60, height: businessNameLabel.frame.height)
        if businessNameLabel.frame.height > 71{
            businessNameLabel.heightAnchor.constraint(equalToConstant: 71).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
}

extension UIView{
    func roundAndShadow(radius: CGFloat? = 10) {
        clipsToBounds = true
        layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius!).cgPath
        layer.cornerRadius = radius!
    }
}
