//
//  EventDetailViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit


class EventInfoViewController: UIViewController {

    fileprivate var viewModel: EventDetailViewModel?
    var eventDetail: EventData?
    
    private let titleView: TextViewLabel = {
        let iv = TextViewLabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "China Regional Breakout Session"
        iv.textAlignment = .center
        iv.font = UIFont(name: "Athelas-Bold", size: 20)
        iv.textColor = .darkGray
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    var eventInfoTablecView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.allowsSelection = false
        return tv
    }()
    
    
    func setupViews(){
        view.addSubview(titleView)
        view.addSubview(eventInfoTablecView)
        view.addConstraintsWithFormat("H:|-45-[v0]-45-|", views: titleView)
        view.addConstraintsWithFormat("V:|-28-[v0]", views: titleView)
        view.addConstraintsWithFormat("H:|[v0]|", views: eventInfoTablecView)
        eventInfoTablecView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 14).isActive = true
        eventInfoTablecView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        titleView.text = eventDetail?.title?.uppercased()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationItem.title = "Event Detail"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Detail", style: .plain, target: nil, action: nil)
        view.backgroundColor = .white
        //print(eventDetail!)
        viewModel = EventDetailViewModel(eventDetail: eventDetail!)
        eventInfoTablecView.dataSource = viewModel
        eventInfoTablecView.delegate = viewModel
        eventInfoTablecView.estimatedRowHeight = 130
//        eventInfoTablecView.rowHeight = UITableView.automaticDimension
        eventInfoTablecView.register(TimeAndLocationCell.self, forCellReuseIdentifier: TimeAndLocationCell.identifier)
        eventInfoTablecView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        eventInfoTablecView.register(EventSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: EventSectionHeaderView.identifier)
        
    }
    
}

class TimeAndLocationCell: BaseTableCell {
    var item: EventDetailViewModelItem? {
        didSet {
            guard let item = item as? EventDetailViewModelTimeAndLocationItem else {
                return
            }
            titleView.text = item.timeAndLocation
        }
    }
    
    override func layoutSubviews() {
        titleView.centerContentVertically()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let titleView: TextViewLabel = {
        let iv = TextViewLabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.textAlignment = .center
        iv.font = .preferredFont(forTextStyle: .headline)
        iv.textColor = .darkGray
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = false
        iv.font = UIFont(name: "Athelas", size: 20)
        return iv
    }()
    
    override func setupViews() {
        contentView.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
    }
}

class DescriptionCell: BaseTableCell {
    var item: EventDetailViewModelItem? {
        didSet {
            guard let item = item as? EventDetailViewModelDescriptionItem else {
                return
            }
            titleView.text = item.description
            
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let titleView: TextViewLabel = {
        let iv = TextViewLabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.textAlignment = .left
        iv.font = UIFont(name: "Athelas-Regular", size: 19)
        iv.textColor = .darkGray
        iv.backgroundColor = .clear
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    override func setupViews() {
        backgroundColor = .white
        contentView.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}




