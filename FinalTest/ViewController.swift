/*
 App        : Final Test– BMI Calculator App  l
 Version    : 1.1.0.0
 --------------------------
 Author     : Shirin Mansouri
 Student ID : 301131068
 --------------------------
 Description:
 
 ViewController handles the logic for the BMI Calculator Scene
 --------------------------
 */

import UIKit

class cellClass :UITableViewCell
{
    
}
// a struct to save BMI information
struct Bmi: Codable {
    var name: String
    var weight: Float
    var height : Float
    var bmiDate : String
    var gender : String
    var calculatedBmi : Float
    let id : String
    let ImperialBmi : Bool
}

class ViewController: UIViewController {
    let transparentview = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    var ImperialBmi : Bool = false
    var bmi : Float = 0
    var lstBmi : [Bmi] = []
    @IBOutlet weak var btnGender: UIButton!
    
    @IBOutlet weak var txtHeight: UITextField!
    
    @IBOutlet weak var txtWeight: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBAction func btnReset(_ sender: Any) {
        clearForm()
        
    }
    
    // A function to Validate BMI Information
    private func ValidateForm() -> Bool
    {
        if (txtWeight.text!.isEmpty || txtHeight.text!.isEmpty || txtAge.text!.isEmpty ||
            txtName.text!.isEmpty)
        {
            return false
        }
        else if (
            (Float(txtWeight.text!) != nil) &&
            ( Float(txtHeight.text!) != nil) &&
            ( Float(txtAge.text!) != nil)
            )
        {
            return true
        }
        else
        {
            return false
        }
    }
   
    private func clearForm()
    {
        txtWeight.text = ""
        txtHeight.text = ""
        txtAge.text = ""
        txtName.text = ""
        bmi = 0
        lblResult.text=""
    }
    
    // A function to Calculate BMI  based on BMI Type
    @IBAction func btnCalculateBMI(_ sender: Any) {
        if (ValidateForm())
        {
   
        if (ImperialBmi)
        {
            bmi = round(1000 * ( Float(txtWeight.text!)! * 703 )/( Float(txtHeight.text!)! * Float(txtHeight.text!)! ) )/1000
        }
        else
        {
            bmi = round(1000 * ( Float(txtWeight.text!)! )/( Float(txtHeight.text!)! * Float(txtHeight.text!)! ))/1000
        }
        if (bmi<=16)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Severe Thinness)"
        }
        else if (bmi > 16 &&   bmi <= 17)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Moderate Thinness)"
        }
        else if (bmi > 17 && bmi <= 18.5)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Mild Thinness)"
        }
        else if (bmi > 18.5 && bmi <= 25)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Normal)"
        }
        else if (bmi > 25 && bmi <= 30)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Overweight)"
        }
        else if (bmi>30 && bmi <= 35)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   "(Obese Class I)"
        }
        else if (bmi > 35 && bmi <= 40)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Obese Class II)"
        }
        else if ( bmi > 40)
        {
            lblResult.text = "Your BMI : " + String(bmi) +   " (Obese Class III)"
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

    // Afunction to show tracking screen
    @IBAction func btnDoneClicked(_ sender: UIButton) {
     
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        if (ValidateForm())
        {
        
        let defaults = UserDefaults.standard
  
        let _bmi = Bmi( name: txtName.text!, weight: Float(txtWeight.text!)!, height: Float(txtHeight.text!)!, bmiDate: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none), gender: (btnGender.titleLabel?.text)!,calculatedBmi: bmi ,id: UUID().uuidString, ImperialBmi: ImperialBmi )
      
        do {
            let decoder = JSONDecoder()
            let temp = UserDefaults.standard.data(forKey: "Bmi")!
            let  oldBmis = try decoder.decode([Bmi].self, from: temp)
            lstBmi = oldBmis
            lstBmi.append(_bmi)
            let encoder = JSONEncoder()
            let data = try encoder.encode(lstBmi)
            defaults.set(data, forKey: "Bmi")
            lstBmi.removeAll()
            clearForm()
   
        }
        catch {
            print("Unable to Encode bmi (\(error))")
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
    @IBAction func swBMItype(_ sender: UISwitch) {
        if (sender.isOn)
        {
            ImperialBmi = true
            txtHeight.placeholder = "Inch"
            txtWeight.placeholder = "Pounds"
        }
            else
            {
            ImperialBmi = false
                txtHeight.placeholder = "Meter"
                txtWeight.placeholder = "kilogram"
            }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    // to create Gender Drop Down
    func AddTransparentView(frames : CGRect)
    {
        let window = UIApplication.shared.keyWindow
        transparentview.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentview)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentview.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        
        transparentview.addGestureRecognizer(tapgesture)
        transparentview.alpha = 0.5
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options:.curveEaseInOut , animations: { [self] in
            self.transparentview.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x+20, y: frames.origin.y + frames.height*2, width: frames.width, height: CGFloat(dataSource.count*50))
        }, completion: nil )
        
    }
    @objc func removeTransparentView()
    {
        let frames = btnGender.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options:.curveEaseInOut , animations: {
            self.transparentview.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x+20, y: frames.origin.y + frames.height*2, width: frames.width, height: 0)
        }, completion: nil )
    }
    @IBAction func btnGenderClicked(_ sender: Any) {
        dataSource = ["Male " , "Female "]
        AddTransparentView(frames : btnGender.frame)
    }
}

// to create a table view for Gender drop down 
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnGender.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}

