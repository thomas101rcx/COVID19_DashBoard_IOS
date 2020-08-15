import UIKit

class PickerView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userSelection = ""
    var pickerData: [String] = [String]()
    @IBOutlet weak var statePicker: UIPickerView!
    var States = Array(repeating: " ", count:1000)
    var Unique_States = Array(repeating: " ", count:1000)
    var userInputfromPicker = " "
    var Country = Array(repeating: " ", count:1000)
    var Unique_Country = Array(repeating: " ", count:1000)
    
    
    @IBOutlet weak var rightBarButtonOutlet: UIBarButtonItem!
    
    
    override func viewDidLoad() {
       // print(self.userSelection)
        
        self.pickerData = self.loadData()
        self.statePicker.dataSource = self
        self.statePicker.delegate = self
        rightBarButtonOutlet.title = "next"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            super.viewDidLoad()
        }
        
    }

    @IBAction func rightbarButtonAction(_ sender: UIBarButtonItem) {
        //sender.tintColor = UIColor.clear
        self.performSegue(withIdentifier : "goToNextUSA", sender : self)
        
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
        let defaults = UserDefaults.standard
        defaults.set(userInputfromPicker, forKey: "userInputPicker")
        defaults.set(userSelection, forKey: "userSelection")
        if segue.identifier == "goToNextUSA"{
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
    
    func loadData() -> [String] {
        
        switch userSelection {
        case "World":
            var list = " "
            if let url = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"){
                do {
                    list = try String(contentsOf: url)
                    print(type(of: list))
                } catch {
                    print("Contents can not be loaded")
                }
            } else {
                print("Something is wrong !")
            }
            
            let raw_csv = list.components(separatedBy: "\n")
            //print(raw_csv)
            // Extract State list
            for row in 0...raw_csv.count-2{
                let rowArray = raw_csv[row].components(separatedBy: ",")
                var Country_String = rowArray[1]
                Country_String = Country_String.replacingOccurrences(of: "\"", with: "")
                Country_String = Country_String.replacingOccurrences(of: "*", with: "")
                //Get rid of un-Alpha Numeric characters
                //let unsafeChars = CharacterSet.alphanumerics.inverted
                //Country_String = Country_String.components(separatedBy: unsafeChars).joined(separator:"")
                Country.append(Country_String)
            }
            Country = Country.removing(suffix: "")
            Country = Country.removing(suffix: " ")
            Unique_Country = Array(Set(Country.removing(suffix: "State,Country")).sorted())
           // print(Unique_Country)
            return Unique_Country
            
        case "USA":
            var list = " "
            
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
            // Extract State list
            for row in 0...raw_csv.count-2{
                let rowArray = raw_csv[row].components(separatedBy: ",")
                States.append(rowArray[6])
            }
            States = States.removing(suffix: "")
            States = States.removing(suffix: " ")
            Unique_States = Array(Set(States.removing(suffix: "Province_State")).sorted())
            return Unique_States
            
        default:
            return ["No selection"]
        }
      
    }
}


