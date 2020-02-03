//
//  Employer.swift
//  APCC
//
//  Created by Yong Yang on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation

struct EmItem: Decodable{
    var Item: Item_info
}

struct Item_info: Decodable{
    var ID:ID_info?
    var Business_Name:Business_Name_info?
    var Country: Country_info?
    var `Type`: Type_info?
    var Name_of_Attendee :Name_of_Attendee_info?
    var Emial: Emial_info?
}

struct ID_info:Decodable{
    var S:String
}
struct Business_Name_info:Decodable{
    var S:String
}
struct Country_info:Decodable{
    var S:String
}
struct Type_info:Decodable{
    var S:String
}
struct Name_of_Attendee_info:Decodable{
    var S:String
}
struct Emial_info:Decodable{
    var S:String
}


