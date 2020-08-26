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
    
    
}
