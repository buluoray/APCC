//
//  EventDetailViewModel.swift
//  APCC
//
//  Created by Yusheng Xu on 2/7/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation
import UIKit

enum EventDetailViewModelItemType {
   case speaker
   case timeAndLocation
   case description
   case addToPlan
}

protocol EventDetailViewModelItem {
    var type: EventDetailViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

extension EventDetailViewModelItem {
   var rowCount: Int {
      return 1
   }
}

class EventDetailViewModelSpeakerItem: EventDetailViewModelItem {
   var type: EventDetailViewModelItemType {
      return .speaker
   }
   var sectionTitle: String {
      return "Speaker"
   }
    var spkearCount: Int {
       return speakers.count
    }
    
    var speakers: [Attendee]
    init(speakers: [Attendee]) {
       self.speakers = speakers
    }
    
}

class EventDetailViewModelTimeAndLocationItem: EventDetailViewModelItem {
   var type: EventDetailViewModelItemType {
      return .timeAndLocation
   }
   var sectionTitle: String {
      return "Time & Location"
   }
   var timeAndLocation: String
  
   init(timeAndLocation: String) {
      self.timeAndLocation = timeAndLocation
   }
}
class EventDetailViewModelDescriptionItem: EventDetailViewModelItem {
   var type: EventDetailViewModelItemType {
      return .description
   }
   var sectionTitle: String {
      return "Description"
   }
   var description: String
   init(description: String) {
      self.description = description
   }
}
class EventDetailViewModelAddToPlanItem: EventDetailViewModelItem {
    var type: EventDetailViewModelItemType {
      return .addToPlan
    }
    var sectionTitle: String {
      return "Add To My Plan"
    }
    var addToPlan: String
    init(addToPlan: String) {
       self.addToPlan = addToPlan
    }

}
class EventDetailViewModel: NSObject {
    var items = [EventDetailViewModelItem]()
    var eventDetail: EventData?
    init(eventDetail: EventData) {
        super.init()
        self.eventDetail = eventDetail
        let speakers = eventDetail.speakers
        if speakers.count != 0{
            let speakerItem = EventDetailViewModelSpeakerItem(speakers: speakers)
            items.append(speakerItem)
        }
        
        if let time = eventDetail.time, let location = eventDetail.location {
            let timeAndLocationItem = EventDetailViewModelTimeAndLocationItem(timeAndLocation: "\(time)\n\(location)")
            items.append(timeAndLocationItem)
        }
        
        if let description = eventDetail.description{
            let descriptionItem = EventDetailViewModelDescriptionItem(description: description)
            items.append(descriptionItem)
        }
        
        
        
    }
}

extension EventDetailViewModel: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items[section].rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        if item.type == .timeAndLocation{
            if let cell = tableView.dequeueReusableCell(withIdentifier: TimeAndLocationCell.identifier, for: indexPath) as? TimeAndLocationCell {
              cell.item = item
              return cell
            }
        } else if item.type == .description {
            if let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier, for: indexPath) as? DescriptionCell {
                cell.item = item
                return cell
            }

        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let eventHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventSectionHeaderView.identifier) as? EventSectionHeaderView{
            return eventHeaderView
        }
        print("failed")
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         if let eventHeaderView = view as? EventSectionHeaderView{
            eventHeaderView.title = items[section].sectionTitle
            eventHeaderView.tableView = tableView
            eventHeaderView.headerLabel.textColor = .darkGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
