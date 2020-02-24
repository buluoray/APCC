//
//  ConstantHelper.swift
//  APCC
//
//  Created by Yusheng Xu on 2/18/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

//Guests
var guestDetailFontSize: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 18 : 26
    }
}

var fontSize: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 14 : 30
    }
}

var titleSize: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 25 : 32
    }
}

var nameSpacing: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 15 : 30
    }
}
// Events
var cardFontSize: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 20 : 35
    }
}

var cardSpacing: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 30 : 45
    }
}

var locationViewSpacing: CGFloat{
    get{
        return UIDevice.current.userInterfaceIdiom == .phone ? 15 : 30
    }
}
