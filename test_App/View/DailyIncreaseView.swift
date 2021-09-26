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
    var data = LineChartData()
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
        for i in (1..<confirmed_cases.count){
            dailyIncreasedCases.append(confirmed_cases[i] - confirmed_cases[i-1])
            let value = ChartDataEntry(x: Double(i) ,y:confirmed_cases[i] - confirmed_cases[i-1])
            dailyIncreEntry.append(value)
            
        }
        
        dailyIncreasedCasesToday = dailyIncreasedCases.last ?? 0.0
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        graphTitle.text = "Daily New Cases"
        let dailyIncrline = LineChartDataSet(entries: dailyIncreEntry, label: "Number of daily new cases") //Here we convert lineChartEntry to a LineChartDataSet
        dailyIncrline.colors = [NSUIColor.white] //Sets the colour to blue
        dailyIncrline.circleRadius = 0.1 // Disable the circle on line chart
        dailyIncrline.drawValuesEnabled = false // Disable the value next to each datapoint
        
        data = LineChartData(dataSets: [dailyIncrline]) //This is the object that will be added to the chart, //Adds the line to the dataSet
        
        dailyIncrView.data = data
        
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
