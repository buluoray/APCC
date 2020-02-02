//
//  Employer_Request.swift
//  APCC
//
//  Created by Yong Yang on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation

enum Employer_Request_Error:Error {
    case noDataAvailable
    case canNotProcessData
}

struct Employer_Request {
    var request = URLRequest(url: URL(string: "https://3gzg78tkdh.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC")!)
    
    init() {
        //let resourceString = "https://p72owj7c70.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC"
        let resourceString = "https://3gzg78tkdh.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC"
        let API_KEY = "tv50UbePuT4jk53PnXYfu22SUGuSL7Xn77tHVt6x"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        request = URLRequest(url: resourceURL)
        request.setValue(API_KEY, forHTTPHeaderField:"X-API-KEY")
        request.httpMethod = "POST"
    }
    
    func getVenders (completion: @escaping(Result<[Item], Employer_Request_Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
           guard let jsonData = data else {
               completion(.failure(.noDataAvailable))
               return
           }
           do {
               print(data ?? "no data")
               let decoder = JSONDecoder()
               let employer_Response = try decoder.decode([Item].self, from: jsonData)
               completion(.success(employer_Response))
           }catch{
               completion(.failure(.canNotProcessData))
           }
        })
        task.resume()
    }
}
