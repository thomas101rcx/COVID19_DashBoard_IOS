//
//  NetworkManager.swift
//  test_App
//  Manages the URL request to CSSE Data base and store the data.
//
//  Created by Thomas Lai on 8/18/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    var worldCSV = ""
    var USACSV = ""
    let defaults = UserDefaults.standard
    
    func getWorldCSV(){
        
        if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") {
            do {
                worldCSV = try String(contentsOf: url)
                defaults.set(worldCSV, forKey: "worldCSV")
            } catch {
                print("Contents can not be loaded")
                
            }
        } else {
            // the URL was bad!
            print("The URL is bad !")
        }
        
         
    }
    
    
    func getUSACSV(){
        
        if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") {
            do {
                USACSV = try String(contentsOf: url)                
                defaults.set(USACSV, forKey: "USACSV")

            } catch {
                print("Contents can not be loaded")
                
            }
        } else {
            print("URL is bad")
        }
        
    }
    
}
