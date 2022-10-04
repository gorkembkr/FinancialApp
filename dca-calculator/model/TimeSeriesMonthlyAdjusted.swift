//
//  TimeSeriesMonthlyAdjusted.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 23.11.2021.
//

import Foundation

struct MonthInfo {
    let date : Date
    let adjustedOpen : Double
    let adjustedClose : Double
}
struct TimeSeriesMonthlyAdjusted: Decodable {
    let meta: Meta
    let timeSeries: [String:OHLC]
    enum CodingKeys: String , CodingKey{
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    func getMonthInfos() -> [MonthInfo]{
        var monthInfos: [MonthInfo] = []
        let sortedTimeSeries = timeSeries.sorted(by: { $0.key > $1.key })
        sortedTimeSeries.forEach{ (dateString, ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)!
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: Double(ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
    private func getAdjustedOpen(ohlc: OHLC) -> Double{
        return Double(ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
    }
}

struct Meta: Decodable{
    let symbol: String
    enum CodingKeys: String, CodingKey{
        case symbol = "2. Symbol"
    }
}

struct OHLC: Decodable{
    let open: String
    let close: String
    let adjustedClose: String
    enum CodingKeys: String, CodingKey{
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
