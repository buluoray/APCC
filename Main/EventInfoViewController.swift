//
//  EventDetailViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var eventDetail: EventData?
    
    
    private let titleView: TextViewLabel = {
        let iv = TextViewLabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "China Regional Breakout Session"
        iv.textAlignment = .center
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        iv.textColor = .darkGray
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    var eventInfoTablecView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .brown
        tv.separatorStyle = .none
        
        return tv
    }()
    
    
    func setupViews(){
        view.addSubview(titleView)
        view.addSubview(eventInfoTablecView)
        view.addConstraintsWithFormat("H:|-45-[v0]-45-|", views: titleView)
        view.addConstraintsWithFormat("V:|-28-[v0]", views: titleView)
        view.addConstraintsWithFormat("H:|[v0]|", views: eventInfoTablecView)
        eventInfoTablecView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 28).isActive = true
        eventInfoTablecView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        titleView.text = eventDetail?.title
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationItem.title = "Event Detail"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Detail", style: .plain, target: nil, action: nil)
        view.backgroundColor = .white
        print(eventDetail!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}



