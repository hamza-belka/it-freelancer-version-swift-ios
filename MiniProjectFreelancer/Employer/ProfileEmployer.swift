//
//  ProfileEmployer.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 25/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class ProfileEmployer: UIViewController {
     let defaultValues = UserDefaults.standard

    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var profiletitle: UILabel!
    @IBOutlet weak var fullname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      pic.layer.cornerRadius = pic.frame.size.width/2
       pic.clipsToBounds = true
        getprofileinfos()
       self.navigationController?.navigationBar.topItem!.title="My profile"

       
    }
    public func getprofileinfos(){
        
        let URL_PROFILEINFOS = "http://192.168.43.27/member/profiles/getprofileinfos.php"
        
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
            
        ]
        
        
        Alamofire.request(URL_PROFILEINFOS, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let profileinfos = jsonData.value(forKey: "profile") as! NSDictionary
                    
                    let profiletitle  = profileinfos.value(forKey: "profiletitle") as! String
                    let aboute  = profileinfos.value(forKey: "about") as! String
                    let location  = profileinfos.value(forKey: "location") as! String
                    let imgpath  = profileinfos.value(forKey: "imagepath") as! String
                  
                    let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
                    let data = try? Data(contentsOf: url!)
                    self.pic.image=UIImage(data: data!)
                    self.pic.contentMode = .scaleAspectFill
                    self.profiletitle.text = profiletitle
                    self.adress.text=location
                    self.about.text=aboute
                    self.fullname.text=self.defaultValues.string(forKey: "full_name")
                    
                }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem!.title="My profile"
        
        
    }

  

}
