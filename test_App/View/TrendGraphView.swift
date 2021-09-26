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
    var weeklyNewCasesList : [Double] = []
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
        var delta = 0.0
        for i in 0...confirmed_cases.count-29{
            if i < 28 {
                weeklyNewCasesList.append(0.0)
            }
            else{
                delta = confirmed_cases[i+28] - confirmed_cases[i]
                weeklyNewCasesList.append(delta)
            }
            let value = ChartDataEntry.init(x: confirmed_cases[i] ,y: delta)
            if value.y.isInfinite{
                value.x = 0
                value.y = 0
            }
            covid_trend_graph.append(value)
            
            
        }

        
        tMinus14DaysData = Int(weeklyNewCasesList.last ?? 0.0)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        graphTitle.text = "Trend Graph"
        let Trend_line = LineChartDataSet.init(entries: covid_trend_graph, label: "Newly confrimed cases in the past 28 days")
        //Here we convert lineChartEntry to a LineChartDataSet
        Trend_line.colors = [NSUIColor.white] //Sets the line colour to gray
        Trend_line.circleRadius = 0.1 // Disable the circle on line chart
        Trend_line.drawValuesEnabled = false // Disable the value next to each datapoint
        

        data.addDataSet(Trend_line)
        

        trendChart.data = data
        //chtChart.leftAxis.axisMinimum = 0
        //chtChart.leftAxis.axisMaximum = 200000
        // trendChart.showsLargeContentViewer = true
        trendChart.rightAxis.enabled = false
        trendChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
}


