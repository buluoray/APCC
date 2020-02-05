//
//  EventView.swift
//  APCC
//
//  Created by Yusheng Xu on 1/28/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class EventView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var calendarBar: CalendarBar?
    var eventDays: [EventDay]?
    var eventViewController: EventViewController?
    let cellId = "cellId"
    //let sectionNumber: Int?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        layout.minimumLineSpacing = 0
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override func layoutSubviews() {
        calendarBar = eventViewController?.calendarBar
        collectionView.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //calendarBar = eventViewController?.calendarBar
        collectionView.register(EventOverviewCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let eventDays = eventDays else { return 7 }
        return eventDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EventOverviewCell{
            cell.eventDay = eventDays?[indexPath.item]
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / frame.width
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        calendarBar?.collectionView.selectItem(at: indexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventOverviewCell
        cell.backgroundColor = .white

        guard let eventDays = eventDays
            else {
                //cell.eventDay = EventDay()
                print("error: No eventDays")
                return cell
        }
        //print("item: \(indexPath.item), row: \(indexPath.row)")
        cell.eventDay = eventDays[indexPath.row]
        cell.eventViewController = eventViewController
        return cell
    }
    
    
    
    
}
//MARK: Event Overview Cell
class EventOverviewCell: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    var eventViewController: EventViewController?
    var eventDay: EventDay?
    let cellId = "tablecellId"
    let headerId = "headerId"
    let data = ["test1","test2","test3"]
    var eventDetailTablecView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        //tv.backgroundColor = .brown
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        return tv
    }()
    
    var noEventView: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "No Events Today"
        iv.font = .systemFont(ofSize: 30, weight: .regular)
        iv.textColor = .lightGray
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        eventDetailTablecView.register(EventDetailCell.self, forCellReuseIdentifier: cellId)
        eventDetailTablecView.register(eventSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        addSubview(eventDetailTablecView)
        addSubview(noEventView)
        addConstraintsWithFormat("H:|[v0]|", views: eventDetailTablecView)
        addConstraintsWithFormat("V:|[v0]|", views: eventDetailTablecView)
        noEventView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        noEventView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        eventDetailTablecView.delegate = self
        eventDetailTablecView.dataSource = self

        
        if eventDay?.eventSections.count != 0 {
            noEventView.isHidden = true
        } else {
            noEventView.isHidden = false
        }
        eventDetailTablecView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventDay = eventDay
            else {
                return 0
        }
        return eventDay.eventSections[section].eventData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let eventDay = eventDay
            else {
                return 0
        }
        return eventDay.eventSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventDetailTablecView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventDetailCell

        guard eventDay != nil
            else {
                return cell
        }
        //cell.eventData = eventDay.eventSections[indexPath.section].eventData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? EventDetailCell{
            cell.eventData = eventDay?.eventSections[indexPath.section].eventData[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let eventDay = eventDay
            else {
                return
        }
         
        let eventVC = EventInfoViewController()
        eventVC.eventDetail = eventDay.eventSections[indexPath.section].eventData[indexPath.row]
        eventVC.hidesBottomBarWhenPushed = true
        eventViewController?.show(eventVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let eventDay = eventDay
            else {
                return UIView()
        }
        let eventHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! eventSectionHeaderView
        eventHeaderView.title = eventDay.eventSections[section].sectionHeader
        eventHeaderView.tableView = tableView
        return eventHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
            displayImageView.image = UIImage(named: "\(ev.imgaeName!)")
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
        iv.text = "N/A"
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
        addConstraintsWithFormat("V:|-20-[v0(24)]-10-[v1(60)]-10-[v2]-15-|", views: timeView, titleView, locationView)
        addConstraintsWithFormat("H:|-30-[v0(280)]", views: titleView)
        addConstraintsWithFormat("H:|-30-[v1(14)]-6-[v0(250)]", views: locationView, iconView)
        NSLayoutConstraint.activate([iconView.topAnchor.constraint(equalTo: locationView.topAnchor, constant: 0),
        iconView.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0)
        ])
        setupGradientLayer()
        selectionStyle = .none
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = displayImageView.frame
        gradientLayer.colors = [UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor, UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor]
        //gradientLayer.locations = [0.7, 1.2]
        displayImageView.layer.addSublayer(gradientLayer)
    }
}
//MARK: Header View
class eventSectionHeaderView: UITableViewHeaderFooterView {
    
    var title: String?
    var tableView: UITableView?
    let headerView = UIView(frame: .zero)
    let horizontalBarView = UIView(frame: .zero)
    let backgroundCoverView = UIView(frame: .zero)
    
    var headerLabel : UILabel =  {
        let iv = UILabel(frame: CGRect(x: 15, y: 14.5, width: 105, height: 24))
        iv.text = ""
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        iv.textAlignment = .left
        iv.textColor = .themeColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        if let title = title{
            headerLabel.text = title
            headerView.frame = CGRect(x: 0, y: 0, width: tableView!.frame.width, height: 50)
            headerView.addConstraintsWithFormat("H:|-15-[v0]", views: headerLabel)
        }
        
    }
    
    func setupViews(){
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCoverView.backgroundColor = .white
        backgroundCoverView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backgroundCoverView)
        headerView.addConstraintsWithFormat("H:|[v0]|", views: backgroundCoverView)
        headerView.addConstraintsWithFormat("V:|[v0]|", views: backgroundCoverView)
        headerView.addSubview(horizontalBarView)
        headerView.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        horizontalBarView.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 10).isActive = true
        horizontalBarView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        horizontalBarView.backgroundColor = .rgb(red: 128, green: 128, blue: 128)
        contentView.addSubview(headerView)
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
