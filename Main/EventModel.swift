//
//  EventModel.swift
//  APCC
//
//  Created by Yusheng Xu on 1/31/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

struct EventData {
    var time: String
    var title: String
    var location: String
    var imgaeName: String
    var speaker: String?
    init(time: String, title:String, location: String, imageName: String) {
        self.title = title
        self.time = time
        self.location = location
        self.imgaeName = imageName
    }
    
    init(time: String, title:String, location: String, imageName: String, speaker: String) {
        self.title = title
        self.time = time
        self.location = location
        self.imgaeName = imageName
        self.speaker = speaker
    }
}

struct EventSection {
    var eventData: [EventData]
    var sectionHeader: String
    
    init(sectionHeader: String, eventdata: [EventData]) {
        self.eventData = eventdata
        self.sectionHeader = sectionHeader
    }
}


struct EventDay {
    var eventSections: [EventSection]?
}
