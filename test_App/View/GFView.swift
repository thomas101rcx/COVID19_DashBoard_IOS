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
                if GF_today >= 5{
                    GF_today = 5
                }
            }
            
            
            GF_perday.append(GF_today)
            let value = ChartDataEntry.init(x: Double(i) ,y: GF_today)
            if value.x.isInfinite || value.y.isInfinite || value.y.isNaN{
                value.x = 0
                value.y = 0
            }
            GF_graph.append(value)
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        graphTitle.text = "Growth Factor Graph"
        let GF_line = LineChartDataSet.init(entries: GF_graph, label: "Growth Factor")
        //Here we convert lineChartEntry to a LineChartDataSet
        GF_line.colors = [NSUIColor.white] //Sets the colour to white
        GF_line.circleRadius = 0.1 // Disable the circle on line chart
        GF_line.drawValuesEnabled = false // Disable the value next to each datapoint
        data = LineChartData(dataSets: [GF_line])
            
        trendChart.data = data
        trendChart.leftAxis.axisMaximum = 6
        trendChart.leftAxis.axisMinimum = 0
        // trendChart.showsLargeContentViewer = true
        trendChart.rightAxis.enabled = false
        trendChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
}


