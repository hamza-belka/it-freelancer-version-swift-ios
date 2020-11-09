//
//  Regeducation.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 30/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//
import Alamofire
import UIKit

class Regeducation: UIViewController {
     let URL_ADD_Education = "http://192.168.43.27/member/profiles/addeducation.php"
 
    var schoolarray = [UITextField]()
    var degreearray = [UITextField]()
    var startstudydatearray = [UITextField]()
    var endstudydatearray = [UITextField]()
    let defaultValues = UserDefaults.standard
    var numberstudies:Int?
    
    @IBOutlet weak var school: UITextField!
    
    @IBOutlet weak var degree: UITextField!
    @IBOutlet weak var startstudydate: UITextField!
    @IBOutlet weak var endstudydate: UITextField!
    private var datePicker1:UIDatePicker?
    private var datePicker2:UIDatePicker?
    private var otherdatePicker1:UIDatePicker?
    private var otherdatePicker2:UIDatePicker?
   
    
    @IBOutlet weak var prototype: nscarddesign!
    @IBOutlet weak var otherdegree: UITextField!
    @IBOutlet weak var otherschool: UITextField!
    @IBOutlet weak var otherstartstudydate: UITextField!
    @IBOutlet weak var otherendstudydate: UITextField!
    @IBOutlet weak var container: nscarddesign!
    
   
    @IBAction func plus(_ sender: UIButton) {
        container.isHidden=false
        
        numberstudies=2
        
        schoolarray.append(otherschool)
        
        degreearray.append(otherdegree)
        
        startstudydatearray.append(otherstartstudydate)
        
        endstudydatearray.append(otherendstudydate)
        
    }
    @IBAction func next(_ sender: UIButton) {
        
        var i=0
        self.defaultValues.set(numberstudies, forKey: "number of studies")

        
        while(numberstudies!>i) {
        
        
        self.defaultValues.set(schoolarray[i].text, forKey: "school "+String(i))
            self.defaultValues.set(degreearray[i].text, forKey: "degree "+String(i))
            self.defaultValues.set(startstudydatearray[i].text, forKey: "startstudydate "+String(i))
            self.defaultValues.set(endstudydatearray[i].text, forKey: "endstudydate "+String(i))
            print(self.defaultValues.string(forKey: "school "+String(i))!)
        i+=1
            
           
           
        }
                            
                            
        
        let regeducation = self.storyboard?.instantiateViewController(withIdentifier: "regex") as! RegExperience
        self.navigationController?.pushViewController(regeducation, animated: true)
        self.dismiss(animated: false, completion: nil)
        
                                
    
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        numberstudies=1
         container.isHidden=true
        schoolarray.append(school)
        
        degreearray.append(degree)
        
        startstudydatearray.append(startstudydate)
        
        endstudydatearray.append(endstudydate)
        
        
        datePicker1 = UIDatePicker()
        datePicker1?.datePickerMode = .date
        datePicker1?.addTarget(self, action:  #selector(dateChanged1(datePicker:)), for: .valueChanged)
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        datePicker2?.addTarget(self, action:  #selector(dateChanged2(datePicker:)), for: .valueChanged)
        otherdatePicker1 = UIDatePicker()
        otherdatePicker1?.datePickerMode = .date
        otherdatePicker1?.addTarget(self, action:  #selector(otherdateChanged1(datePicker:)), for: .valueChanged)
        otherdatePicker2 = UIDatePicker()
        otherdatePicker2?.datePickerMode = .date
        otherdatePicker2?.addTarget(self, action:  #selector(otherdateChanged2(datePicker:)), for: .valueChanged)
       
        startstudydate.inputView=datePicker1
        endstudydate.inputView=datePicker2
        otherstartstudydate.inputView=otherdatePicker1
        otherendstudydate.inputView=otherdatePicker2
       
       

        // Do any additional setup after loading the view.
    }
    @objc func dateChanged1(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        startstudydate.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func dateChanged2(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        endstudydate.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func otherdateChanged1(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        otherstartstudydate.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func otherdateChanged2(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        otherendstudydate.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
