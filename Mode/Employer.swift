//
//  Employer.swift
//  APCC
//
//  Created by Yong Yang on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation

struct EmItem: Decodable, Hashable{
    var Item: Item_info
}

struct Item_info: Decodable, Hashable{
    var ID:ID_info?
    var Business_Name:Business_Name_info?
    var Business_Description:Business_Description_info?
    var Country: Country_info?
    var `Type`: Type_info?
    var Name_of_Attendee :Name_of_Attendee_info?
    var Emial: Emial_info?
    var Website: Website_Info?
    var Bio: Bio_Info?
    var Title: Title_Info?
    var Profile_Image: Profile_Image_Info?
}

struct Profile_Image_Info:Decodable, Hashable {
    var S:String
}

struct Title_Info:Decodable, Hashable {
    var S:String
}

struct Website_Info:Decodable, Hashable {
    var S:String
}

struct Bio_Info:Decodable, Hashable {
    var S:String
}

struct ID_info:Decodable, Hashable{
    var S:String
}
struct Business_Name_info:Decodable, Hashable{
    var S:String
}
struct Business_Description_info:Decodable, Hashable{
    var S:String
}
struct Country_info:Decodable, Hashable{
    var S:String
}
struct Type_info:Decodable, Hashable{
    var S:String
}
struct Name_of_Attendee_info:Decodable, Hashable{
    var S:String
}
struct Emial_info:Decodable, Hashable{
    var S:String
}


