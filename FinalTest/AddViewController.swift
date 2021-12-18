//
//  AddViewController.swift
//  FinalTest
//
//  Created by Shirin Mansouri on 2021-12-17.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var dbDate: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
       if(ValidateForm())
        {
        do {
            
            let decoder = JSONDecoder()
            let temp = UserDefaults.standard.data(forKey: "Bmi")!
            var  lstBmi : [Bmi] = try decoder.decode([Bmi].self, from: temp)
            var newBmi : Float?
            if (lstBmi[0].ImperialBmi)
            {
                newBmi = round(1000 * ( Float(txtWeight.text!)! * 703 )/(lstBmi[0].height * lstBmi[0].height ) )/1000
            }
            else
            {
                newBmi = round(1000 * ( Float(txtWeight.text!)! )/( lstBmi[0].height * lstBmi[0].height  ))/1000
            }
            
            let _bmi = Bmi( name: lstBmi[0].name, weight: Float(txtWeight.text!)!, height: lstBmi[0].height, bmiDate: DateFormatter.localizedString(from:  dbDate.date, dateStyle: .short, timeStyle: .none), gender:  lstBmi[0].gender,calculatedBmi: newBmi! ,id: UUID().uuidString, ImperialBmi: lstBmi[0].ImperialBmi )
            
            lstBmi.append(_bmi)
            let encoder = JSONEncoder()
            let data = try encoder.encode(lstBmi)
            UserDefaults.standard.set(data, forKey: "Bmi")
            
            let refreshAlert = UIAlertController(title: "", message: "Your New Information has been Added successfully", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
                
            }))

            present(refreshAlert, animated: true, completion: nil)
            
   
        }
        catch {

        }
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
