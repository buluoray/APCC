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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var yearView: UILabel = {
       let ul = UILabel()
        ul.text = "March 2019"
        ul.textAlignment = .center
        ul.font = .systemFont(ofSize: 12, weight: .bold)
        return ul
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(yearView)
        addConstraintsWithFormat("H:|-12.5-[v0]-12.5-|", views: collectionView)
        addConstraintsWithFormat("H:|-12.5-[v0]-12.5-|", views: yearView)
        addConstraintsWithFormat("V:|[v1(21)][v0]-1.5-|", views: collectionView,yearView)
        
        //backgroundColor = .blue
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.5, height: 49.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DayCell: BaseCell {
    
    let dayNumberView: UILabel = {
        let iv = UILabel()
        iv.text = "1"
        iv.textAlignment = .center
        iv.textColor = .darkGray
        return iv
    }()
    
    let dayInWeekView: UILabel = {
        let iv = UILabel()
        iv.text = "Sun"
        iv.textAlignment = .center
        iv.textColor = .black
        iv.font = .systemFont(ofSize: 10, weight: .semibold)
        
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            dayNumberView.textColor = isHighlighted ? UIColor.rgb(red: 255, green: 51, blue: 102) : .darkGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            dayNumberView.textColor = isSelected ? UIColor.rgb(red: 255, green: 51, blue: 102) : .darkGray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(dayNumberView)
        addSubview(dayInWeekView)
        addConstraintsWithFormat("H:[v0(40.5)]", views: dayInWeekView)
        addConstraintsWithFormat("H:[v0(40.5)]", views: dayNumberView)
        addConstraintsWithFormat("V:|[v1(8)]-1-[v0(40.5)]|", views: dayNumberView, dayInWeekView)

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

