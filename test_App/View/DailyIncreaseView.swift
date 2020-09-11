//
//  firstGraphView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import Charts
import UIKit

class DailyIncreaseView: UIViewController{
    
    @IBOutlet weak var graphTitle: UILabel!
    @IBOutlet weak var dailyIncrView: LineChartView!
    var confirmed_cases : [Double] = []
    var dailyIncreasedCases : [Double] = []
    var dailyIncreEntry = [ChartDataEntry]()
    var userInput = " "
    var list = " "
    var userSelection = " "
    var dailyIncreasedCasesToday = 0.0
    
    
    func generateGraph() {
        let defaults = UserDefaults.standard
        switch userSelection {
        case "World":
            list = defaults.string(forKey : "worldCSV") ?? "world"
            
            
            if userInput == "United States"{
                userInput = "US"
            }
            
            confirmed_cases = defaults.object(forKey: "worldConfirmedCases") as! [Double]
           
            
            self.appendData()
            
            
        case "USA":
            list = defaults.string(forKey : "USACSV") ?? "world"
            
            
            confirmed_cases = defaults.object(forKey: "USAConfirmedCases") as! [Double]
            
            
            self.appendData()
            
            
        default:
            print("Error")
        }
        
        
        
        
    }
    
    
    func appendData(){
        
        // Daily increased casess
        for i in (1..<confirmed_cases.count-1){
            dailyIncreasedCases.append(confirmed_cases[i] - confirmed_cases[i-1])
            let value = ChartDataEntry(x: Double(i) ,y:confirmed_cases[i] - confirmed_cases[i-1])
            dailyIncreEntry.append(value)
            
        }
        
        dailyIncreasedCasesToday = dailyIncreasedCases.last ?? 0.0
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        graphTitle.text = "COVID-19 Daily New Cases"
        let line2 = LineChartDataSet(entries: dailyIncreEntry, label: "Number of daily new cases") //Here we convert lineChartEntry to a LineChartDataSet
        line2.colors = [NSUIColor.gray] //Sets the colour to blue
        
        let data2 = LineChartData() //This is the object that will be added to the chart
        data2.addDataSet(line2) //Adds the line to the dataSet
        
        
        dailyIncrView.data = data2
        
        dailyIncrView.rightAxis.enabled = false
        dailyIncrView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
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
        dailyIncrView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeArray)
        dailyIncrView.xAxis.granularityEnabled = true
        
        
    }
    
    
}
