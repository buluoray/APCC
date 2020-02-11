//
//  ViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 1/22/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import Foundation
class EventViewController: UIViewController{

    
    var eventDays = [EventDay]()
    
    lazy var calendarBar: CalendarBar = {
        let cb = CalendarBar()
        cb.eventViewController = self
        return cb
    }()
    
    lazy var eventView: EventView = {
        let ev = EventView()
        ev.eventViewController = self
        ev.eventDays = eventDays
        return ev
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarBar()
        setupEventView()
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Calendar", style: .plain, target: nil, action: nil)
        navigationItem.title = "APCC Calendar"
        fetchEvents()
    }
    
    func handleClientError(error:Error){

        DispatchQueue.main.sync {
            let alert = UIAlertController(title: "Failed to load events", message: "\(error.localizedDescription)" , preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
             self.fetchEvents()
            }))
            self.present(alert, animated: true)
        }
    }
    
    @objc func fetchEvents() {
        showSpinner(onView: self.view)
                // load Schedule data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let schedule_Request = Schedule_Request()
            schedule_Request.getVenders{ [weak self] result in
                switch result {
                case .failure(let error):
                    self!.removeSpinner()
                    self!.handleClientError(error: error)
                case .success(let schedule):
                    self!.makeModel(schedule: schedule)
                    
                }
            }

        }
    }
    
    func makeModel(schedule: ([ScItem])){
        var eventDaysContainer = [EventDay]()
        var tempEventDatas: [[EventData]] = [[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData]()]
        let employerSchedule = schedule.filter{ ($0.Item.Type?.S.contains("Employer’s and Universities schedule"))! }
        for event in employerSchedule {
            if let eventDateFormat = event.Item.Date?.S {
                let day = eventDateFormat.subString(from: 2, to: 2)
                let header = event.Item.Time?.S.matches(for: "^\\d*:\\d*\\s\\w\\w").first
                //print(header)
                var eventData = EventData(time: event.Item.Time?.S ?? "N/A", title: event.Item.Content?.S ?? "N/A", location: event.Item.Location?.S ?? "N/A", imageName: "sample1",description: event.Item.Description?.S ?? "N/A")
                if let imageURL = event.Item.Image?.S{
                    eventData.imageURL = imageURL
                }
                eventData.header = header
                tempEventDatas[Int(day)! - 1].append(eventData)
            }
        }
        for temp in tempEventDatas{
            // Group the EventDatas into subarrays by header
            let headerGroups = Array(Dictionary(grouping:temp){$0.header}.values)
            var tempEventDay = EventDay()
            for section in headerGroups{
                let tempSection = EventSection(sectionHeader: section.first?.header ?? "", eventdata: section)
                tempEventDay.eventSections.append(tempSection)
            }
            tempEventDay.eventSections.sort(by: { $0 < $1 })
            eventDaysContainer.append(tempEventDay)
        }
        
        eventDays = eventDaysContainer
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.eventView.eventDays = self.eventDays
            self.eventView.collectionView.reloadData()
            self.calendarBar.collectionView.reloadData()
            let selectedIndexPath = NSIndexPath(item: 3, section: 0)
            self.eventView.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.calendarBar.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.removeSpinner()
            //print(self.eventView.eventDays)
        }
        //print(eventDays)
    }

    
//
    private func setupCalendarBar(){
        view.addSubview(calendarBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: calendarBar)
        view.addConstraintsWithFormat("V:|[v0(72)]", views: calendarBar)
    }
    
    private func setupEventView(){
        view.addSubview(eventView)
        view.addConstraintsWithFormat("H:|[v0]|", views: eventView)
        NSLayoutConstraint.activate([eventView.topAnchor.constraint(equalTo: calendarBar.bottomAnchor, constant: 0),
                                     eventView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
                                     ])
    }
    
}

extension UICollectionView {
    func reload(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}

extension UIView {
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static var themeColor = #colorLiteral(red: 0.568627451, green: 0.1607843137, blue: 0.2156862745, alpha: 1)
    
    static var naviColor = #colorLiteral(red: 0.4901960784, green: 0.003921568627, blue: 0.07058823529, alpha: 1)
    
    static var platformBlue = #colorLiteral(red: 0.2784313725, green: 0.2666666667, blue: 0.8901960784, alpha: 1)
    
    static var dateColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
    
    static var navColor = UIColor.rgb(red: 249, green: 249, blue: 255)
}

extension UIScrollView {

    func resizeScrollViewContentSize() {

        var contentRect = CGRect.zero

        for view in self.subviews {

            contentRect = contentRect.union(view.frame)

        }

        self.contentSize = contentRect.size

    }

}

extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex...endIndex])
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let text = self as NSString
            let results = regex.matches(in: self,options: [], range: NSRange(location:0,length: text.length))
            return results.map {
                text.substring(with: $0.range)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView(frame: .zero)
        //print(spinnerView.frame)
        spinnerView.backgroundColor = #colorLiteral(red: 0.9409832358, green: 0.9353893399, blue: 0.9452831149, alpha: 1)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        ai.color = .themeColor
        ai.translatesAutoresizingMaskIntoConstraints = false
        let iv = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = "Loading Events"
        iv.numberOfLines = 1
        iv.adjustsFontSizeToFitWidth = true
        iv.textColor = .themeColor
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        iv.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            spinnerView.addSubview(iv)
            onView.addSubview(spinnerView)
            ai.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
            ai.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
            iv.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor, constant: 40).isActive = true
            iv.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
            spinnerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            spinnerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            spinnerView.centerYAnchor.constraint(equalTo: onView.centerYAnchor).isActive = true
            spinnerView.centerXAnchor.constraint(equalTo: onView.centerXAnchor).isActive = true
        }
        vSpinner = spinnerView
        vSpinner?.layer.cornerRadius = 12
//        vSpinner?.centerYAnchor.constraint(equalTo: onView.centerYAnchor).isActive = true
//        vSpinner?.centerXAnchor.constraint(equalTo: onView.centerXAnchor).isActive = true
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func addActivityIndicatorToView(activityIndicator: UIActivityIndicatorView, view: UIView){

        self.view.addSubview(activityIndicator)

        //Don't forget this line
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))

        activityIndicator.startAnimating()

    }
}

extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        
        sendActions(for: UIControl.Event.valueChanged)
    }
}
