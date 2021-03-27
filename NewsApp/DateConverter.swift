//
//  DateConverter.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/27/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

struct DateConverter {
    public static func stringToISO_8601String(_ date: String?) -> String? {
        
        guard let date = date else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        
        guard let dateFromString = dateFormatter.date(from: date) else { return nil }
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return newDateFormatter.string(from: dateFromString)
    }
    
    public static func getDateFor(hours:Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: -hours, to: Date())
    }
    
    public static func dateToISO_8601String(date: Date) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let formatterDate = dateFormatter.string(from: date)
        return formatterDate
    }
}
