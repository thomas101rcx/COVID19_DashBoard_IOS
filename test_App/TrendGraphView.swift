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
    @IBOutlet weak var chtChart: LineChartView!
    var confirmed_cases = Array(repeating: 0.0, count:1000)
    var weekly_new_cases = Array(repeating: 0.0, count:1000)
    var States = Array(repeating: " ", count:1000)
    let new_array2 : [String] = []
    var covid_trend_graph = [ChartDataEntry]()
    var userInput = ""
    var userSelection = ""
    var list = " "
    var data = LineChartData()
    var tMinus14DaysData = 0
    
    func generateGraph() {
        switch userSelection {
        case "World":
            if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") {
                do {
                    list = try String(contentsOf: url)
                } catch {
                    print("Contents can not be loaded")
                    
                }
            } else {
                // the URL was bad!
            }
            if userInput == "United States"{
                userInput = "US"
            }
            
            let new_array = list.components(separatedBy: "\n")
            
            // Extract Data and calculate sum of confirmed cases by state
            
           // print(userInput)
            for item in new_array{
                if item != ""{
                    let new_array2 = item.components(separatedBy: ",")
                    if(new_array2[1].contains(userInput)){
                        for n in 0...new_array2.count-14{
                            confirmed_cases[n] = confirmed_cases[n] + (Double(new_array2[n+13]) ?? 0)
                        }
                    }
                }
            }
            
            
            //remove trailing zeroes
            confirmed_cases = confirmed_cases.removing(suffix: 0)
            
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
            
        case "USA":
            if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") {
                do {
                    list = try String(contentsOf: url)
                } catch {
                    print("Contents can not be loaded")
                    
                }
            } else {
                print("URL is bad")
            }
            
            
            let new_array = list.components(separatedBy: "\n")
            
            // Extract Data and calculate sum of confirmed cases by state
            
            for item in new_array{
                if item != ""{
                    let new_array2 = item.components(separatedBy: ",")
                    if(new_array2[6] == userInput){
                        for n in 0...new_array2.count-14{
                            confirmed_cases[n] = confirmed_cases[n] + (Double(new_array2[n+13]) ?? 0)
                        }
                    }
                }
            }
            
            
            //remove trailing zeroes
            confirmed_cases = confirmed_cases.removing(suffix: 0)
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
            
        default:
            print("Error")
        }
    }
    
    func returnData() -> Int {
        tMinus14DaysData = 0
        // let defaults = UserDefaults.standard

       // self.generateGraph(userSelection: defaults.string(forKey : "userSelection") ?? "USA", userInput: defaults.string(forKey : "userInputPicker") ?? "Texas")
        return tMinus14DaysData
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        graphTitle.text = "COVID-19 Trend Graph" 
        let line1 = LineChartDataSet.init(entries: covid_trend_graph, label: "Past 14 days number of cases (Accumlated)")
        //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        data = LineChartData(dataSets: [line1])
        chtChart.data = data
        //chtChart.leftAxis.axisMinimum = 0
        //chtChart.leftAxis.axisMaximum = 200000
        chtChart.rightAxis.enabled = false
        chtChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
}


