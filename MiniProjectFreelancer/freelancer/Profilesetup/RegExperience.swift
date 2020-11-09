//
//  RegExperience.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 05/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class RegExperience: UIViewController {
    var f:Int?
      let URL_ADD_Education = "http://192.168.43.27/member/profiles/addeducation.php"
      let URL_ADD_Exp = "http://192.168.43.27/member/profiles/addexperience.php"
    let URL_ADD_skill = "http://192.168.43.27/member/profiles/addskill.php"
    var exparray = [UITextField]()
    var companyarray = [UITextField]()
    var startexpdatearray = [UITextField]()
    var endsexpdatearray = [UITextField]()
    let defaultValues = UserDefaults.standard
    var numberexp:Int?
    private var datePicker1:UIDatePicker?
    private var datePicker2:UIDatePicker?
    private var otherdatePicker1:UIDatePicker?
    private var otherdatePicker2:UIDatePicker?
    

    @IBOutlet weak var skilss: UITextField!
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var company1: UITextField!
    @IBOutlet weak var enddate1: UITextField!
    @IBOutlet weak var stardate1: UITextField!
    
    @IBOutlet weak var cardhidenn: nscarddesign!
    @IBOutlet weak var title2: UITextField!
    @IBOutlet weak var company2: UITextField!
    @IBOutlet weak var stardate2: UITextField!
    @IBOutlet weak var enddate2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        numberexp=1
        cardhidenn.isHidden=true
        exparray.append(title1)
        
        companyarray.append(company1)
        
        startexpdatearray.append(stardate1)
        
        endsexpdatearray.append(enddate1)

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
        
        stardate1.inputView=datePicker1
        enddate1.inputView=datePicker2
        stardate2.inputView=otherdatePicker1
        enddate2.inputView=otherdatePicker2
       //
    }
   
    @IBAction func addceluule(_ sender: Any) {
         cardhidenn.isHidden=false
        numberexp=2
        
        exparray.append(title2)
        
        companyarray.append(company2)
        
        startexpdatearray.append(stardate2)
        
        endsexpdatearray.append(enddate2)
        
    }
    @IBAction func submit(_ sender: Any) {
        var i=0
        
        while(numberexp!>i) {
            
            
            self.defaultValues.set(exparray[i].text, forKey: "titleexp "+String(i))
            self.defaultValues.set(companyarray[i].text, forKey: "company "+String(i))
            self.defaultValues.set(startexpdatearray[i].text, forKey: "startexpdate "+String(i))
            self.defaultValues.set(endsexpdatearray[i].text, forKey: "endexpate "+String(i))
            //print(self.defaultValues.string(forKey: "school "+String(i))!)
            addexp(titleexp: exparray[i].text!, company: companyarray[i].text!, startexpdate: startexpdatearray[i].text!, endexpate: endsexpdatearray[i].text!)
            print("adding exp"+String(i))
            i+=1
   
        }
        f=self.defaultValues.integer(forKey: "number of studies")
        var j=0
        while(f!>j) {
            
            let school = self.defaultValues.string(forKey: "school "+String(j))!
            let degree = self.defaultValues.string(forKey: "degree "+String(j))!
            let startstudydate = self.defaultValues.string(forKey: "startstudydate "+String(j))!
            let endstudydate = self.defaultValues.string(forKey: "endstudydate "+String(j))!

            //print(self.defaultValues.string(forKey: "school "+String(i))!)
            addedu(school: school, degree: degree, startexpdate: startstudydate, endexpate: endstudydate)
            print("adding edu"+String(j))

            j+=1
       
        }
        let skill = skilss.text!
        addskill(skill: skill)
        
        let dashboardfreelancer = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! DashbordFreelancer
        self.navigationController?.pushViewController(dashboardfreelancer, animated: true)
        
        
        
        
    }
    public func addexp(titleexp:String, company:String, startexpdate:String, endexpate:String ){
        
        let parameters: Parameters=[
            "exptitle":titleexp,
            "expcompany":company,
            "startdate":startexpdate,
            "enddate":endexpate,
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        
        Alamofire.request(URL_ADD_Exp, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        
                        print("added successfully!")
                        //self.defaultValues.set(userid, forKey: "userid")
                        
                        
                        
                        
                        //switching the screen
                        
                    }
                    
                }
                
        }
        
        
        
        
    }
    public func addedu(school:String, degree:String, startexpdate:String, endexpate:String ){
        
        let parameters: Parameters=[
            "school":school,
            "degree":degree,
            "startstudydate":startexpdate,
            "endstudydate":endexpate,
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        
        Alamofire.request(URL_ADD_Education, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        
                        print("added successfully!")
                        //self.defaultValues.set(userid, forKey: "userid")
                        
                        
                        
                        
                        //switching the screen
                        
                    }
                    
                }
                
        }
        
        
        
        
    }
    public func addskill(skill:String){
        
        let parameters: Parameters=[
            "skill_description":skill,
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        
        Alamofire.request(URL_ADD_skill, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        
                        print("added successfully!")
                        //self.defaultValues.set(userid, forKey: "userid")
                        
                        
                        
                        
                        //switching the screen
                        
                    }
                    
                }
                
        }
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func dateChanged1(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        stardate1.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func dateChanged2(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        enddate1.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func otherdateChanged1(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        stardate2.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
    }
    @objc func otherdateChanged2(datePicker:UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="dd/MM/yyyy"
        enddate2.text=dateformatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
        
        
        
    }


}
