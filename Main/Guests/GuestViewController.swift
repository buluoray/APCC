//
//  GuestViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/12/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import SDWebImage
class GuestViewController: UICollectionViewController {
    
    /// Search controller to help us with filtering items in the table view.
    var searchController: UISearchController!
    var isFetching = true
    /// Search results table view.
    private var resultCollectionController: ResultCollectionViewController!
    
    /// Restoration state for UISearchController
    var restoredState = SearchControllerRestorableState()
    
    private let refreshControl = UIRefreshControl()
    private let guestModel = GuestModel()
    var businesses: [[Business]]?{
        didSet{
            
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                   self.collectionView.reloadData()
                }
                
                self.collectionView.refreshControl!.endRefreshing()
            }
            //collectionView.refreshControl!.endRefreshing()
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
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .white
        setupNav()
        setupSearch()
        setupRefreshControl()
        setupCollectionView()
        collectionView.register(GuestCell.self, forCellWithReuseIdentifier: GuestCell.identifier)
        collectionView.register(GuestSectionHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: GuestSectionHeader.identifier)
        guestModel.delegate = self
        guestModel.loadFromCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
        resultCollectionController.collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black 
        // Restore the searchController's active state.
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
        collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
        resultCollectionController.collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
        
        if businesses == nil{
            isFetching = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.isFetching{
                    self.collectionView.refreshControl!.beginRefreshingManually()
                }
                
            
            }
        }
        
        if self.collectionView.refreshControl!.isRefreshing && !isFetching{
            DispatchQueue.main.async {
                print("end refresh")
                self.collectionView.refreshControl!.endRefreshing()
                
            }
        }
        
        
    }
    
    func setupSearch(){
        
        resultCollectionController = ResultCollectionViewController()
        resultCollectionController.collectionView.delegate = self
        //resultCollectionController.collectionView.dataSource = self
        searchController = UISearchController(searchResultsController: resultCollectionController)
        searchController.searchBar.returnKeyType = .done
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        //searchController.searchBar.scopeButtonTitles = ["All", "Guests", "Areas"]
        
//        searchController.extendedLayoutIncludesOpaqueBars = true
//    searchController.searchBar.setScopeBarButtonBackgroundImage(UIImage.imageWithColor(color: #colorLiteral(red: 0.9822720885, green: 0.1172304228, blue: 0.2961473465, alpha: 0.5501391267)), for: .normal)
//    searchController.searchBar.setScopeBarButtonBackgroundImage(UIImage.imageWithColor(color: #colorLiteral(red: 0.9693912864, green: 0.9695298076, blue: 0.9454818368, alpha: 1)), for: .selected)

        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.backgroundColor = .white
        }
        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchController.searchBar)]).tintColor = .darkGray
        //----Placeholder text-------
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Guests", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    
        //----"Cancel" button color----
        searchController.searchBar.tintColor = UIColor.white
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
             This means that the presentation moves up the view controller hierarchy until it finds the root
             view controller or one that defines a presentation context.
         */
         
         /** Specify that this view controller determines how the search controller is presented.
             The search controller should be presented modally and match the physical size of this view controller.
         */
         definesPresentationContext = true
    }
    
    func setupRefreshControl(){
        
        refreshControl.tintColor = .white
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        refreshControl.attributedTitle = NSAttributedString(string: "Loading APCC Guests...", attributes: attributes)
        refreshControl.addTarget(guestModel, action: #selector(self.guestModel.fetchEmployee), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func setupCollectionView(){
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = 10
        }
        //collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        setupRefreshControl()

    }
    
    func setupNav(){
        //navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.largeTitleTextAttributes =
        [.foregroundColor: UIColor.themeColor]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Guests", style: .plain, target: nil, action: nil)
        title = "Guests"
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .themeColor
            navBarAppearance.shadowColor = .themeColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }

}

extension GuestViewController : UICollectionViewDelegateFlowLayout{

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView === self.collectionView{
            
            let cell = cell as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedBusiness: Business!
        
        if collectionView === self.collectionView{
            selectedBusiness = businesses![indexPath.section][indexPath.row]
        } else {
            print(indexPath.row)
            selectedBusiness = resultCollectionController.filteredBusinesses[indexPath.section][indexPath.row]
            resultCollectionController.isFirstAppear = false
        }
        let guestInfoVC = GuestInfoViewController()
        guestInfoVC.setupModel(data: selectedBusiness)
        guestInfoVC.navigationItem.largeTitleDisplayMode = .never

        guestInfoVC.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.pushViewController(guestInfoVC, animated: true)
    }
    
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
                cell.businessnNameLabel.text =  businesses[indexPath.section][indexPath.row].businessName
                cell.countryLabel.text =  businesses[indexPath.section][indexPath.row].country
                cell.countryLabel.layoutIfNeeded()
                if let URLString = businesses[indexPath.section][indexPath.row].businessLogo{
                    if URLString != ""{
                        if let imageURL = URL(string: URLString){
                            cell.iconView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "APCC"), options: [.highPriority,.retryFailed,.continueInBackground], context: nil)
                        }
                    }

                }
                
                return cell
            }
        }
        return UICollectionViewCell()
    }


    
}


extension GuestViewController: GuestModelDelegate {
    func failedLoadDataFromCache() {
        isFetching = true
        guestModel.fetchEmployee()
        
    }
    
    func didLoadDataFromCache(data: [[Business]]) {
        businesses = data
        isFetching = false
        print("Loaded from Cache")
    }
    
    func failedRecieveDataUpdate() {
        print("failed to receive data")
        isFetching = false
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
            self.showSpinner(onView: self.view, text: "Failed to update Guests:\nPlease check your internet connection")
            self.collectionView.refreshControl!.endRefreshing()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
//
//            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func didRecieveDataUpdate(data: [[Business]]) {
        isFetching = false
        businesses = data
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view, text: "\(self.businesses?.joined().count ?? 0) Guests Updated")
        }
        print("Guests updated")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        vSpinner?.removeFromSuperview()
        vSpinner = nil
        collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
        resultCollectionController.collectionView.visibleCells.forEach{
            let cell = $0 as? GuestCell
            cell?.countryLabel.centerContentVertically()
        }
    }
    
}





// MARK: - UISearchBarDelegate

extension GuestViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    
    
}

extension GuestViewController: TabBarReselectHandling {
    func handleReselect() {
        
        if searchController.isActive{
            resultCollectionController.collectionView.scrollToTop(true)
        } else {
            collectionView.scrollToTop(true)
        }
        
    }
}


extension UIScrollView {
    func scrollToTop(_ animated: Bool) {
        var topContentOffset: CGPoint
        if #available(iOS 11.0, *) {
            topContentOffset = CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top)
        } else {
            topContentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
        }

        setContentOffset(topContentOffset, animated: animated)
        
    }
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension GuestViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
        if #available(iOS 13, *){
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
        if #available(iOS 13, *){
            self.navigationController?.navigationBar.isTranslucent = false
        }
        resultCollectionController.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        resultCollectionController.isFirstAppear = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
        if resultCollectionController.isFirstAppear{
            
            resultCollectionController.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    

    
    func didDismissSearchController(_ searchController: UISearchController) {
        Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}
