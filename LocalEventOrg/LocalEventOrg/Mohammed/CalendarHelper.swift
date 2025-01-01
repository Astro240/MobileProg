//
//  CalendarHelper.swift
//  LocalEventOrg
//
//  Created by oskar alk-wer on 25/12/2024.
//

import Foundation

class CalendarHelper
{
    let calendar = Calendar.current
    // Uses the current calendar to perform date calculations
    
    //adds one month to the given date and returns the resulting date.
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    //Subtracts one month from the given date and returns the resulting date.
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    //Converts the given date to a string representing the month name (e.g., "January").
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    /// Converts the given date to a string representing the year (e.g., "2025").
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: date)
    }
    
    //Returns the total number of days in the month of the given date.
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    //Extracts and returns the day of the month from the given date.
    func daysOfMonth(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    //Returns the first day of the month for the given date.
    func firstOfMonth(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    //Returns the weekday of the given date as an integer (0 for Sunday, 1 for Monday, etc.).
    func weekDay(date: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return (components.weekday ?? 1) - 1
    }
}

