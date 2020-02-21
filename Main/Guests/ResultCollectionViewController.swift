//
//  ResultCollectionViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/19/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ResultCollectionViewController: UICollectionViewController {

    var isFirstAppear = true
    
    var filteredBusinesses = [[Business]](){
        didSet{
            
        }
    }
    
    private let noResultLabel: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "No results found"
        iv.font = .systemFont(ofSize: cardFontSize, weight: .bold)
        iv.textColor = .lightGray
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    // initialized with a non-nil layout parameter
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if filteredBusinesses.count == 0{
            noResultLabel.isHidden = false
        } else {
            noResultLabel.isHidden = true
        }
//        if !isFirstAppear{
//            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        }
        collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.layoutIfNeeded()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("view did appear \(isFirstAppear)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        noResultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        noResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noResultLabel.sizeToFit()
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.extendedLayoutIncludesOpaqueBars = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView!.register(GuestCell.self, forCellWithReuseIdentifier: GuestCell.identifier)
        collectionView.register(GuestSectionHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: GuestSectionHeader.identifier)
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = 10
        }
        collectionView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && collectionView === self.collectionView{
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GuestSectionHeader.identifier, for: indexPath) as! GuestSectionHeader
                sectionHeader.label.isHidden = false
                sectionHeader.label.text = filteredBusinesses[indexPath.section].first?.businessHeader ?? ""
                sectionHeader.label.layoutIfNeeded()
            
            
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
        
    }


}

extension ResultCollectionViewController: UICollectionViewDelegateFlowLayout{
    


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 76)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredBusinesses.count
       }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBusinesses[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 34, height: 100)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuestCell.identifier, for: indexPath) as? GuestCell{
            cell.backgroundColor = .white
            cell.shadowDecorate()
            cell.businessnNameLabel.text =  filteredBusinesses[indexPath.section][indexPath.row].businessName
            cell.countryLabel.text =  filteredBusinesses[indexPath.section][indexPath.row].country
            cell.countryLabel.layoutIfNeeded()
            return cell
        }
    
        // Configure the cell
    
        return UICollectionViewCell()
    }
}
