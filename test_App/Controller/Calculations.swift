//
//  Calculations.swift
//  test_App
//
//  Created by Thomas Lai on 8/25/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//  Does all the math work for me
//

import UIKit

class Calculations {
    var confirmed_cases = Array(repeating: 0.0, count: 1000)
    let defaults = UserDefaults.standard
    var todayConfirmedCasesArray : [Double] = []
    func getConfirmedCases(rawCSV : String, userInput : String, placeColumn : Int) -> [Double]{
        
        //Split the rawCSV file to row by row
        let rawCSV = rawCSV.components(separatedBy: "\n")
        
        // Extract Data and calculate sum of confirmed cases by state/country
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
    
    func getConfirmedCasesUSA(rawCSV : String) -> ([Double], [Double], [Double]){
        
        var USAConfirmedCases : [Double] = []
        var USADailyIncreasedCases :[Double] = []
        var tMinus14DaysData : [Double] = []
        
        let rawCSV = rawCSV.components(separatedBy: "\n")
        
        for i in stride(from: rawCSV.count-1, to: rawCSV.count - 1 - 2*55, by: -1) {
            let Data = Double(rawCSV[i].components(separatedBy: ",")[3]) ?? 0.0
            USAConfirmedCases.append(Data)
        }
        
        for i in stride(from: rawCSV.count-1 - 14*55, to: rawCSV.count - 1 - 15*55, by: -1) {
            let Data = Double(rawCSV[i].components(separatedBy: ",")[3]) ?? 0.0
            USAConfirmedCases.append(Data)
        }
        
        
        for i in stride(from: 0, to: 55, by: 1) {
            USADailyIncreasedCases.append(USAConfirmedCases[i] - USAConfirmedCases[i+55])
            tMinus14DaysData.append(USAConfirmedCases[i] - USAConfirmedCases[i+110])
        }
        
        
        USAConfirmedCases = Array(USAConfirmedCases[0...54])
        USAConfirmedCases.reverse()
        USADailyIncreasedCases.reverse()
        tMinus14DaysData.reverse()
        
        return (USAConfirmedCases,USADailyIncreasedCases,tMinus14DaysData)
    }
    
    func getConfirmedCasesWorld(rawCSV : String,userInput : String) -> [Double] {
        
        var worldConfirmedCases : [Double] = []
        var worldConfirmedCasesSpecial = Array(repeating: 0.0, count: 40)
        
        let rawCSV = rawCSV.components(separatedBy: "\n")
        for row in rawCSV{
            if row != ""{
                let rowArray = row.components(separatedBy: ",")
                if(rowArray[1].contains(userInput)) {
                    
                    if userInput == "China" || userInput == "Canada" || userInput == "Australia" || userInput == "Denmark" || userInput == "France" || userInput == "Netherlands" || userInput == "United Kingdom"{
                        var count = 0
                        for column in stride(from: rowArray.count-1, to: rowArray.count-21, by: -1) {
                            worldConfirmedCasesSpecial[count] = worldConfirmedCasesSpecial[count] +  (Double(rowArray[column]) ?? 0.0)
                            count  = count + 1
                        }
                    }
                    else{
                        for column in stride(from: rowArray.count-1, to: rowArray.count-21, by: -1) {
                            worldConfirmedCases.append(Double(rowArray[column]) ?? 0.0)
                            
                        }
                        break
                        
                    }
                    
                }
                
                
                
            }
        }
        worldConfirmedCasesSpecial = worldConfirmedCasesSpecial.removing(suffix: 0)
        worldConfirmedCasesSpecial.reverse()
        worldConfirmedCases.reverse()
        
        if worldConfirmedCases.count != 0{
            return worldConfirmedCases
        }else{
            return worldConfirmedCasesSpecial
        }
        
    }
    
    
    func getRankingData(rawCSV : String, userInput : String, placeColumn : Int) -> (Int, Int, Int) {
        
        todayConfirmedCasesArray = self.getConfirmedCasesWorld(rawCSV: rawCSV, userInput: userInput)
        
        let todayConfirmedCases = todayConfirmedCasesArray.last ?? 0
        
        let dailyIncreasedCasesToday = todayConfirmedCasesArray[todayConfirmedCasesArray.count-1] - todayConfirmedCasesArray[todayConfirmedCasesArray.count-2]
        
        let  tMinus14DaysData = Int(todayConfirmedCasesArray[todayConfirmedCasesArray.count-1] - todayConfirmedCasesArray[todayConfirmedCasesArray.count-15])
        
        todayConfirmedCasesArray = Array(repeating: 0.0, count: 30)
        
        return (Int(todayConfirmedCases),Int(dailyIncreasedCasesToday),tMinus14DaysData)
    }
    
    
    
    
}
