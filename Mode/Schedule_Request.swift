//
//  Schedule_Request.swift
//  APCC
//
//  Created by Yong Yang on 2/2/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation

enum Schedule_Request_Error:Error {
    case noDataAvailable
    case canNotProcessData
}

struct Schedule_Request {
    var request = URLRequest(url: URL(string: "https://m71ms5hcik.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC_Schedule")!)
    
    init() {
        //let resourceString = "https://p72owj7c70.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC"
        let resourceString = "https://m71ms5hcik.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC_Schedule"
        let API_KEY = "FBruRndpwi4KrFCunWvYC6mxemKGQOIR3aaD1yhD"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        request = URLRequest(url: resourceURL)
        request.setValue(API_KEY, forHTTPHeaderField:"X-API-KEY")
        request.httpMethod = "POST"
    }
    
    func getVenders (completion: @escaping(Result<[ScItem], Schedule_Request_Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
           guard let jsonData = data else {
               completion(.failure(.noDataAvailable))
               return
           }
           do {
             print("=========schedule data response===================")
                print(data ?? "no data")
                let decoder = JSONDecoder()
                let schedule_Response = try decoder.decode([ScItem].self, from: jsonData)
                completion(.success(schedule_Response))
           }catch{
               completion(.failure(.canNotProcessData))
           }
        })
        task.resume()
    }
    
    
}
