//
//  ViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 1/22/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class EventViewController: UIViewController{

    
    var eventDays: [EventDay] = testData
    
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
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarBar()
        setupEventView()
        overrideUserInterfaceStyle = .light
        //navigationController?.overrideUserInterfaceStyle = .light
        //view.backgroundColor = .green
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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
