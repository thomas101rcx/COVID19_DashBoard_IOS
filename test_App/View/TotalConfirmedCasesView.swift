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
    var confirmed_cases : [Double] = []
    var confirmedCasesEntry = [ChartDataEntry]()
    var dailyIncreEntry = [ChartDataEntry]()
    var userInput = ""
    var userSelection = ""
    var list = ""
    var totalConfirmedCasesToday = 0.0
    var data = LineChartData()

    func generateGraph(){
        let defaults = UserDefaults.standard
        switch userSelection {
            
        case "World":
            
            if userInput == "United States"{
                userInput = "US"
            }
            
            list = defaults.string(forKey : "worldCSV") ?? "world"
            
            confirmed_cases = defaults.object(forKey: "worldConfirmedCases") as! [Double]

            
           // totalConfirmedCasesToday = confirmed_cases.last ?? 0
            
            self.appendData()
            
        case "USA":
            list = defaults.string(forKey : "USACSV") ?? "world"
            confirmed_cases = defaults.object(forKey: "USAConfirmedCases") as! [Double]

            
            self.appendData()
            
        default:
            print("No data")
        }
        
        
        
    }
    
    func appendData(){
        // Append data to Chart
        for n in 0...confirmed_cases.count-1{
            let confirmedCasesData = ChartDataEntry(x: Double(n) ,y:confirmed_cases[n])
            confirmedCasesEntry.append(confirmedCasesData)
        }
        totalConfirmedCasesToday = confirmed_cases.last ?? 0

        
        
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
