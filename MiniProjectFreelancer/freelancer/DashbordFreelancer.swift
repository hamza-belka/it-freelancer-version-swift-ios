//
//  DashbordFreelancer.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class DashbordFreelancer: UITabBarController{

    let defaultValues = UserDefaults.standard
    let URL_SETTOKEN = "http://192.168.43.27/member/settoken.php"
    override func viewDidLoad() {
        super.viewDidLoad()
        let userid = self.defaultValues.integer(forKey: "userid")
        settoken(userid: userid)
        // self.navigationItem.hidesBackButton=true
        
        // Do any additional setup after loading the view.
    }
    
    func settoken(userid:Int){
        let parameters: Parameters=[
            "token":self.defaultValues.string(forKey: "usertoken")!,
            "userid":userid
        ]
        Alamofire.request(URL_SETTOKEN, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            
            
        }
    
   /* @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewcontroller") as! Login
        
        self.navigationController?.pushViewController(login, animated: true)
        
        self.dismiss(animated: false, completion: nil)
        
    }*/
   
    

    }
    
}
