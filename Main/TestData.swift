//
//  TestData.swift
//  APCC
//
//  Created by Yusheng Xu on 1/31/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

var section1: EventSection = EventSection(sectionHeader: "10:00 AM", eventdata:
    [EventData(time: "10:00 AM - 12:00 PM", title: "China Regional Breakout Session", location: "HGB 235", imageName: "sample1", speaker: "John Tanner"),
         EventData(time: "10:00 AM - 1:30 PM", title: "Interviewing", location: "ACR 160", imageName: "sample2")])

var section2: EventSection = EventSection(sectionHeader: "12:00 AM", eventdata:
        [EventData(time: "12:00 PM - 2:30 PM", title: "Career Fair", location: "ACR Ballroom", imageName: "sample3")])

var section3: EventSection = EventSection(sectionHeader: "9:00 AM", eventdata:
        [EventData(time: "9:00 AM - 11:00 AM", title: "Keynote Address", location: "PCC Hawaiian Journey IMAX", imageName: "sample5")])

var section4: EventSection = EventSection(sectionHeader: "1:00 PM", eventdata:
        [EventData(time: "1:00 PM - 2:00 PM", title: "Accenture", location: "ACR 150", imageName: "sample6"),
         EventData(time: "1:00 PM - 2:00 PM", title: "Experiential Learning", location: "HGB 133", imageName: "sample8"),
         EventData(time: "1:00 PM - 2:00 PM", title: "Microsoft", location: "HGB 235", imageName: "sample7")])

var section5: EventSection = EventSection(sectionHeader: "8:00 PM", eventdata:
        [EventData(time: "8:00 PM - 11:0 PM", title: "Entertainment", location: "Courtyard by Marriott", imageName: "sample4")])


var testData: [EventDay] = [EventDay(),EventDay(eventSections: [section1, section2, section5]),EventDay(eventSections: [section3,section4]),EventDay(),EventDay(),EventDay(),EventDay()]
