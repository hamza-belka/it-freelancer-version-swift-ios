//
//  Register.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Register: UIViewController ,UINavigationBarDelegate{

    @IBOutlet weak var labelname: UILabel!
    //@IBOutlet weak var navbar: UINavigationBar!
    let URL_USER_REGISTER = "http://192.168.43.27/member/register.php"
    
    @IBOutlet weak var rolevalue: UISegmentedControl!
    @IBOutlet weak var confpssd: UITextField!
    @IBOutlet weak var pssd: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var nomuser: UITextField!
     let defaultValues = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //navbar.delegate=self
       
        

        // Do any additional setup after loading the view.
    }
   
    @IBAction func Register(_ sender: UIButton) {
        let role:String?
        if rolevalue.selectedSegmentIndex==0 {
            role="employeur"
        }else{role="freelancer"}
        
        let parameters: Parameters=[
            "full_name":nomuser.text!,
            "usermail":mail.text!,
            "password":pssd.text!,
            "role":role!]
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        let userid = jsonData.value(forKey: "id") as! Int
                   
                       
                       print(userid)
                        
                        //getting user values
                        /*let userId = user.value(forKey: "id") as! Int
                         let userName = user.value(forKey: "username") as! String
                         let userEmail = user.value(forKey: "email") as! String
                         let userPhone = user.value(forKey: "phone ") as! String
                         */
                        //saving user values to defaults
                        self.defaultValues.set(self.mail.text!, forKey: "usermail")
                        self.defaultValues.set(self.nomuser.text!, forKey: "full_name")
                        self.defaultValues.set(self.pssd.text!, forKey: "password")
                        self.defaultValues.set(role, forKey: "role")
                       self.defaultValues.set(userid, forKey: "userid")
                        
                        
                        
                        /*if self.defaultValues.string(forKey: "role") == "freelancer"  {*/
                            let regeducation = self.storyboard?.instantiateViewController(withIdentifier: "xxx") as! Imagepickupload
                            self.navigationController?.pushViewController(regeducation, animated: true)
                            self.dismiss(animated: false, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
