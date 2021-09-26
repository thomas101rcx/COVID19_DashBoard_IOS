import UIKit

class PickerView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var rightBarButtonOutlet: UIBarButtonItem!
    
    var userSelection = ""
    var pickerData: [String] = [String]()
    var States : [String] = [String]()
    var Unique_States : [String] = [String]()
    var userInputfromPicker = ""
    var Country : [String] = [String]()
    var Unique_Country : [String] = [String]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        
        self.pickerData = self.loadData(userSelection: userSelection)
        self.statePicker.dataSource = self
        self.statePicker.delegate = self
        rightBarButtonOutlet.title = "next"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            
            
            super.viewDidLoad()
        }
        
    }
    
    @IBAction func rightbarButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier : "goToUIView", sender : self)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userInputfromPicker = pickerData[statePicker.selectedRow(inComponent: 0)]
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.preLoadconfirmedCases()
        
        let defaults = UserDefaults.standard
        defaults.set(userInputfromPicker, forKey: "userInputPicker")
        defaults.set(userSelection, forKey: "userSelection")
        
        if segue.identifier == "goToUIView"{
            
            let destinationVC = segue.destination as! UIDataView
            if(userInputfromPicker == " " || userInputfromPicker == ""){
                destinationVC.userInputPicker = "Texas"
                destinationVC.userSelection = "USA"
                defaults.set("Texas", forKey: "userInputPicker")
                
            }else{
                destinationVC.userInputPicker = userInputfromPicker
                destinationVC.userSelection = userSelection
            }
            
        }
        
    }
    
    func loadData(userSelection : String) -> [String] {
        
        switch userSelection {
        case "World":
            let list = defaults.string(forKey : "worldCSV") ?? "world"
            
            let raw_csv = list.components(separatedBy: "\n")
            // Extract State list
            for row in 0...raw_csv.count-1{
                if (raw_csv[row] != ""){
                    let rowArray = raw_csv[row].components(separatedBy: ",")
                    var Country_String = rowArray[1]
                    Country_String = Country_String.trimmingCharacters(in: .whitespacesAndNewlines)
                    Country_String = Country_String.replacingOccurrences(of: "\"", with: "")
                    Country_String = Country_String.replacingOccurrences(of: "*", with: "")
                    Country.append(Country_String)
                }
                
                
            }
            Country = Country.removing(suffix: "")
            Country = Country.removing(suffix: " ")
            Country.removeAll{$0 == "Country/Region"}
            
            Unique_Country = Array(Set(Country).sorted())
            return Unique_Country
            
        case "USA":
            let list = defaults.string(forKey : "USACSV") ?? "USA"
            
            let raw_csv = list.components(separatedBy: "\n")
            // Extract State list
            for row in 0...raw_csv.count-2{
                let rowArray = raw_csv[row].components(separatedBy: ",")
                States.append(rowArray[6])
            }
            States = States.removing(suffix: "")
            States = States.removing(suffix: " ")
            
            Unique_States = Array(Set(States.removing(suffix: "Province_State")).sorted())
            Unique_States = Unique_States.filter { $0 != "American Samoa" }
            Unique_States = Unique_States.filter { $0 != "Province_State" }
            Unique_States = Unique_States.filter { $0 != "Grand Princess" }
            Unique_States = Unique_States.filter { $0 != "Diamond Princess" }
            
            return Unique_States
            
        default:
            return ["No selection"]
        }
    }
    
    func preLoadconfirmedCases(){
        let calculations = Calculations()
        
        if userSelection == "World"{
            let worldConfirmedCases =  calculations.getConfirmedCases(rawCSV: defaults.string(forKey: "worldCSV") ?? "world", userInput: userInputfromPicker, locationSelection: "World", placeColumn: 1)
            defaults.set(worldConfirmedCases, forKey: "worldConfirmedCases")
        }
        else{
            let USAConfirmedCases =  calculations.getConfirmedCases(rawCSV: defaults.string(forKey: "USACSV") ?? "USA", userInput: userInputfromPicker, locationSelection: "USA", placeColumn: 6)
            defaults.set(USAConfirmedCases, forKey: "USAConfirmedCases")
        }
        
    }
}


