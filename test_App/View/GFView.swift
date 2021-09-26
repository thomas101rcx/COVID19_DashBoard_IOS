//
//  ThirdGraphView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit
import Charts

class GFView: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var graphTitle: UILabel!
    @IBOutlet weak var trendChart: LineChartView!
    var confirmed_cases : [Double] = []
    var GF_perday  : [Double] = []
    var GF_graph = [ChartDataEntry]()
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
        
        GF_perday.append(0.0)
        GF_perday.append(0.0)
        for i in 2...confirmed_cases.count-1{
            
            let numerator = confirmed_cases[i] - confirmed_cases[i-1]
            let denominator = confirmed_cases[i-1] - confirmed_cases[i-2]
            var GF_today = 0.0
            if numerator == 0 || denominator == 0{
                GF_today = 0.0
            }else{
                GF_today = numerator / denominator
            }
            
            
            GF_perday.append(GF_today)
            let value = ChartDataEntry.init(x: Double(i) ,y: GF_today)
            if value.x.isInfinite || value.y.isInfinite || value.y.isNaN{
                value.x = 0
                value.y = 0
            }
            GF_graph.append(value)
            
            
        }
        print(GF_perday)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        graphTitle.text = "Growth Factor Graph"
        let line1 = LineChartDataSet.init(entries: GF_graph)
        //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        // var labels = "total Confirmed Cases"
        data = LineChartData(dataSets: [line1])
        trendChart.data = data
        trendChart.leftAxis.axisMaximum = 3
        trendChart.leftAxis.axisMinimum = 0
        //chtChart.leftAxis.axisMinimum = 0
        //chtChart.leftAxis.axisMaximum = 200000
        // trendChart.showsLargeContentViewer = true
        trendChart.rightAxis.enabled = false
        trendChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
}


