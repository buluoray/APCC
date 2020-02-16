//
//  GuestViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/12/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class GuestViewController: UICollectionViewController {

    private let refreshControl = UIRefreshControl()
    private let guestModel = GuestModel()
    private var businesses: [[Business]]?{
        didSet{
            collectionView.reloadData()
            collectionView.refreshControl!.endRefreshing()
        }
    }
    
    // initialized with a non-nil layout parameter
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupRefreshControl()
        setupCollectionView()
        collectionView.register(GuestCell.self, forCellWithReuseIdentifier: GuestCell.identifier)
        //collectionView.register(GuestSectionHeader.self, forCellWithReuseIdentifier: GuestSectionHeader.identifier)
        collectionView.register(GuestSectionHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: GuestSectionHeader.identifier)
        guestModel.delegate = self
        guestModel.loadFromCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if businesses == nil{
            collectionView.refreshControl!.beginRefreshingManually()
        }
        
    }
    
    func setupRefreshControl(){
        
        refreshControl.tintColor = .themeColor
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: UIColor.themeColor
        ]
        refreshControl.attributedTitle = NSAttributedString(string: "Loading APCC Guests...", attributes: attributes)
        refreshControl.addTarget(guestModel, action: #selector(self.guestModel.fetchEmployee), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func setupCollectionView(){
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = 10
        }
        collectionView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        setupRefreshControl()

    }
    
    func setupNav(){
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Guests", style: .plain, target: nil, action: nil)
        navigationItem.title = "Guests"
    }

}

extension GuestViewController : UICollectionViewDelegateFlowLayout{

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GuestSectionHeader.identifier, for: indexPath) as! GuestSectionHeader
            sectionHeader.label.text = businesses?[indexPath.section].first?.businessHeader ?? ""
            sectionHeader.label.layoutIfNeeded()
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 76)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return businesses?.count ?? 0
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses?[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 34, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuestCell.identifier, for: indexPath) as? GuestCell{
            if let businesses = businesses{
                cell.backgroundColor = .white
                cell.shadowDecorate()
                cell.businessnNameLabel.text = businesses[indexPath.section][indexPath.row].businessName
                cell.countryLabel.text = businesses[indexPath.section][indexPath.row].country
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
}


extension GuestViewController: GuestModelDelegate {
    func failedLoadDataFromCache() {
        guestModel.fetchEmployee()
    }
    
    func didLoadDataFromCache(data: [[Business]]) {
        businesses = data
        print("Loaded from Cache")
    }
    
    func failedRecieveDataUpdate() {
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view, text: "Failed to update Guests:\nPlease check your internet connection")
        }
    }
    
    func didRecieveDataUpdate(data: [[Business]]) {
        businesses = data
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view, text: "Guests Updated")
        }
        print("Guests updated")
    }
    
}

