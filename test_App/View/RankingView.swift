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
    //  var locationData : [Int]
}

class RankingView: UITableViewController {
    
    var pickerView = PickerView()
    let calculations = Calculations()
    var userSelection = ""
    var countries :[Country] = []
    
    @IBOutlet weak var sortControlView: UISegmentedControl!
    
    func prepareData(){
        let locationList = pickerView.loadData(userSelection: userSelection)
        // var locationData : [Int]
        let defaults = UserDefaults.standard
        let worldCSV = defaults.string(forKey : "worldCSV") ?? "world"
        let USACSV = defaults.string(forKey : "USACSVRanking") ?? "USA"
        
        if(userSelection == "World"){
            for location in 0...locationList.count-1{
                let (confirmedCases, dailyIncreasedCases, tmins14Data)  = calculations.getRankingData(rawCSV: worldCSV , userInput: locationList[location], placeColumn: 1)
                countries.append(Country(locationName: locationList[location], totalConfirmed: confirmedCases, dailyIncrease: dailyIncreasedCases, Trend: tmins14Data))
                
            }
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
        case 0:do{
            countries.sort {
                if $0.totalConfirmed != $1.totalConfirmed { // first, compare by last names
                    return $0.totalConfirmed > $1.totalConfirmed
                }
                    /*  last names are the same, break ties by foo
                     else if $0.foo != $1.foo {
                     return $0.foo < $1.foo
                     }
                     ... repeat for all other fields in the sorting
                     */
                else { // All other fields are tied, break ties by last name
                    return $0.dailyIncrease < $1.dailyIncrease
                }
                
            }
            print(countries)
            
            
            }
        case 1: do {
            
            }
        case 2: do {
            
            }
        default: break;
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

