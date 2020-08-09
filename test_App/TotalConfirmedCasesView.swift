//
//  SecondGrpahView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit
import Charts

class TotalConfirmedCasesView: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var graphTitle: UILabel!
    
    @IBOutlet weak var confirmedCasesView: LineChartView!
    var confirmed_cases = Array(repeating: 0.0, count:1000)
    var dailyIncreasedCases : [Double] = []
    var States = Array(repeating: " ", count:1000)
    var confirmedCasesEntry = [ChartDataEntry]()
    var dailyIncreEntry = [ChartDataEntry]()
    var userInput = ""
    var userSelection = ""
    var list = ""
    var totalConfirmedCasesToday = 0.0
    var data = LineChartData()
    
    func generateGraph(){
        
        switch userSelection {
        case "World":
            if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") {
                do {
                    list = try String(contentsOf: url)
                } catch {
                    print("Contents can not be loaded")
                    
                }
            } else {
                print("Something is wrong !")
            }
            let raw_csv = list.components(separatedBy: "\n")
            
            if userInput == "United States"{
                userInput = "US"
            }
                      
            
            // Extract Data and calculate sum of confirmed cases by state
            for row in raw_csv{
                if row != ""{
                    let rowArray = row.components(separatedBy: ",")
                    if(rowArray[1].contains(userInput)){
                        for column in 0...rowArray.count-14{
                            confirmed_cases[column] = confirmed_cases[column] + (Double(rowArray[column+13]/*.filter{ !" \n\t\r".contains($0) }*/) ?? 0)
                            
                        }
                        
                    }
                }
            }
            //remove trailing zeroes
            confirmed_cases = confirmed_cases.removing(suffix: 0)
            totalConfirmedCasesToday = confirmed_cases.last ?? 0
            for n in 0...confirmed_cases.count-1{
                let confirmedCasesData = ChartDataEntry(x: Double(n) ,y:confirmed_cases[n])
                confirmedCasesEntry.append(confirmedCasesData)
            }
            
        case "USA":
            if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") {
                do {
                    list = try String(contentsOf: url)
                } catch {
                    print("Contents can not be loaded")
                    
                }
            } else {
                print("Something is wrong !")
            }
            let raw_csv = list.components(separatedBy: "\n")
            
            
            // Extract Data and calculate sum of confirmed cases by state
            for row in raw_csv{
                if row != ""{
                    let rowArray = row.components(separatedBy: ",")
                    if(rowArray[6] == userInput){
                        for column in 0...rowArray.count-14{
                            confirmed_cases[column] = confirmed_cases[column] + (Double(rowArray[column+13]/*.filter{ !" \n\t\r".contains($0) }*/) ?? 0)
                            
                        }
                        
                    }
                }
            }
            //remove trailing zeroes
            confirmed_cases = confirmed_cases.removing(suffix: 0)
            totalConfirmedCasesToday = confirmed_cases.last ?? 0
            for n in 0...confirmed_cases.count-1{
                let confirmedCasesData = ChartDataEntry(x: Double(n) ,y:confirmed_cases[n])
                confirmedCasesEntry.append(confirmedCasesData)
            }
            
        default:
            print("No data")
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        graphTitle.text = "COVID 19 Total Confirmed Cases"
        let line1 = LineChartDataSet(entries: confirmedCasesEntry, label: "Number of Total Cases")
        //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.gray] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        confirmedCasesView.data = data
        //confirmedCasesView.leftAxis.axisMinimum = 0
        //confirmedCasesView.leftAxis.axisMaximum = 200000
        confirmedCasesView.rightAxis.enabled = false
        confirmedCasesView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let endDate = Date() // last date
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/dd/yyyy"
        var timeArray : [String] = []
        for n in 0...confirmed_cases.count{
            let date = Calendar.current.date(byAdding: .day, value: -n, to: endDate)
            timeArray.append(fmt.string(from: date!))
        }
        timeArray = timeArray.reversed()
        confirmedCasesView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeArray)
        confirmedCasesView.xAxis.granularityEnabled = true
        
    }
}
