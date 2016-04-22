//
//  Wrexagram.swift
//  YoChing
//
//  Created by SirWellington on 4/7/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit


struct Wrexagram {

    let title: String
    let subtitle: String?
    let number: Int?
    let whatsUp: String?

    init(title: String) {
        self.init(title: title, subtitle: nil, whatsUp: nil, number: nil)
    }

    init(title: String, subtitle: String? = nil, whatsUp: String? = nil, number: Int? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.whatsUp = whatsUp
        self.number = number
    }

    static func fromJson(json: JSON) -> Wrexagram {

        let title = json["title"].string ?? ""
        let subtitle = json["subtitle"].string ?? ""
        let whatsUp = json["whats-up"].string ?? ""
        let number = json["number"].int ?? 0

        return Wrexagram(title: title, subtitle: subtitle, whatsUp: whatsUp, number: number)
    }

    var asString: String {
        return "Wrexagram \(number ?? 0) - \(title)"
    }
}
