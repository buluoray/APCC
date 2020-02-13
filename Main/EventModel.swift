//
//  EventModel.swift
//  APCC
//
//  Created by Yusheng Xu on 1/31/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//
import Foundation

struct Attendee: Hashable, Codable {
    var name: String?
    var imageName: String?
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

struct EventData: Hashable, Codable {
    

    var time: String?
    var title: String?
    var location: String?
    var imageURL: String?
    var speakers = [Attendee]()
    var header: String?
    var description: String?
    init(time: String, title:String, location: String, description: String) {
        self.title = title
        self.time = time
        self.location = location
        self.description = description
       
    }
    
    init() {

    }
    
//    init(time: String, title:String, location: String, imageName: String) {
//        self.title = title
//        self.time = time
//        self.location = location
//        self.imgaeName = imageName
//        //self.speaker = speaker
//    }
}

struct EventSection: Comparable, Codable {
    
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


struct EventDay: Codable {
    var eventSections = [EventSection]()
//    var json: Data? {
//        return try? JSONEncoder().encode(self)
//    }
}




