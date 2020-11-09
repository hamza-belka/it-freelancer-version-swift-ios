//
//  PostJobs.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 22/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class PostJobs: UIViewController {
    let URL_ADD_Job = "http://192.168.43.27/member/jobs/addjob.php"
    

    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var salary: UITextField!
   
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var typebuget: UISegmentedControl!
    @IBOutlet weak var titre: UITextField!
     let defaultValues = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title="POST job"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func typebuget(_ sender: Any) {
       }
    
    @IBAction func postjob(_ sender: UIButton) {
        let role:String?
        if typebuget.selectedSegmentIndex==0 {
            role="Fixed"
        }else{role="Hourly"}
        
        let title=titre.text!
        let descrep = desc.text!
        let bugettype = role!
        let salair = salary.text!
        let skillss=skills.text!
        let usermail = defaultValues.string(forKey: "usermail")!
        let userid = defaultValues.integer(forKey: "userid")
        
        let parameters: Parameters=[
            "title":title,
            "jobdescription":descrep,
            "budgettype":bugettype,
            "budget":salair,
            "skills":skillss,
            "posterid":userid,
            "postermail":usermail]
        
        Alamofire.request(URL_ADD_Job, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                       print("jobb added ")
                        let alert = UIAlertController(title: "JOB POSTE", message: "YOUR POST HAVE BEEN ADDED", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        
                        self.present(alert,animated: true,completion: nil)
                        
                        
                        self.dismiss(animated: false, completion: nil)
                        
                        self.desc.text=""
                        self.salary.text=""
                        self.skills.text=""
                        self.titre.text=""
                        
                        
                        
                        //getting user values
                        /*let userId = user.value(forKey: "id") as! Int
                         let userName = user.value(forKey: "username") as! String
                         let userEmail = user.value(forKey: "email") as! String
                         let userPhone = user.value(forKey: "phone ") as! String
                         */
                        //saving user values to defaults
                       
                        
                        
                        
                        if self.defaultValues.string(forKey: "role") == "freelancer"  {
                       
                        /* }else{ let dashboardemployer = self.storyboard?.instantiateViewController(withIdentifier: "imageupload") as! Imagepickupload
                         self.navigationController?.pushViewController(dashboardemployer, animated: true)
                         self.dismiss(animated: false, completion: nil)
                         
                         
                         }*/
                        //switching the screen
                        
                    }else{
                        //error message in case of invalid credential
                        //self.labelMessage.text = "Invalid username or password"
                        print("REGISTRATION unseccessful")
                    }
                }
        }
        
        
    }
    
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem!.title="POST job"
        
        
        
    }
}
