//
//  Login.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Login: UIViewController {
    let URL_USER_LOGIN = "http://192.168.43.27/member/login.php"
    
    @IBOutlet weak var usermail: UITextField!
    //the defaultvalues to store user data
    @IBOutlet weak var password: UITextField!
    
    
    
    let defaultValues = UserDefaults.standard
    
    //the connected views
    //don't copy instead connect the views using assistant editor
   /* @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!*/
    
    //the button action function
    @IBAction func login(_ sender: UIButton) {
        let parameters: Parameters=[
            "usermail":usermail.text!,
            "password":password.text!
        ]
        
        //making a post request
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        //getting the user from response
                        let username = jsonData.value(forKey: "full_name") as! String
                        let role = jsonData.value(forKey: "role") as! String
                        let userid = jsonData.value(forKey: "id") as! Int
                        let token = jsonData.value(forKey: "token") as! String
                        //getting user values
                        //let userId = user.value(forKey: "id") as! Int
                        /*let usermail = user.value(forKey: "username") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        let userPhone = user.value(forKey: "phone") as! String
                        */
                        //saving user values to defaults
                        self.defaultValues.set(self.usermail.text!, forKey: "usermail")
                        self.defaultValues.set(username, forKey: "full_name")
                        self.defaultValues.set(self.password.text!, forKey: "password")
                        self.defaultValues.set(role, forKey: "role")
                        self.defaultValues.set(userid, forKey: "userid")
                        self.defaultValues.set(token, forKey: "token")

                        
                        
                        
                        
                        //switching the screen
                       
                            
                            if self.defaultValues.string(forKey: "role") == "freelancer"  {
                               // self.performSegue(withIdentifier: "seguefreelancer", sender: self)
                                let dashboardfreelancer = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! DashbordFreelancer
                                self.navigationController?.pushViewController(dashboardfreelancer, animated: true)
                                self.dismiss(animated: false, completion: nil)
                            }else{//self.performSegue(withIdentifier: "segueemployer", sender: self)
                                
                                let dashboardemployer = self.storyboard?.instantiateViewController(withIdentifier: "dashboardemployer") as! DashboardEmployer
                                self.navigationController?.pushViewController(dashboardemployer, animated: true)
                                self.dismiss(animated: false, completion: nil)
                                
                                
                            }
                        
                        
                    }else{
                        //error message in case of invalid credential
                        //self.labelMessage.text = "Invalid username or password"
                         print("login unseccessful")
                    }
                }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
            print(defaultValues.string(forKey: "usermail") )
        //hiding the navigation button
      /*  let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton*/
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "usermail") != nil{
            
            if defaultValues.string(forKey: "role") == "freelancer"  {
            let dashboardfreelancer = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! DashbordFreelancer
            self.navigationController?.pushViewController(dashboardfreelancer, animated: true)
            }else{ let dashboardemployer = self.storyboard?.instantiateViewController(withIdentifier: "dashboardemployer") as! DashboardEmployer
                self.navigationController?.pushViewController(dashboardemployer, animated: true)
                
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /*func Bool Validimput(){
        if(usermail.text!==""){
        
        }
        
    }*/

}
