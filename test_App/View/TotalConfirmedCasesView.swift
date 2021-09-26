//
//  SecondGrpahView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit
import Charts

struct TotalConfirmedCases {
    var entryValue : Double
}


class TotalConfirmedCasesView: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var graphTitle: UILabel!
    @IBOutlet weak var confirmedCasesView: LineChartView!
    var confirmed_cases : [Double] = []
    var confirmedCasesEntry = [ChartDataEntry]()
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
        graphTitle.text = "Total Confirmed Cases"
        let Confirmed_cases_line = LineChartDataSet(entries: confirmedCasesEntry, label: "Number of total cases")
        //Here we convert lineChartEntry to a LineChartDataSet
        Confirmed_cases_line.colors = [NSUIColor.white] //Sets the colour to white
        Confirmed_cases_line.circleRadius = 0.1 // Disable the circle on line chart
        Confirmed_cases_line.drawValuesEnabled = false // Disable the value next to each datapoint
        
        let data = LineChartData(dataSets: [Confirmed_cases_line]) //This is the object that will be added to the chart
        
        
        
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
