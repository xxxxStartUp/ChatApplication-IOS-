//
//  ChatDate.swift
//  ChatApp
//
//  Created by ebuka Daniel egbunam on 8/13/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class ChatDate {
    
    var date : Date
    
    init(date : Date) {
        self.date = date
    }
    
    func ChatDateFormat() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateString = formatter.string(from: self.date)
        return dateString
    }
    
    
}

extension Date {
    
    func timeAgoToDisplay() -> String {
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = day * 7
        let month = week * 4
        let year = month * 12
        
        
        let timePassed = Int(Date().timeIntervalSince(self))
        
        if timePassed < minute {
            return "\(timePassed) seconds ago"
        }
        else if timePassed < hour {
            return "\(timePassed/minute) minutes ago"
            
        }
        else if timePassed < day {
            return "\(timePassed/hour) hours ago"
        }
        else if timePassed < week {
            return "\(timePassed/day) days ago"
        }
        
        return "\(timePassed/week) weeks ago"
        
    }
}
