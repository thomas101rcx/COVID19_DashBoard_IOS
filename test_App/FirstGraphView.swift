//
//  firstGraphView.swift
//  test_App
//
//  Created by Thomas Lai on 7/4/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import Charts
import UIKit

class FirstGraphViewUSA_State: UIViewController{
    
    @IBOutlet weak var dailyIncrView: LineChartView!
    var confirmed_cases = Array(repeating: 0.0, count:1000)
    var dailyIncreasedCases : [Double] = []
    var States = Array(repeating: " ", count:1000)
    var dailyIncreEntry = [ChartDataEntry]()
    var userInput = " "
    var list = " "
    
    
    func generateGraph() {
        
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
        //print(confirmed_cases)
        //for n in 0...confirmed_cases.count-1{
        //  let confirmedCasesData = ChartDataEntry(x: Double(n) ,y:confirmed_cases[n])
        //confirmedCasesEntry.append(confirmedCasesData)
        //}
        // print(confirmedCasesEntry)
        // Daily increased casess
        for i in (1..<confirmed_cases.count-1){
            dailyIncreasedCases.append(confirmed_cases[i] - confirmed_cases[i-1])
            let value = ChartDataEntry(x: Double(i) ,y:confirmed_cases[i] - confirmed_cases[i-1])
            //print(confirmed_cases[n])
            dailyIncreEntry.append(value)
            //print(value)
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line2 = LineChartDataSet(entries: dailyIncreEntry, label: "Number of daily new cases") //Here we convert lineChartEntry to a LineChartDataSet
        line2.colors = [NSUIColor.gray] //Sets the colour to blue
        
        let data2 = LineChartData() //This is the object that will be added to the chart
        data2.addDataSet(line2) //Adds the line to the dataSet
        
        
        dailyIncrView.data = data2
        //dailyIncrView.leftAxis.axisMinimum = 0
        //dailyIncrView.leftAxis.axisMaximum = 200000
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
        dailyIncrView.chartDescription?.text = "COVID-19 Daily New Cases"
        dailyIncrView.chartDescription?.position = CGPoint(x: 250, y: 0)
        dailyIncrView.chartDescription?.font =  UIFont(name: "Futura", size: 16)!
        
    }
    
    
}
