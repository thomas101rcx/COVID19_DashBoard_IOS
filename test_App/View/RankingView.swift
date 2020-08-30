//
//  RankingView.swift
//  test_App
//
//  Created by Thomas Lai on 8/29/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import Foundation

import UIKit

struct Country {
    //var isoCode: String
    var locationName: String
    var locationData : [Int]
    //  var confirmedCasesToday: Int
    //  var totalConfirmedCases: Int
    //  var past14dayCases: Int
    
}

class RankingView: UITableViewController {
    
    var pickerView = PickerView()
    var calculations = Calculations()
    var networkManager = NetworkManager()
    
    var userSelection = ""
    
    
    
    var countries :[Country] = []
    
    func prepareData(){
//        let locationList = pickerView.loadData(userSelection: userSelection)
//        var locationData : [Int]
//        let defaults = UserDefaults.standard
//        
//        for location in 0...locationList.count-1{
//            if(userSelection == "World"){
//                locationData = calculations.getRankingData(rawCSV: defaults.string(forKey : "worldCSV") ?? "world", userInput: locationList[location], placeColumn: 1)
//                
//            }
//            else{
//                locationData = calculations.getRankingData(rawCSV: defaults.string(forKey : "USACSV") ?? "USA", userInput: locationList[location], placeColumn: 6)
//            }
//            
//            countries.append(Country(locationName: locationList[location], locationData: locationData))
//        }
        self.printTimeElapsedWhenRunningCode(title: "prepareData" ){
            let locationList = pickerView.loadData(userSelection: userSelection)
                   var locationData : [Int]
                   let defaults = UserDefaults.standard
                   
                   for location in 0...locationList.count-1{
                       if(userSelection == "World"){
                           locationData = calculations.getRankingData(rawCSV: defaults.string(forKey : "worldCSV") ?? "world", userInput: locationList[location], placeColumn: 1)
                           
                       }
                       else{
                           locationData = calculations.getRankingData(rawCSV: defaults.string(forKey : "USACSV") ?? "USA", userInput: locationList[location], placeColumn: 6)
                       }
                       
                       countries.append(Country(locationName: locationList[location], locationData: locationData))
                   }
            
            
            
        }
    }
    
    override func viewDidLoad() {
        prepareData()
    }
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.locationName
        cell.detailTextLabel?.text = "\(country.locationData)"
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    
    func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }
    
    
}


