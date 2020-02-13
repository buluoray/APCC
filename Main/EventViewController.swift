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

    
    var eventDays = [EventDay](){
        didSet{
            eventView.eventDays = eventDays
            if let selectedIndexPath = calendarBar.collectionView.indexPathsForSelectedItems?.first{
                eventView.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                calendarBar.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    var employerData = [EventDay]()
    var studentData = [EventDay]()
    
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
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitchView()
        setupCalendarBar()
        setupEventView()
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Calendar", style: .plain, target: nil, action: nil)
        navigationItem.title = "Loading..."
//        if UserDefaults.standard.bool(forKey: "isShowingStudent") {
//            navigationItem.title = "Student Calendar"
//            self.navigationItem.rightBarButtonItem?.title = "Employer"
//        } else {
//            navigationItem.title = "Employer Calendar"
//            self.navigationItem.rightBarButtonItem?.title = "Student"
//        }

        fetchEvents()
    }
    
    func setupSwitchView(){
        let rightBarButtonItem = UIBarButtonItem(
        title: "",
        style: .plain,
        target: self,
        action: #selector(switchCalender_tapped))
        rightBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func switchCalender_tapped(){

        if !UserDefaults.standard.bool(forKey: "isShowingStudent") {
            self.navigationItem.rightBarButtonItem?.title = "Employer"
            navigationItem.title = "Student Calendar"
            eventDays = studentData
            UserDefaults.standard.set(true, forKey: "isShowingStudent")
        }else {
            self.navigationItem.rightBarButtonItem?.title = "Student"
            eventDays = employerData
            navigationItem.title = "Employer Calendar"
            UserDefaults.standard.set(false, forKey: "isShowingStudent")
        }
        
    }
    
    func handleClientError(error:Error){


        DispatchQueue.main.sync {
            let alert = UIAlertController(title: "Failed to load events", message: "Please check you internet connection and try again." , preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                DispatchQueue.main.async{
                    if let cell = self.eventView.collectionView.visibleCells.first as? EventOverviewCell {
                        print("succeed")
                        cell.eventDetailTablecView.refreshControl?.endRefreshing()
                    }
                }}))
            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
             self.fetchEvents()
            }))

            self.present(alert, animated: true)
        }
        
    }
    
    @objc func fetchEvents() {
        
        
                // load Schedule data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let schedule_Request = Schedule_Request()
            schedule_Request.getVenders{ [weak self] result in
                switch result {
                case .failure(let error):
                    //self!.removeSpinner()
                    DispatchQueue.main.async {
                        self!.showSpinner(onView: self!.view, text: "Failed to update events:\nPlease check your internet connection")
                        if let cell = self!.eventView.collectionView.visibleCells.first as? EventOverviewCell {
                            print("succeed")
                            cell.eventDetailTablecView.refreshControl?.endRefreshing()
                        }
                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        self!.removeSpinner()
//
//                    }
                    
                    //self!.handleClientError(error: error)
                case .success(let schedule):
                    self!.makeModel(schedule: schedule)
                    
                }
            }

        }
    }
    
    func makeModel(schedule: ([ScItem])){
        var eventDaysContainer = [EventDay]()
        var tempEventDatas: [[EventData]] = [[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData]()]
        //Filter employer
        let employerSchedule = schedule.filter{ ($0.Item.Type?.S.contains("Employer’s and Universities schedule"))! }
        //Loop Through employers
        for event in employerSchedule {
            if let eventDateFormat = event.Item.Date?.S {
                let day = eventDateFormat.subString(from: 2, to: 2)
                let header = event.Item.Time?.S.matches(for: "^\\d*:\\d*\\s\\w\\w").first
                //print(header)
                var eventData = EventData(time: event.Item.Time?.S ?? "N/A", title: event.Item.Content?.S ?? "N/A", location: event.Item.Location?.S ?? "N/A",description: event.Item.Description?.S ?? "N/A")
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
        
        employerData = eventDaysContainer
        eventDaysContainer = [EventDay]()
        tempEventDatas = [[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData](),[EventData]()]
        //Filter student
        let studentSchedule = schedule.filter{ ($0.Item.Type?.S.contains("Student Schedule"))! }

        //Loop through student
        for event in studentSchedule {
            if let eventDateFormat = event.Item.Date?.S {
                let day = eventDateFormat.subString(from: 2, to: 2)
                let header = event.Item.Time?.S.matches(for: "^\\d*:\\d*\\s\\w\\w").first
                //print(header)
                var eventData = EventData(time: event.Item.Time?.S ?? "N/A", title: event.Item.Content?.S ?? "N/A", location: event.Item.Location?.S ?? "N/A",description: event.Item.Description?.S ?? "N/A")
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
        studentData = eventDaysContainer

        saveEventDaysToFile(eventdays: studentData, filename: "studentData.json")
        saveEventDaysToFile(eventdays: employerData, filename: "employerData.json")
        
        DispatchQueue.main.async{
            if let cell = self.eventView.collectionView.visibleCells.first as? EventOverviewCell {
                print("succeed loaded from web")
                cell.eventDetailTablecView.refreshControl?.endRefreshing()
            }
            self.eventDays = !UserDefaults.standard.bool(forKey: "isShowingStudent") ? self.employerData : self.studentData
            self.showSpinner(onView: self.view, text: "APCC events updated")
        }
        //print(eventDays)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if let sd = readEventDaysFromFile(filename: "studentData.json"){
            studentData = sd
        }
        if let ed = readEventDaysFromFile(filename: "employerData.json"){
            employerData = ed
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if UserDefaults.standard.bool(forKey: "isShowingStudent") {
                self.navigationItem.title = "Student Calendar"
                self.navigationItem.rightBarButtonItem?.title = "Employer"
            } else {
                self.navigationItem.title = "Employer Calendar"
                self.navigationItem.rightBarButtonItem?.title = "Student"
            }
            self.eventDays = !UserDefaults.standard.bool(forKey: "isShowingStudent") ? self.employerData : self.studentData
            self.eventView.collectionView.reloadData()
            self.calendarBar.collectionView.reloadData()
            let selectedIndexPath = NSIndexPath(item: 3, section: 0)
            self.eventView.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.calendarBar.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
            

            //self.removeSpinner()
            //print(self.eventView.eventDays)
        }
        
    }
    
    func readEventDaysFromFile(filename: String) -> [EventDay]?{
        let jsonDecoder = JSONDecoder()
        if let url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(filename){
            do {
                if let jsonData = try? Data(contentsOf: url){
                let decodedData = try jsonDecoder.decode([EventDay].self, from: jsonData)
                    print("\(filename) loaded successfully")
                    return decodedData
            }
            } catch let error {
                print("couldn't load: \(filename), error: \(error)")
            }
            
        }
        return nil
    }
    
    func saveEventDaysToFile(eventdays: [EventDay], filename: String){
        let jsonEncoder = JSONEncoder()
        var jsonData: Data?
        do {
            jsonData = try jsonEncoder.encode(eventdays)
            //let jsonString = String(data: jsonData!, encoding: .utf8)
            if let url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(filename){
                do {
                    try jsonData?.write(to: url)
                    print("\(filename) saved successfuly")
                } catch let error {
                    print("couldn't save: \(filename), error: \(error)")
                }
                
            }
            //print("JSON String : " + jsonString!)
        }
        catch {
        }
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
    func showSpinner(onView : UIView, text: String) {
        let spinnerView = UIView(frame: .zero)
        spinnerView.backgroundColor = .themeColor
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let iv = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.text = text
        iv.numberOfLines = 2
        iv.adjustsFontSizeToFitWidth = true
        iv.textColor = .white
        iv.textAlignment = .center
        iv.isUserInteractionEnabled = false
        iv.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(iv)
            onView.addSubview(spinnerView)
            iv.heightAnchor.constraint(equalTo: spinnerView.heightAnchor).isActive = true
            iv.widthAnchor.constraint(equalTo: spinnerView.widthAnchor).isActive = true
            iv.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
            iv.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
            spinnerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            spinnerView.widthAnchor.constraint(equalTo: onView.widthAnchor).isActive = true
            spinnerView.bottomAnchor.constraint(equalTo: onView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            spinnerView.alpha = 0.0
            UIView.animate(withDuration: 0.2, animations: {spinnerView.alpha = 1.0})
        }
        vSpinner = spinnerView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.2, animations: {vSpinner?.alpha = 0.0},
            completion: {(value: Bool) in
                          vSpinner?.removeFromSuperview()
                vSpinner = nil
                        })
            
            
        }
    }
    
    func removeSpinner() {
        
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
        
        //sendActions(for: UIControl.Event.valueChanged)
    }
}
