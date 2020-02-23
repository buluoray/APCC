//
//  GuestDetailViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/19/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import SDWebImage
class GuestDetailViewController: UIViewController {

    var attendee: Attendee?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    var titleLabel: TextViewLabel = {
        let iv = TextViewLabel()
        iv.text = ""
        iv.font = .systemFont(ofSize: cardFontSize, weight: .regular)
        iv.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        iv.textContainer.lineBreakMode = .byWordWrapping
        return iv
       }()
    
    var aboutLabel: TextViewLabel = {
         let iv = TextViewLabel()
         iv.text = "About"
         iv.font = .italicSystemFont(ofSize: titleSize)
         iv.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
         iv.textAlignment = .left
         iv.isUserInteractionEnabled = false
         iv.textContainer.lineBreakMode = .byWordWrapping
         return iv
    }()
    
    var bioLabel: TextViewLabel = {
         let iv = TextViewLabel()
         iv.text = ""
         iv.font = .systemFont(ofSize: guestDetailFontSize, weight: .regular)
         iv.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
         iv.textAlignment = .left
         iv.isUserInteractionEnabled = true
         iv.textContainer.lineBreakMode = .byWordWrapping
        iv.isScrollEnabled = true
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
    
    var nameLabel: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "N/A"
        iv.font = .systemFont(ofSize: cardSpacing, weight: .regular)
        iv.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        iv.numberOfLines = 0
        iv.lineBreakMode = .byWordWrapping
        
        return iv
    }()
    
    var separater = UIView()
    var aboutSeparater = UIView()
    
    func setupModel(data: Attendee){
        self.attendee = data
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNav()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupNav(){
           overrideUserInterfaceStyle = .light
           navigationController?.navigationBar.barStyle = .black
           navigationController?.navigationBar.isTranslucent = false
           navigationController?.navigationBar.barTintColor = .themeColor
           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
           //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           navigationItem.title = "Guest Detail"
           navigationController?.navigationBar.tintColor = .white
           
    }
    
    func setupView(){
        nameLabel.text = attendee?.name
        bioLabel.text = attendee?.bio
        if let URLString = attendee?.profileImageURL{
            if let imageURL = URL(string: URLString){
                profileImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "APCC"), options: [.highPriority,.retryFailed,.continueInBackground], context: nil)
            }
        }
        separater.translatesAutoresizingMaskIntoConstraints = false
        aboutSeparater.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = attendee?.title
        separater.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        aboutSeparater.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        view.addSubview(nameLabel)
        view.addSubview(separater)
        view.addSubview(titleLabel)
        view.addSubview(profileImageView)
        view.addSubview(aboutSeparater)
        view.addSubview(aboutLabel)
        view.addSubview(bioLabel)
        view.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: nameLabel)
        view.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: separater)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        separater.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        profileImageView.topAnchor.constraint(equalTo: separater.bottomAnchor, constant: 25).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.19).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: separater.bottomAnchor, constant: 25).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        separater.heightAnchor.constraint(equalToConstant: 1).isActive = true
        profileImageView.layer.cornerRadius = (view.frame.width * 0.19)/2
        aboutLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        
        aboutSeparater.heightAnchor.constraint(equalToConstant: 1).isActive = true
        aboutSeparater.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        aboutSeparater.leadingAnchor.constraint(equalTo: aboutLabel.trailingAnchor, constant: 20).isActive = true
        aboutSeparater.centerYAnchor.constraint(equalTo: aboutLabel.centerYAnchor).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 20).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bioLabel.contentInset.bottom = 8
        
//
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.centerContentVertically()
    }
    
}
