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
        let chatDate = self.date.DateConvert("dd-MM-yyyy")
        let todayDate = "".DateConvertToday(newFormat: "dd-MM-yyyy")
        let yesterdayDate = Date().past(day: 1).DateConvert("dd-MM-yyyy")
        if(chatDate == todayDate){
            print("chatDate: \(chatDate) || todayDate : \(todayDate)")
            return "Today\n\(self.date.DateConvert("HH:mm aa"))"
        }else if(chatDate == yesterdayDate){
            print("chatDate: \(chatDate) || yesterdayDate : \(yesterdayDate)")
            return "Yesterday\n\(self.date.DateConvert("HH:mm aa"))"
        }else{
            return self.date.DateConvert("dd/MM/yyyy\nHH:mm aa")
        }
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

extension String{
    
    func DateConvertToday(newFormat:String)->String{
        return Date().DateConvert(newFormat)
    }
    func DateConvert(oldFormat:String,newFormat:String)->String{
        let datePostedRaw = self.replace(this: "T", with: " ")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = oldFormat
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = newFormat
        var validatedDate = ""
        if let date = dateFormatterGet.date(from: datePostedRaw){
//            print(dateFormatterPrint.string(from: date))
            validatedDate = dateFormatterPrint.string(from: date)
        }
        return validatedDate
    }
    func DateConvert(oldFormat:String)->Date{
        if(self != ""){
            let isoDate = self
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = oldFormat
            return dateFormatter.date(from:isoDate)!
        }else{
            return Date()
        }
    }
    var validDate:String{
        let datePostedRaw = self.replace(this: "T", with: " ")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        var validatedDate = ""
        if let date = dateFormatterGet.date(from: datePostedRaw){
//            print(dateFormatterPrint.string(from: date))
            validatedDate = dateFormatterPrint.string(from: date)
        }
        return validatedDate
    }
    var validDateTime:String{
        let datePostedRaw = self.replace(this: "T", with: " ")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM yyyy hh:mm tt"
        var validatedDate = ""
        if let date = dateFormatterGet.date(from: datePostedRaw){
//            print(dateFormatterPrint.string(from: date))
            validatedDate = dateFormatterPrint.string(from: date)
        }
        return validatedDate
    }
    var validDateTime2:String{
        let datePostedRaw = self.replace(this: "T", with: " ")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yy hh.mmaa"
        var validatedDate = ""
        if let date = dateFormatterGet.date(from: datePostedRaw){
//            print(dateFormatterPrint.string(from: date))
            validatedDate = dateFormatterPrint.string(from: date)
        }
        return validatedDate
    }
    
    var validTime:String{
        let datePostedRaw = self.replace(this: "T", with: " ")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh.mmaa"
        var validatedDate = ""
        if let date = dateFormatterGet.date(from: datePostedRaw){
//            print(dateFormatterPrint.string(from: date))
            validatedDate = dateFormatterPrint.string(from: date)
        }
        return validatedDate
    }
}
