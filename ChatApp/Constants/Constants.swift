//
//  Constants.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

struct Constants {
    static let cellIdentifier = "ReusableCell"
    static let filledButton = "filled"
    static let notFilledButton = "notFilled"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
