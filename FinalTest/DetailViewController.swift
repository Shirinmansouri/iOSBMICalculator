//
//  DetailViewController.swift
//  FinalTest
//
//  Created by Shirin Mansouri on 2021-12-16.
//

import UIKit

class DetailViewController: UIViewController {
 
    @IBOutlet weak var dpBmiDate: UIDatePicker!
    @IBOutlet weak var txtWeight: UITextField!
    var selectedBmiId : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            
            let decoder = JSONDecoder()
            let temp = UserDefaults.standard.data(forKey: "selectedBmi")!
            let  Bmi = try decoder.decode(Bmi.self, from: temp)
            txtWeight.text =  String(Bmi.weight)
            selectedBmiId = Bmi.id
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dataDate : Date? = dateFormatter.date(from: Bmi.bmiDate)
            dpBmiDate.date = dataDate!
   
        }
        catch {

        }
        
    }
    @IBAction func btnSave(_ sender: Any) {
        if (ValidateForm())
        {
        do {
            
            let decoder = JSONDecoder()
            var temp = UserDefaults.standard.data(forKey: "Bmi")!
            var  Bmi = try decoder.decode([Bmi].self, from: temp)
            
            for i in Bmi.indices {
                if Bmi[i].id == selectedBmiId {
                    Bmi[i].weight = Float(txtWeight.text!)!
                    Bmi[i].bmiDate = DateFormatter.localizedString(from: dpBmiDate.date, dateStyle: .short, timeStyle: .none)
                    if (Bmi[i].ImperialBmi)
                    {
                        Bmi[i].calculatedBmi = round(1000 * ( Float(txtWeight.text!)! * 703 )/(Bmi[i].height * Bmi[i].height ) )/1000
                    }
                    else
                    {
                        Bmi[i].calculatedBmi = round(1000 * ( Float(txtWeight.text!)! )/( Bmi[i].height * Bmi[i].height  ))/1000
                    }
                    }
            }
            
           
            do {
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(Bmi)
                UserDefaults.standard.set(data, forKey: "Bmi")

       
            }
            catch {
                print("Unable to Encode bmi (\(error))")
            }
     
   
        }
        catch
        {

        }
        
        let refreshAlert = UIAlertController(title: "", message: "Your change has been saved successfully", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
        else
        {
            let refreshAlert = UIAlertController(title: "", message: "Please Enter Correct Information", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
           
                
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    private func ValidateForm() -> Bool
    {
        if (txtWeight.text!.isEmpty )
        {
            return false
        }
        else if (
            (Float(txtWeight.text!) != nil)
            )
        {
            return true
        }
        else
        {
            return false
        }
    }
   
}
