//
//  DashboardEmployer.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class DashboardEmployer: UITabBarController{
let defaultValues = UserDefaults.standard
    let URL_SETTOKEN = "http://192.168.43.27/member/settoken.php"
    override func viewDidLoad() {
        super.viewDidLoad()
        let userid = self.defaultValues.integer(forKey: "userid")
        settoken(userid: userid)
        let logout = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        logout.addTarget(self, action: #selector(logoutaction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logout)
       
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
        
    }
    @objc func logoutaction () {
        self.defaultValues.set(nil, forKey: "usermail")
        self.defaultValues.set(nil, forKey: "full_name")
        self.defaultValues.set(nil, forKey: "password")
        self.defaultValues.set(nil, forKey: "role")
        self.defaultValues.set(nil, forKey: "userid")
        self.defaultValues.set(nil, forKey: "token")
        self.dismiss(animated: true) {
            
        }
        // do the magic
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
