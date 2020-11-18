//
//  ThirdGraphView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit
import Charts

class TrendGraphView: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var graphTitle: UILabel!
    @IBOutlet weak var trendChart: LineChartView!
    var confirmed_cases : [Double] = []
    var weekly_new_cases  = Array(repeating: 0.0, count: 1000)
    var covid_trend_graph = [ChartDataEntry]()
    var userInput = ""
    var userSelection = ""
    var list = ""
    var data = LineChartData()
    var tMinus14DaysData = 0
    
    
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
        
        //Append data to ChartDataEntry
        
        for i in 0...confirmed_cases.count-15{
            if i < 14 {
                weekly_new_cases[i] = 0
            }
            else{
                weekly_new_cases[i] = confirmed_cases[i+14] - confirmed_cases[i]
            }
            let value = ChartDataEntry.init(x: confirmed_cases[i] ,y: weekly_new_cases[i])
            if value.x.isInfinite || value.y.isInfinite{
                value.x = 0
                value.y = 0
            }
            covid_trend_graph.append(value)
            
            
        }
        weekly_new_cases = weekly_new_cases.removing(suffix : 0)
        
        tMinus14DaysData = Int(weekly_new_cases.last ?? 0.0)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        graphTitle.text = "Trend Graph" 
        let line1 = LineChartDataSet.init(entries: covid_trend_graph, label: "Newly confrimed cases in the past 14 days")
        //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
       // var labels = "total Confirmed Cases"
        data = LineChartData(dataSets: [line1])
        trendChart.data = data
        //chtChart.leftAxis.axisMinimum = 0
        //chtChart.leftAxis.axisMaximum = 200000
       // trendChart.showsLargeContentViewer = true
        trendChart.rightAxis.enabled = false
        trendChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
}


