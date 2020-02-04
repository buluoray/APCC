//
//  EventModel.swift
//  APCC
//
//  Created by Yusheng Xu on 1/31/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//
import Foundation

struct EventData: Hashable {
    

    

    
    var time: String?
    var title: String?
    var location: String?
    var imgaeName: String?
    var speaker: String?
    var header: String?
    init(time: String, title:String, location: String, imageName: String) {
        self.title = title
        self.time = time
        self.location = location
        self.imgaeName = imageName
    }
    
    init() {

    }
    
    init(time: String, title:String, location: String, imageName: String, speaker: String) {
        self.title = title
        self.time = time
        self.location = location
        self.imgaeName = imageName
        self.speaker = speaker
    }
}

struct EventSection: Comparable {
    var eventData = [EventData]()
    var sectionHeader: String
    
    
    static func < (lhs: EventSection, rhs: EventSection) -> Bool {
        let left = lhs.sectionHeader
        let right = rhs.sectionHeader
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let leftDate = dateFormatter.date(from: left)!
        let rightDate = dateFormatter.date(from: right)!
        return leftDate < rightDate
    }
    
    init(sectionHeader: String, eventdata: [EventData]) {
        self.eventData = eventdata
        self.sectionHeader = sectionHeader
    }
}


struct EventDay {
    var eventSections = [EventSection]()
}
