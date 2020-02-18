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
        iv.font = .systemFont(ofSize: titleSize, weight: .bold)
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
        iv.font = .systemFont(ofSize: fontSize, weight: .regular)
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
        iv.font = .systemFont(ofSize: fontSize, weight: .black)
        iv.textColor = .themeColor
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        iv.numberOfLines = 1
        iv.lineBreakMode = .byClipping
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        cv.backgroundColor = .white
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        cv.isPagingEnabled = false
        cv.showsHorizontalScrollIndicator = false
        
        
        return cv
    }()
    
    
    func setupView(){
        collectionView.register(GuestInfoCell.self, forCellWithReuseIdentifier: GuestInfoCell.identifier)
        addSubview(bgView)
        addSubview(secondBgView)
        secondBgView.addSubview(separateLineView)
        secondBgView.addSubview(businessNameLabel)
        secondBgView.addSubview(businessDescriptionLabel)
        secondBgView.addSubview(businessPromoLabel)
        secondBgView.addSubview(representativeLabel)
        secondBgView.addSubview(collectionView)
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
        secondBgView.addConstraintsWithFormat("H:|[v0]|", views: representativeLabel)
        representativeLabel.topAnchor.constraint(equalTo: separateLineView.bottomAnchor, constant: 15).isActive = true
        
        //Collectionview
        secondBgView.addConstraintsWithFormat("H:|-45-[v0]-45-|", views: collectionView)
        collectionView.topAnchor.constraint(equalTo: representativeLabel.bottomAnchor, constant: 9).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: secondBgView.bottomAnchor, constant: -15).isActive = true
        
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

class GuestInfoCell: BaseCell{
    

    

    
    var nameLabel: TextViewLabel = {
        let iv = TextViewLabel()
        iv.text = ""
        
        iv.font = .systemFont(ofSize: fontSize, weight: .black)
        iv.textColor = #colorLiteral(red: 0.1803921569, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.textContainer.lineBreakMode = .byWordWrapping

        return iv
       }()
    
    var titleLabel: TextViewLabel = {
        let iv = TextViewLabel()
        iv.text = ""
        iv.font = .systemFont(ofSize: fontSize, weight: .medium)
        iv.textColor = #colorLiteral(red: 0.1803921569, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.textContainer.lineBreakMode = .byWordWrapping
        return iv
       }()
       
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    static var identifier: String {
        return String(describing: self)
    }
    override func setupViews() {
        backgroundColor = .white
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(titleLabel)
        contentView.addConstraintsWithFormat("V:|-1-[v0]-1-|", views: profileImageView)
        profileImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -2).isActive = true
        profileImageView.layer.cornerRadius = (frame.height - 2)/2
        profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        //contentView.addConstraintsWithFormat("V:|-8-[v0]-7-[v1]", views: nameLabel, titleLabel)
        //nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -nameSpacing).isActive = true
        //titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: nameSpacing).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -8).isActive = true
        titleLabel.setContentHuggingPriority(.init(rawValue: 249), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
    }

}

