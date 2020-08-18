//
//  EntrySelection.swift
//  test_App
//
//  Created by Thomas Lai on 7/5/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//

import UIKit
import CoreLocation

class EntrySelection: UIViewController{
    
    var userSelection = ""
    var currentCountryGPS = ""
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var trendgraph = TrendGraphView()
    @IBOutlet weak var storedLocationDataThree: UILabel!
    @IBOutlet weak var storedLocationDataTwo: UILabel!
    @IBOutlet weak var storedLocationDataOne: UILabel!
    @IBOutlet weak var storedLocationName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
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
        super.viewWillAppear(true)

    }
    
    func getLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    
    @IBAction func goToWorld(_ sender: UIButton) {
        userSelection = "World"
        self.performSegue(withIdentifier : "goToUSA", sender : self)
    }
    @IBAction func goToUSA(_ sender: UIButton) {
        userSelection = "USA"
        self.performSegue(withIdentifier : "goToUSA", sender : self)
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
            let defaults = UserDefaults.standard
            defaults.set(currentCountryGPS, forKey: "userInputPicker")
            defaults.set("World", forKey: "userSelection")
            self.performSegue(withIdentifier : "goToViewGPS", sender : self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Store data into UserDefaults
        
        // print(userSelection + "Hello")
        if segue.identifier == "goToUSA"{
            let destinationVC = segue.destination as! PickerView
            destinationVC.userSelection = userSelection
        }
        else if segue.identifier == "goToViewGPS"{
            let destinationVC = segue.destination as! UIDataView
            destinationVC.userInputPicker = currentCountryGPS
            destinationVC.userSelection = "World"
        }
        else{
            let destinationVC = segue.destination as! UIDataView
            let defaults = UserDefaults.standard
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

