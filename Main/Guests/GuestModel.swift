//
//  GuestModel.swift
//  APCC
//
//  Created by Yusheng Xu on 2/14/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation

struct Business: Codable, Comparable {
    static func < (lhs: Business, rhs: Business) -> Bool {
        return lhs.businessName!.lowercased() < rhs.businessName!.lowercased()
    }
    
    var businessName: String?
    var businessDescription: String?
    var country: String?
    var email: String?
    var businessHeader: String?
    var promoLink: String?
    var attendee: [Attendee]?
}

class GuestModel: NSObject{
    var businesses = [[Business]]()
    weak var delegate: GuestModelDelegate?
    
    override init() {
        super.init()
        
       
    }
    
    func loadFromCache(){
        DispatchQueue.main.async {
            if let ed = self.readEventDaysFromFile(filename: "businesses.json"){
                self.delegate?.didLoadDataFromCache(data: ed)
                print("loaded")
            } else{
                self.delegate?.failedLoadDataFromCache()
                print("Failed to load 'Businesses.json'")
            }
        }
    }
    
    @objc func fetchEmployee(){
        // load Employer data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let employer_Request = Employer_Request()
            employer_Request.getVenders{ [weak self] result in
                switch result {
                case .failure(let error):
                    self!.delegate?.failedRecieveDataUpdate()
                    print(error)
                case .success(let employers):
                    self!.makeModel(employers: employers)
                }
            }
        }
    }
    func makeModel(employers: ([EmItem])){
        var tempBusinessesContainer = [Business]()
        //Filter empty business name
        let filteredBusinesses = employers.filter{ $0.Item.Business_Name?.S != nil}
        //Group them to [Business][individual] array
        let tempBusinesses = Array(Dictionary(grouping:filteredBusinesses){$0.Item.Business_Name?.S}.values)
        for b in tempBusinesses{
            var attendees = [Attendee]()
            //Make Attendee object for this business
            b.forEach({attendees.append(Attendee(name: $0.Item.Name_of_Attendee?.S ?? "N/A",bio: $0.Item.Bio?.S ?? "N/A"))})
            //Make Business object
            let business = Business(businessName: b.first?.Item.Business_Name?.S, businessDescription: b.first?.Item.Business_Description?.S, country: b.first?.Item.Country?.S, email: b.first?.Item.Emial?.S, businessHeader: String((b.first?.Item.Business_Name?.S.prefix(1))!) ,promoLink: b.first?.Item.Promo_Link?.S ,attendee: attendees)
            tempBusinessesContainer.append(business)
        }
        //Group them to [BusinessHeader][Business] array
        let tempUnsortedBusinesses = Array(Dictionary(grouping:tempBusinessesContainer){$0.businessHeader}.values)
        var appendingBusiness = [[Business]]()
        for unsorted in tempUnsortedBusinesses{
            //sort by [Business]
            let sorted = unsorted.sorted(by: {$0 < $1})
            appendingBusiness.append(sorted)
        }
        //sort by [BusinessHeader]
        businesses = appendingBusiness
        businesses.sort { ($0[0] ) < ($1[0] ) }
        saveEventDaysToFile(data: businesses, filename: "businesses.json")
        
        DispatchQueue.main.async {
            self.delegate?.didRecieveDataUpdate(data: self.businesses)
        }
        
        
    }
    
    func readEventDaysFromFile(filename: String) -> [[Business]]?{
        let jsonDecoder = JSONDecoder()
        if let url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(filename){
            do {
                if let jsonData = try? Data(contentsOf: url){
                let decodedData = try jsonDecoder.decode([[Business]].self, from: jsonData)
                    print("\(filename) loaded successfully")
                    return decodedData
            }
            } catch let error {
                print("couldn't load: \(filename), error: \(error)")
            }
            
        }
        return nil
    }
    
    func saveEventDaysToFile(data: [[Business]], filename: String){
        let jsonEncoder = JSONEncoder()
        var jsonData: Data?
        do {
            jsonData = try jsonEncoder.encode(data)
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
}

protocol GuestModelDelegate: class {
    func didRecieveDataUpdate(data: [[Business]])
    func didLoadDataFromCache(data: [[Business]])
    func failedLoadDataFromCache()
    func failedRecieveDataUpdate()
}
