//
//  GuestInfoViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/16/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage

class GuestInfoViewController: UIViewController {
    
    // Constants for state restoration.
    private static let restoreProduct = "restoreProductKey"
    
    private var business: Business!
    private lazy var guestInfoView: GuestInfoView = {
        let guestInfoView = GuestInfoView(frame: view.frame)
        
        return guestInfoView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        setupNav()
        setupView()
    }
    
    func setupView(){
        view.addSubview(guestInfoView)
        guestInfoView.collectionView.delegate = self
        guestInfoView.collectionView.dataSource = self
        guestInfoView.businessNameLabel.text = business?.businessName
        guestInfoView.businessDescriptionLabel.text = business?.businessDescription
        if let link = business?.promoLink{
            if let url = URL(string: link){
                let attributedString = NSMutableAttributedString(string: "Visit Website")
                let attributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light),
                    NSAttributedString.Key.foregroundColor: UIColor.themeColor,
                    NSAttributedString.Key.underlineColor: UIColor.clear,
                    NSAttributedString.Key.attachment:url ] as [NSAttributedString.Key : Any]
                attributedString.addAttributes(attributes, range: NSRange(location: 0, length: 13))
                guestInfoView.businessPromoLabel.attributedText = attributedString
                guestInfoView.businessPromoLabel.delegate = self
            }
        }
        guestInfoView.layoutIfNeeded()
    }
    
    func setupNav(){
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: nil, action: nil)
        navigationItem.title = "Guest Info"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    func setupModel(data: Business){
        self.business = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
}

extension GuestInfoViewController: LinkLabelDelegate{
    func openURl(url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredBarTintColor = #colorLiteral(red: 0.5490196078, green: 0, blue: 0.05490196078, alpha: 1)
        safari.preferredControlTintColor = .white
        safari.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(safari, animated: true, completion: nil)
    }
}

extension GuestInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return business?.attendee?.count ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuestInfoCell.identifier, for: indexPath) as? GuestInfoCell{
            cell.nameLabel.text = business?.attendee?[indexPath.row].name
            cell.titleLabel.text = business?.attendee?[indexPath.row].title
            
            if let URLString = business?.attendee?[indexPath.row].profileImageURL{
                if let imageURL = URL(string: URLString){
                    cell.profileImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "APCC"), options: [.highPriority,.retryFailed,.continueInBackground], context: nil)
                }
            }
            
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if business?.attendee?[indexPath.row].name != ""{
            let guestDetailVC = GuestDetailViewController()
            guestDetailVC.setupModel(data: (business?.attendee?[indexPath.row])!)
            navigationController?.pushViewController(guestDetailVC, animated: true)
        }
        
    }
    
    
}

extension GuestInfoViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        // Encode the product.
        coder.encode(business, forKey: GuestInfoViewController.restoreProduct)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Restore the product.
        if let decodedProduct = coder.decodeObject(forKey: GuestInfoViewController.restoreProduct) as? Business {
            business = decodedProduct
        } else {
            fatalError("A product did not exist. In your app, handle this gracefully.")
        }
    }
    
}
