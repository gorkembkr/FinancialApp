//
//  Date+Extensions.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 4.03.2022.
//

import Foundation

extension Date{
    
    var MMYYFormat : String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
