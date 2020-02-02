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
    let resourceURL:URL
    let API_KEY = "BjVugaC0TL3xHAbNAG9ih6kqVX8N9Djq47hqMLSC"
    
    init() {
        //let resourceString = "https://4e97t4crj2.execute-api.us-east-2.amazonaws.com/default/BYUH_APP?api_key=\(API_KEY)"
        let resourceString = "https://p72owj7c70.execute-api.us-east-2.amazonaws.com/default/BYUH_APP_APCC"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
        
    }
    
    func getVenders (completion: @escaping(Result<[Item], Employer_Request_Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let employer_Response = try decoder.decode([Item].self, from: jsonData)
                completion(.success(employer_Response))
            }catch{
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }

}
