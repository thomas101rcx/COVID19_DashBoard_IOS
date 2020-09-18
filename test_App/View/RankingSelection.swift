//
//  RankingSelection.swift
//  test_App
//
//  Created by Thomas Lai on 8/29/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//  View controller for selecting world or USA covid-19 data ranking

import UIKit

class RankingSelection: UIViewController{
    
    @IBOutlet weak var USARanking: UIButton!
    @IBOutlet weak var worldRanking: UIButton!
    var userSelection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToUSARanking(_ sender: UIButton) {
        userSelection = "USA"
        self.performSegue(withIdentifier : "goToRank", sender : self)
        
    }
    
    @IBAction func goToWorldRanking(_ sender: Any) {
        userSelection = "World"
        self.performSegue(withIdentifier : "goToRank", sender : self)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRank"{
            
            // let barViewControllers = segue.destination as! UITabBarController
            // let destinationVC = barViewControllers.viewControllers![0] as! UIDataView
            let destinationVC = segue.destination as! RankingView
            destinationVC.userSelection = userSelection
            
        }
        
    }
}
