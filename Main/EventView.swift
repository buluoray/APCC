//
//  EventView.swift
//  APCC
//
//  Created by Yusheng Xu on 1/28/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class EventView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var events: [EventSection]?
    var eventViewController: EventViewController?
    let cellId = "cellId"
    //let sectionNumber: Int?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .brown
        cv.dataSource = self
        cv.delegate = self
        layout.minimumLineSpacing = 0
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(EventOverviewCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventOverviewCell
        cell.backgroundColor = .white
        cell.events = events
        return cell
    }
    
    
}

class EventOverviewCell: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    var events: [EventSection]?
    let cellId = "tablecellId"
    let data = ["test1","test2","test3"]
    var EventDetailTablecView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        //tv.backgroundColor = .brown
        tv.separatorStyle = .none
        
        return tv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        EventDetailTablecView.delegate = self
        EventDetailTablecView.dataSource = self

        EventDetailTablecView.register(EventDetailCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events![section].eventData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventDetailTablecView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventDetailCell
//        cell.textLabel?.text = data[indexPath.row]
//        cell.backgroundColor = .white
//        cell.imageView?.layer.masksToBounds = false
        cell.eventData = events![indexPath.section].eventData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    //MARK: Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let iv = UILabel(frame: CGRect(x: 15, y: 14.5, width: 105, height: 24))
        iv.text = events![section].sectionHeader
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        iv.textAlignment = .left
        iv.textColor = .themeColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backgroundView)
        headerView.addConstraintsWithFormat("H:|[v0]|", views: backgroundView)
        headerView.addConstraintsWithFormat("V:|[v0]|", views: backgroundView)
        headerView.addSubview(horizontalBarView)
        headerView.addSubview(iv)
        iv.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerView.addConstraintsWithFormat("H:|-15-[v0]", views: iv)
        horizontalBarView.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 10).isActive = true
        horizontalBarView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        horizontalBarView.backgroundColor = .rgb(red: 128, green: 128, blue: 128)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
    override func setupViews() {
        super.setupViews()
        EventDetailTablecView.register(EventDetailCell.self, forCellReuseIdentifier: cellId)
        addSubview(EventDetailTablecView)
        addConstraintsWithFormat("H:|[v0]|", views: EventDetailTablecView)
        addConstraintsWithFormat("V:|[v0]|", views: EventDetailTablecView)
    }
}
// MARK: EventDetailCell - Tableview
class EventDetailCell: BaseTableCell {
    

    var eventData: EventData? {
        didSet {
            guard let ev = eventData else { return }
            timeView.text = ev.time
            locationView.text = ev.location
            titleView.text = ev.title
            displayImageView.image = UIImage(named: "\(ev.imgaeName)")
        }
    }
    
    private let displayImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "sample1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        //iv.clipsToBounds = true
        iv.layer.masksToBounds = false
        iv.clipsToBounds = false
        iv.isUserInteractionEnabled = false
//        iv.layer.shadowColor = UIColor.black.cgColor
//        iv.layer.shadowRadius = 12
//        iv.layer.shadowOpacity = 1.0
//        iv.layer.shadowOffset = CGSize(width: 4, height: 4)
//        iv.layer.shadowPath = UIBezierPath(rect: iv.bounds).cgPath
        
        //iv.layer.cornerRadius = 12
        

        return iv
    }()
    
    private let timeView: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "10:00 AM - 12:00 PM"
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        iv.textColor = .white
        iv.textAlignment = .left
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    private let titleView: TextViewLabel = {
        let iv = TextViewLabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "China Regional Breakout Session"
        iv.textAlignment = .left
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        iv.textColor = .white
        iv.backgroundColor = .clear
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    private let locationView: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "HGB235"
        iv.font = .systemFont(ofSize: 14, weight: .bold)
        iv.textAlignment = .left
        iv.textColor = .white
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "location"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayImageView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 12)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(displayImageView)
        addSubview(timeView)
        addSubview(titleView)
        addSubview(locationView)
        addSubview(iconView)
        addConstraintsWithFormat("H:|-15-[v0]|", views: displayImageView)
        addConstraintsWithFormat("V:|-7.5-[v0]-7.5-|", views: displayImageView)
        addConstraintsWithFormat("H:|-30-[v0]", views: timeView)
        addConstraintsWithFormat("V:|-20-[v0(24)]-10-[v1(60)]-10-[v2]-20-|", views: timeView, titleView, locationView)
        addConstraintsWithFormat("H:|-30-[v0(280)]", views: titleView)
        addConstraintsWithFormat("H:|-30-[v1(14)]-6-[v0(250)]", views: locationView, iconView)
        NSLayoutConstraint.activate([iconView.topAnchor.constraint(equalTo: locationView.topAnchor, constant: 0),
        iconView.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0)
        ])
        setupGradientLayer()
        selectionStyle = .none

    }
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = displayImageView.frame
        gradientLayer.colors = [UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor, UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor]
        //gradientLayer.locations = [0.7, 1.2]
        displayImageView.layer.addSublayer(gradientLayer)
    }
}


// MARK: Supporting classes
class BaseTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension UIView {
func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    let rect = self.bounds
    mask.frame = rect
    mask.path = path.cgPath
    self.layer.mask = mask
}
}

class TextViewLabel: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() -> Void {
        isScrollEnabled = false
        isEditable = false
        isSelectable = false
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byTruncatingTail
        
    }
}


extension UITextView {
    func centerContentVertically() {
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let heightOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, heightOffset)
        contentOffset.y = -positiveTopOffset
    }
}
