//
//  Savedjob.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 18/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Savedjob: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var table: UITableView!
    
   
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
     let URL_SAVED_JOBS = "http://192.168.43.27/member/jobs/getjobsaved.php"
    let URL_APPLY = "http://192.168.43.27/member/jobs/apply.php"
    let URL_DLTEAFTERAPPLY = "http://192.168.43.27/member/jobs/deleteafterapply.php"
    let URL_APPLYNOTIF = "http://192.168.43.27/member/applynotif.php?send_notification"
    
    
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        Alamofire.request(URL_SAVED_JOBS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            
            
            self.table.reloadData()
            
        }
        
    }
    @objc func Apply2job(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["jobid"] as! Int
        let  jobtitle = job["title"] as! String
        let  employertoken = job["token"] as! String
        let  posterid = job["posterid"]
        print(id)
        print(self.defaultValues.integer(forKey: "userid"))
        let parameters: Parameters=[
            "freelancerid":self.defaultValues.integer(forKey: "userid"),
            "jobid":id,
            "employerid":posterid!
        ]
        let parameters1: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid"),
            "jobid":id
            
        ]
        Alamofire.request(URL_APPLY, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let results = response.result.value {
                    let jsonData = results as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        
                        
                        
                        print( jsonData.value(forKey: "message") as! String)
                        self.sendnotification(jobid: id, jobtitle: jobtitle, employertoken: employertoken)
                        
                        
                    }else{
                        //error message in case of invalid credential
                        //self.labelMessage.text = "Invalid username or password"
                        print("apply unseccessful")
                    }
                }
                
                
        }
        Alamofire.request(URL_DLTEAFTERAPPLY, method: .post, parameters: parameters1).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let results = response.result.value {
                    let jsonData = results as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                        
                        
                        
                        print( jsonData.value(forKey: "message") as! String)
                      
                        self.table.reloadData()
                        self.viewDidLoad()
                        self.table.reloadData()
                        
                        
                        
                    }else{
                        //error message in case of invalid credential
                        //self.labelMessage.text = "Invalid username or password"
                        print("apply unseccessful")
                    }
                }
                
                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.reloadData()
        self.getlist()
        self.table.reloadData()
        
        
        

        }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(result.count)
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlejob", for: indexPath)
        
        let contentView = cell.viewWithTag(50)
        let title = contentView?.viewWithTag(0) as! UILabel
        let postermail = contentView?.viewWithTag(1) as! UILabel
        let description = contentView?.viewWithTag(2) as! UILabel
        let budgettype = contentView?.viewWithTag(3) as! UILabel
        let budget = contentView?.viewWithTag(4) as! UILabel
        let skills = contentView?.viewWithTag(5) as! UILabel
        let postdate = contentView?.viewWithTag(6) as! UILabel
        let jobstatus = contentView?.viewWithTag(9) as! UILabel
        let apply = contentView?.viewWithTag(7) as! UIButton
        let posterimage = contentView?.viewWithTag(150) as! UIImageView
     
        
        
        
        
        
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let imgpath = job["imagepath"] as! String
        
        title.text = job["title"] as! String
        description.text = job["description"] as! String
        postermail.text = job["postermail"] as! String
        budgettype.text = job["budgettype"] as! String
        budget.text = job["budget"] as! String
        skills.text = job["skills"] as! String
        postdate.text = job["datepost"] as! String
        jobstatus.text = job["jobstatus"] as! String
       // let  id = job["jobid"]
     //   print(id!)
        
        let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
        let data = try? Data(contentsOf: url!)
        posterimage.image=UIImage(data: data!)
        posterimage.contentMode = .scaleAspectFill
        print(imgpath)
        print(posterimage.image == nil)
        let status = job["jobstatus"] as! String
        if (status != "looking for freelancers"){
            apply.isHidden=true
            
        }
        apply.addTarget(self, action: #selector(Apply2job), for: .touchUpInside)
        
        return cell
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getlist()
        self.table.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.getlist()
        self.table.reloadData()
    }
    func sendnotification(jobid:Int, jobtitle:String, employertoken:String){
        let username = self.defaultValues.string(forKey: "full_name")!
        let txtmessage = username+" just applied for "+jobtitle
        
        let parameters: Parameters=[
            "textmsg":txtmessage,
            "jobid":jobid,
            "jobtitle":jobtitle,
            "token":employertoken
            
        ]
        Alamofire.request(URL_APPLYNOTIF, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            self.table.reloadData()
            
        }
        
    }
}
