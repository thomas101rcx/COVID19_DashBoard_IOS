//
//  EntrySelection.swift
//  test_App
//
//  Created by Thomas Lai on 7/5/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//  View controller for front page, selecting between USA/Wrold/Stored Location and Current GPS location

import UIKit
import CoreLocation

class EntrySelection: UIViewController{
    

    @IBOutlet weak var storedLocationDataThree: UILabel!
    @IBOutlet weak var storedLocationDataTwo: UILabel!
    @IBOutlet weak var storedLocationDataOne: UILabel!
    @IBOutlet weak var storedLocationName: UILabel!
    var networkManager = NetworkManager()
    var calculations = Calculations()
    var notificationManager = LocalNotificationManager()
    var locationManager = CLLocationManager()
    var userSelection = ""
    var currentCountryGPS = ""
   
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        setNotification()
        networkManager.setUSACSV()
        networkManager.setWorldCSV()
        networkManager.getUSACSVRanking()
        self.refreshStoredData()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let country = defaults.string(forKey : "userSelection") ?? "USA"
        let state = defaults.string(forKey : "userInputPicker") ?? "Texas"
        var storedLocation = ""
        if country == "World"{
            storedLocation = "Your stored location is : " + state
        }
        else{
            storedLocation = "Your stored location is : " + state + ", " + country
        }
        
        storedLocationName.text =  storedLocation
        
        storedLocationDataOne.text = defaults.string(forKey: "dataLabelOne") ?? "NoData"
        storedLocationDataTwo.text = defaults.string(forKey: "dataLabelTwo") ?? "NoData"
        storedLocationDataThree.text = defaults.string(forKey: "dataLabelThree") ?? "NoData"
        //super.viewWillAppear(true)
        
    }
    
    func getLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    func setNotification() -> Void {
        notificationManager.requestPermission()
     //   notificationManager.addNotification(title: "Open COVID-19 App", dateTime: DateComponents(minute: 01))
        notificationManager.scheduleNotifications()
    }
    
    func refreshStoredData(){
        let country = defaults.string(forKey : "userSelection") ?? "USA"
        let state = defaults.string(forKey : "userInputPicker") ?? "Texas"
        var storedLocation = ""
        var confirmedArray : [Double] = []
        if country == "World"{
            storedLocation = "Your stored location is : " + state
             confirmedArray = calculations.getConfirmedCases(rawCSV: defaults.string(forKey: "worldCSV") ?? "NAH", userInput: state, placeColumn: 1)
        }
        else{
            storedLocation = "Your stored location is : " + state + ", " + country
            
            confirmedArray = calculations.getConfirmedCases(rawCSV: defaults.string(forKey: "USACSV") ?? "NAH", userInput: state, placeColumn: 6)
        }

        storedLocationName.text =  storedLocation
        let confirmedCasesToday = confirmedArray.last ?? 0.0
        let confirmedCasesYesterday = confirmedArray[confirmedArray.count-2]
        let displayText1 = "Total Confirmed Cases : " + String(Int(confirmedCasesToday))
        let displayText2 = "Newly Confirmed Cases Today : " + String(Int(confirmedCasesToday-confirmedCasesYesterday))
        let displayText3 = "14 Day Trend : " + String(Int(confirmedCasesToday - confirmedArray[confirmedArray.count-15]))
        defaults.set(displayText1, forKey: "dataLabelOne")
        defaults.set(displayText2, forKey: "dataLabelTwo")
        defaults.set(displayText3, forKey: "dataLabelThree")
    }
    
    
    @IBAction func goToWorld(_ sender: UIButton) {
        userSelection = "World"
        self.performSegue(withIdentifier : "goToPickerView", sender : self)
    }
    @IBAction func goToUSA(_ sender: UIButton) {
        userSelection = "USA"
        self.performSegue(withIdentifier : "goToPickerView", sender : self)
    }
    
    @IBAction func loadStoredData(_ sender: UIButton) {
        self.performSegue(withIdentifier : "goToViewStored", sender : self)
    }
    @IBAction func getLocationPressed(_ sender: UIButton) {
        
        if currentCountryGPS == ""{
            let alert = UIAlertController(title: "GPS Data not yet loaded", message: "Please wait", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }else{
            defaults.set(currentCountryGPS, forKey: "userInputPicker")
            defaults.set("World", forKey: "userSelection")
            self.performSegue(withIdentifier : "goToViewGPS", sender : self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Store data into UserDefaults
        if segue.identifier == "goToPickerView"{
            let destinationVC = segue.destination as! PickerView
            destinationVC.userSelection = userSelection
        }
        else if segue.identifier == "goToViewGPS"{
            //  let barViewControllers = segue.destination as! UITabBarController
            //  let destinationVC = barViewControllers.viewControllers![0] as! UIDataView
            let destinationVC = segue.destination as! UIDataView
            destinationVC.userInputPicker = currentCountryGPS
            destinationVC.userSelection = "World"
            let calculations  = Calculations()
            let worldConfirmedCases = calculations.getConfirmedCases(rawCSV: defaults.string(forKey: "worldCSV") ?? "world", userInput: currentCountryGPS, placeColumn: 1)
            defaults.set(worldConfirmedCases, forKey: "worldConfirmedCases")
            
        }
        else{
            
            let destinationVC = segue.destination as! UIDataView
            
            destinationVC.userSelection = defaults.string(forKey : "userSelection") ?? "USA"
            destinationVC.userInputPicker = defaults.string(forKey : "userInputPicker") ?? "Texas"
            
        }
    }
    
    
}

extension EntrySelection : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            convertLatLongToAddress(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            /*  // Location name
             if let locationName = placeMark.location {
             // print(locationName)
             }
             // Street address
             if let street = placeMark.thoroughfare {
             // print(street)
             }
             // City
             if let city = placeMark.subAdministrativeArea {
             // print(city)
             }
             // Zip code
             if let zip = placeMark.isoCountryCode {
             // print(zip)
             }*/
            // Country
            if let country = placeMark.country {
                self.currentCountryGPS = country
            }
        })
        
    }
}

