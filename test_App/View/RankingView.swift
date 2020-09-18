//
//  RankingView.swift
//  test_App
//
//  Created by Thomas Lai on 8/29/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//  


import UIKit

struct Country {
    var locationName: String
    var totalConfirmed : Int
    var dailyIncrease : Int
    var Trend : Int
}

class RankingView: UITableViewController {
    
    @IBOutlet weak var sortControlView: UISegmentedControl!
    
    var pickerView = PickerView()
    let calculations = Calculations()
    var userSelection = ""
    var countries : [Country] = []
    var rowSelected = ""
    
    
    func prepareData(){
        let locationList = pickerView.loadData(userSelection: userSelection)
        let defaults = UserDefaults.standard
        var worldCSV = defaults.string(forKey : "worldCSV") ?? "world"
        let USACSV = defaults.string(forKey : "USACSVRanking") ?? "USA"
        
        if(userSelection == "World"){
            let startTime = CFAbsoluteTimeGetCurrent()
            var endofStrings = ""
            if let range = worldCSV.range(of: "\n,"){
                endofStrings = String(worldCSV[...range.lowerBound])
            }
            worldCSV = worldCSV.replacingOccurrences(of: endofStrings, with: "")
            for location in 0...locationList.count-1{
                
                let (confirmedCases, dailyIncreasedCases, tmins14Data)  = calculations.getRankingData(rawCSV: worldCSV , userInput: locationList[location], placeColumn: 1)
                countries.append(Country(locationName: locationList[location], totalConfirmed: confirmedCases, dailyIncrease: dailyIncreasedCases, Trend: tmins14Data))
                
                var endofStrings = ""
                if let range = worldCSV.range(of: "\n,"){
                    endofStrings = String(worldCSV[...range.lowerBound])
                    if (endofStrings.contains("China") || endofStrings.contains("Australia") || endofStrings.contains("France") || endofStrings.contains("Canada") || endofStrings.contains("Denmark") || endofStrings.contains("Netherlands") ||
                            endofStrings.contains("United Kingdom")){
                        let endofStringss = endofStrings.firstIndex(of: "\n") ?? endofStrings.endIndex
                        let deleteString = endofStrings[...endofStringss]
                        worldCSV = worldCSV.replacingOccurrences(of: deleteString, with: "")
                    }
                    else{
                        worldCSV = worldCSV.replacingOccurrences(of: endofStrings, with: "")
                    }
                }
                
            }
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print(timeElapsed)
        }
        else{
            for location in 0...locationList.count-1{
                let (confirmedCases, dailyIncreasedCases, tmins14Data) = calculations.getConfirmedCasesUSA(rawCSV: USACSV)
                countries.append(Country(locationName: locationList[location], totalConfirmed: Int(confirmedCases[location]), dailyIncrease: Int(dailyIncreasedCases[location]), Trend: Int(tmins14Data[location])))
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        prepareData()
    }
    
    
    @IBAction func sortControlAction(_ sender: UISegmentedControl) {
        switch sortControlView.selectedSegmentIndex {
        case 0: do {
            countries.sort {
                if $0.locationName != $1.locationName { // first, compare by last names
                    return $0.locationName < $1.locationName
                }
                /*  last names are the same, break ties by foo
                 else if $0.foo != $1.foo {
                 return $0.foo < $1.foo
                 }
                 ... repeat for all other fields in the sorting
                 */
                else { // All other fields are tied, break ties by last name
                    return $0.locationName > $1.locationName
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        case 1:do{
            countries.sort {
                if $0.totalConfirmed != $1.totalConfirmed {
                    return $0.totalConfirmed > $1.totalConfirmed
                }
                
                else {
                    return $0.totalConfirmed < $1.totalConfirmed
                }
                
            }
            // print(countries)
            
            self.tableView.reloadData()
        }
        case 2: do {
            countries.sort {
                if $0.dailyIncrease != $1.dailyIncrease {
                    return $0.dailyIncrease > $1.dailyIncrease
                }
                
                else {
                    return $0.dailyIncrease < $1.dailyIncrease
                }
                
            }
            // print(countries)
            
            self.tableView.reloadData()
            
        }
        case 3: do {
            countries.sort {
                if $0.Trend != $1.Trend {
                    return $0.Trend > $1.Trend
                }
                
                else {
                    return $0.Trend < $1.Trend
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        default: do{
            countries.sort {
                if $0.locationName != $1.locationName {
                    return $0.locationName > $1.locationName
                }
                
                else {
                    return $0.locationName < $1.locationName
                }
                
            }
            
            self.tableView.reloadData()
            
            
        }
        
        }
        
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
        cell.detailTextLabel?.text = "\(country.totalConfirmed)" + " " + "\(country.dailyIncrease)" + " " + "\(country.Trend)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        rowSelected = countries[indexPath.row].locationName
        self.performSegue(withIdentifier: "goToDataView", sender: self)
    }
    
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pickerView.userSelection = userSelection
        pickerView.userInputfromPicker = rowSelected
        pickerView.preLoadconfirmedCases()
        if segue.identifier == "goToDataView" {
            let destinationVC = segue.destination as! UIDataView
            destinationVC.userInputPicker = rowSelected
            destinationVC.userSelection = userSelection
            
        }
    }
    func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }
    
    
}


