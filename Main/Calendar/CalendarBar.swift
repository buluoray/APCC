//
//  CalendarBar.swift
//  APCC
//
//  Created by Yusheng Xu on 1/22/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class CalendarBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let days = ["1","2","3","4","5","6","7"]
    let DisplayDate = "March 2019"
    let cellId = "cellId"
    var eventViewController: EventViewController?
    var eventView: EventView?
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var yearView: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "March 2019"
        ul.textAlignment = .center
        ul.font = .systemFont(ofSize: 12, weight: .bold)
        return ul
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //eventView = eventViewController?.eventView
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(yearView)
        addConstraintsWithFormat("H:|-12.5-[v0]-12.5-|", views: collectionView)
        addConstraintsWithFormat("H:|-12.5-[v0]-12.5-|", views: yearView)
        addConstraintsWithFormat("V:|[v1(21)][v0]-1.5-|", views: collectionView,yearView)
        
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        eventView = eventViewController?.eventView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventView?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DayCell
        cell.backgroundColor = .white
        cell.dayNumberView.text = days[indexPath.row]
        cell.dayInWeekView.text = week[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? DayCell{
            if eventView?.eventDays?.count != 0 {
                cell.eventDay = eventView?.eventDays![indexPath.item] ?? EventDay()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return (frame.width - 308.5) / 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.5, height: 49.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DayCell: BaseCell {
    
    var eventDay: EventDay?
    
    let dayNumberView: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "1"
        iv.textAlignment = .center
        iv.textColor = .white
        iv.font = .systemFont(ofSize: 20, weight: .bold)
        return iv
    }()
    
    
    let dayInWeekView: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "Sun"
        iv.textAlignment = .center
        iv.textColor = .black
        iv.font = .systemFont(ofSize: 10, weight: .semibold)
        
        return iv
    }()
    
    var circleView = UIView()
    
    override var isHighlighted: Bool {
        didSet {
            
            if eventDay?.eventSections.count == 0 {
                dayNumberView.textColor = isHighlighted ? .white : .lightGray
            } else {
                dayNumberView.textColor = isHighlighted ? .white : .black
            }
            circleView.backgroundColor = isHighlighted ? .themeColor : .clear
            layoutIfNeeded()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if eventDay?.eventSections.count == 0 {
                dayNumberView.textColor = isSelected ? .white : .lightGray
            } else {
                dayNumberView.textColor = isSelected ? .white : .black
            }
            
            circleView.backgroundColor = isSelected ? .themeColor : .clear
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if eventDay?.eventSections.count == 0 {
            dayNumberView.textColor = .lightGray
        } else {
            if isHighlighted || isSelected {
                dayNumberView.textColor = .white
            } else {
                dayNumberView.textColor = .black
            }
            
        }
        circleView.layer.cornerRadius = circleView.frame.width/2
    }
    
    func setupCircleView() {
        layoutIfNeeded()
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat("H:[v0(40.5)]", views: circleView)
        circleView.topAnchor.constraint(equalTo: dayNumberView.topAnchor).isActive = true
        circleView.bottomAnchor.constraint(equalTo: dayNumberView.bottomAnchor).isActive = true
        circleView.backgroundColor = .clear
        circleView.layer.cornerRadius = circleView.frame.width/2
        circleView.clipsToBounds = true
        sendSubviewToBack(circleView)
        //circleView.layer.borderWidth = 5.0

    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(dayNumberView)
        addSubview(dayInWeekView)
        addConstraintsWithFormat("H:[v0(40.5)]", views: dayInWeekView)
        addConstraintsWithFormat("H:[v0(40.5)]", views: dayNumberView)
        addConstraintsWithFormat("V:|[v1(8)]-1-[v0(40.5)]", views: dayNumberView, dayInWeekView)
        setupCircleView()
        if eventDay?.eventSections.count == 0 {
            dayNumberView.textColor = .lightGray
        } else {
            dayNumberView.textColor = .black
        }
    }
    
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

