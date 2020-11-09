//
//  Freelancerdetails.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 10/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Freelancerdetails: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var profileimg: UIImageView!
    
    @IBOutlet weak var freelancerabout: UITextView!
    
    @IBOutlet weak var freelancername: UILabel!
    
    @IBOutlet weak var freelancertitle: UILabel!
    
    @IBOutlet weak var freelancerlocation: UILabel!
    
    
    @IBOutlet weak var edutable: UITableView!
    
    @IBOutlet weak var exptable: UITableView!
    
    @IBOutlet weak var freelancerskills: UITextView!
    
    var educations:NSArray = []
    var experiences:NSArray = []
    var freelancerid=0
    
    
    
    
    
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        freelancerid = self.defaultValues.integer(forKey: "freelancerid")
        profileimg.layer.cornerRadius = profileimg.frame.size.width/2
        profileimg.clipsToBounds = true
        getprofileinfos()
        getexperience()
        geteducations()
        getskills()
        self.edutable.reloadData()
        self.exptable.reloadData()
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.edutable {
            print(self.educations.count)
            return self.educations.count;
        } else {
            print(self.experiences.count)
            return self.experiences.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == edutable {
            var cell:UITableViewCell = self.edutable.dequeueReusableCell(withIdentifier: "celledu") as!     UITableViewCell
            let contentView = cell.viewWithTag(0)
            let school = contentView?.viewWithTag(1) as! UILabel
            let degree = contentView?.viewWithTag(2) as! UILabel
            let datedebfin = contentView?.viewWithTag(3) as! UILabel
            let ed = educations[indexPath.row] as! Dictionary<String,Any>
            school.text!=ed["school"] as! String
            degree.text!=ed["degree"] as! String
            datedebfin.text!=(ed["startstudydate"] as! String)+"-"+(ed["endstudydate"] as! String)
            
            
            
            
            
            return cell
        } else {
            var cell:UITableViewCell = self.exptable.dequeueReusableCell(withIdentifier: "cellexp") as!     UITableViewCell
            let contentView = cell.viewWithTag(0)
            let school = contentView?.viewWithTag(4) as! UILabel
            let degree = contentView?.viewWithTag(5) as! UILabel
            let datedebfin = contentView?.viewWithTag(6) as! UILabel
            let ed = experiences[indexPath.row] as! Dictionary<String,Any>
            school.text!=ed["exptitle"] as! String
            degree.text!=ed["expcompany"] as! String
            datedebfin.text!=(ed["startdate"] as! String)+"-"+(ed["enddate"] as! String)
            return cell
        }
        
    }
    
    
    
    
    public func getprofileinfos(){
        
        let URL_PROFILEINFOS = "http://192.168.43.27/member/profiles/getprofileinfos.php"
        
        let parameters: Parameters=[
            "userid":freelancerid
            
        ]
        
        
        Alamofire.request(URL_PROFILEINFOS, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let profileinfos = jsonData.value(forKey: "profile") as! NSDictionary
                    
                    let profiletitle  = profileinfos.value(forKey: "profiletitle") as! String
                    let about  = profileinfos.value(forKey: "about") as! String
                    let location  = profileinfos.value(forKey: "location") as! String
                    let imgpath  = profileinfos.value(forKey: "imagepath") as! String
                    let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
                    let data = try? Data(contentsOf: url!)
                    self.profileimg.image=UIImage(data: data!)
                    self.profileimg.contentMode = .scaleAspectFill
                    
                    self.freelancertitle.text = profiletitle
                    self.freelancerlocation.text=location
                    self.freelancerabout.text=about
                    self.freelancername.text=self.defaultValues.string(forKey: "freelancername")
                    
                }
        }
    }
    public func geteducations(){
        
        let URL_educations = "http://192.168.43.27/member/profiles/listeducation.php"
        
        let parameters: Parameters=[
            "userid":freelancerid
            
        ]
        
        
        Alamofire.request(URL_educations, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let educationlist = jsonData.value(forKey: "edulist") as! NSArray
                    
                    self.educations=educationlist
                    print(self.educations[0])
                    let ed1 = self.educations[0] as! Dictionary<String,Any>
                    let school = ed1["school"] as! String
                    print(school)
                    self.edutable.reloadData()
                    
                }
        }
    }
    public func getexperience(){
        
        let URL_experiences = "http://192.168.43.27/member/profiles/listexperience.php"
        
        let parameters: Parameters=[
            "userid":freelancerid
            
        ]
        
        
        Alamofire.request(URL_experiences, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let experiencelist = jsonData.value(forKey: "exps") as! NSArray
                    self.experiences = experiencelist
                    print(self.experiences[0])
                    let ex1 = self.experiences[0] as! Dictionary<String,Any>
                    let title = ex1["exptitle"] as! String
                    print(title)
                    self.exptable.reloadData()
                    
                }
        }
    }
    public func getskills(){
        
        let URL_skills = "http://192.168.43.27/member/profiles/getskill.php"
        
        let parameters: Parameters=[
            "userid":freelancerid
            
        ]
        
        
        Alamofire.request(URL_skills, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let profileinfos = jsonData.value(forKey: "skill") as! NSDictionary
                    
                    let skills  = profileinfos.value(forKey: "skill_description") as! String
                    
                    self.freelancerskills.text = skills
                    
                    
                }
        }
    }
}
