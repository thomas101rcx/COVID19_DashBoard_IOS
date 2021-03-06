//
//  SecondViewController.swift
//  test_App
//
//  Created by Thomas Lai on 7/1/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//
import UIKit
import Charts

class UIDataView: UIViewController {
    @IBOutlet weak var fourthGraphView: UIView!
    @IBOutlet weak var thirdGraphView: UIView!
    @IBOutlet weak var secondGraphView: UIView!
    @IBOutlet weak var firstGraphView: UIView!
    @IBOutlet weak var segmentControlGraph: UISegmentedControl!
    @IBOutlet weak var rightBarButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dataLabelOne: UILabel!
    @IBOutlet weak var dataLabelTwo: UILabel!
    @IBOutlet weak var dataLabelThree: UILabel!
    var userInputPicker = ""
    var userSelection = ""
    static let toFirstView = "goToFirst"
    static let toSecondView = "goToSecond"
    static let toThirdView = "goToThird"
    static let toFourthView = "goToFourth"
    let defaults = UserDefaults.standard

    
    
    override func viewDidLoad() {
        
        
        //Default to first page
        rightBarButtonOutlet.title = "Main"
        stateLabel.text = userInputPicker
        segmentControlGraph.frame.size.height = 25
        segmentControlGraph.frame.size.width = 175
        self.navigationItem.titleView = segmentControlGraph
        defaults.setValue(userSelection, forKey: "userSelection")
        defaults.setValue(userInputPicker, forKey: "userInputPicker")
        
        //self.tabBarController?.navigationItem.titleView = segmentControlGraph
        
        self.firstGraphView.alpha = 0
        self.secondGraphView.alpha = 0
        self.thirdGraphView.alpha = 1
        self.fourthGraphView.alpha = 0

        self.dataLabelOne.alpha = 1
        self.dataLabelTwo.alpha = 1
        self.dataLabelThree.alpha = 1

        
        super.viewDidLoad()
        
    }
    
    
    @IBAction func showGraphs(_ sender: UISegmentedControl) {
        
        self.dataLabelOne.alpha = 1
        self.dataLabelTwo.alpha = 1
        self.dataLabelThree.alpha = 1
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.firstGraphView.alpha = 0
                self.secondGraphView.alpha = 0
                self.thirdGraphView.alpha = 1
                self.fourthGraphView.alpha = 0

                
            })
        } else if(sender.selectedSegmentIndex == 1){
            UIView.animate(withDuration: 0.5, animations: {
                self.firstGraphView.alpha = 0
                self.secondGraphView.alpha = 1
                self.thirdGraphView.alpha = 0
                self.fourthGraphView.alpha = 0

            })
        }else if(sender.selectedSegmentIndex == 2){
            UIView.animate(withDuration: 0.5, animations: {
                self.firstGraphView.alpha = 1
                self.secondGraphView.alpha = 0
                self.thirdGraphView.alpha = 0
                self.fourthGraphView.alpha = 0
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.firstGraphView.alpha = 0
                self.secondGraphView.alpha = 0
                self.thirdGraphView.alpha = 0
                self.fourthGraphView.alpha = 1
            })
            
        }
    }
    
    @IBAction func rightBarButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToThird"{
            let destinationVC = segue.destination as! TrendGraphView
            destinationVC.userInput = userInputPicker
            destinationVC.userSelection = userSelection
            destinationVC.generateGraph()
            
            let displayText = "Newly Confirmed Cases in the past 14 days : " + String(destinationVC.tMinus14DaysData)
            defaults.set(displayText, forKey: "dataLabelThree")
            
            dataLabelThree.text = displayText
        }
        else if segue.identifier == "goToSecond"{
            let destinationVC = segue.destination as! TotalConfirmedCasesView
            destinationVC.userInput = userInputPicker
            destinationVC.userSelection = userSelection
            destinationVC.generateGraph()
            let displayText = "Total Confirmed Cases : " + String(Int(destinationVC.totalConfirmedCasesToday))
            
            defaults.set(displayText, forKey: "dataLabelOne")
            dataLabelOne.text = displayText
            
        }else if segue.identifier == "goToFirst"{
            let destinationVC = segue.destination as! DailyIncreaseView
            destinationVC.userInput = userInputPicker
            destinationVC.userSelection = userSelection
            destinationVC.generateGraph()
            let displayText = "Newly Confirmed Cases Today : " + String(Int(destinationVC.dailyIncreasedCasesToday))
            defaults.set(displayText, forKey: "dataLabelTwo")
            
            dataLabelTwo.text = displayText
        }else{
            let destinationVC = segue.destination as! GFView
            destinationVC.userInput = userInputPicker
            destinationVC.userSelection = userSelection
            destinationVC.generateGraph()
           
            
        }
    }
}
extension Array where Element: Equatable {
    
    ///
    /// Removes the trailing elements that match the specified suffix.
    ///
    /// - parameter suffix: The suffix to remove.
    ///
    /// - returns: The initial array without the specified suffix.
    ///
    
    public func removing(suffix: Element) -> [Element] {
        
        var array = self
        var previousValue = suffix
        
        for i in (0..<array.endIndex).reversed() {
            
            let value = array[i]
            
            guard value == previousValue else {
                break
            }
            
            array.remove(at: i)
            previousValue = value
            
        }
        return array
        
    }
    
}
