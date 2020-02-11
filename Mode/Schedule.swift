//
//  Schedule.swift
//  APCC
//
//  Created by Yong Yang on 2/2/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import Foundation


struct ScItem: Decodable{
    var Item: ScItem_info
}

struct ScItem_info: Decodable{
    var ID:Sc_ID_info?
    var Date:Date_info?
    var Time: Time_info?
    var `Type`: Sc_Type_info?
    var General :General_info?
    var Content: Content_info?
    var Location: Location_info?
    var Dressing: Dressing_info?
    var Description: Description_info?
    var Image:Image_info?
}

struct Sc_ID_info:Decodable{
    var S:String
}
struct Date_info:Decodable{
    var S:String
}
struct Time_info:Decodable{
    var S:String
}
struct Sc_Type_info:Decodable{
    var S:String
}
struct General_info:Decodable{
    var S:String
}
struct Content_info:Decodable{
    var S:String
}
struct Location_info:Decodable{
    var S:String
}
struct Dressing_info:Decodable{
    var S:String
}
struct Description_info:Decodable{
    var S:String
}
struct Image_info:Decodable{
    var S:String
}





