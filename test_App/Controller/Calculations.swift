//
//  Calculations.swift
//  test_App
//
//  Created by Thomas Lai on 8/25/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit

class Calculations {
    var confirmed_cases = Array(repeating: 0.0, count: 1000)
    let defaults = UserDefaults.standard
    func getConfirmedCases(rawCSV : String, userInput : String, placeColumn : Int) -> [Double]{
        
        //Split the rawCSV file to row by row
        let rawCSV = rawCSV.components(separatedBy: "\n")
        
        // Extract Data and calculate sum of confirmed cases by state
        for row in rawCSV{
            if row != ""{
                let rowArray = row.components(separatedBy: ",")
                if(rowArray[placeColumn].contains(userInput)){
                    for column in 0...rowArray.count-14{
                        confirmed_cases[column] = confirmed_cases[column] + (Double(rowArray[column+13]/*.filter{ !" \n\t\r".contains($0) }*/) ?? 0)
                        
                    }
                    
                }
            }
        }
        
        //remove trailing zeroes
        confirmed_cases = confirmed_cases.removing(suffix: 0)
        
        return confirmed_cases
    }
    
    func getRankingData(rawCSV : String, userInput : String, placeColumn : Int) -> [Int] {
        
        var dailyIncreasedCasesArray : [Double] = []
        var weeklyNewCasesArray  = Array(repeating: 0.0, count: 1000)
        
        let todayConfirmedCasesArray = self.getConfirmedCases(rawCSV: rawCSV, userInput: userInput, placeColumn: placeColumn)
        
        let todayConfirmedCases = todayConfirmedCasesArray.last ?? 0
        
        for i in (1..<todayConfirmedCasesArray.count-1){
            dailyIncreasedCasesArray.append(todayConfirmedCasesArray[i] - todayConfirmedCasesArray[i-1])
            
        }
        
        let dailyIncreasedCasesToday = todayConfirmedCasesArray.last ?? 0.0
        
        for i in 0...todayConfirmedCasesArray.count-15{
            if i < 14 {
                weeklyNewCasesArray[i] = 0
            }
            else{
                weeklyNewCasesArray[i] = todayConfirmedCasesArray[i+14] - todayConfirmedCasesArray[i]
            }
            
           
            
            
        }
        weeklyNewCasesArray = weeklyNewCasesArray.removing(suffix : 0)
        
        let  tMinus14DaysData = Int(weeklyNewCasesArray.last ?? 0.0)
        
        
        return [Int(todayConfirmedCases),Int(dailyIncreasedCasesToday),tMinus14DaysData]
    }
    
    
}
