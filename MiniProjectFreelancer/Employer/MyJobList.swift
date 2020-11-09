//
//  MyJobList.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 25/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class MyJobList: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var result:NSArray = []
   
    @IBOutlet weak var table: UITableView!
    
    let defaultValues = UserDefaults.standard
    let URL_LIST_Job = "http://192.168.43.27/member/employerfreelancer/myjobs.php"
    let URL_CHANGEJOBSTATUS = "http://192.168.43.27/member/jobs/changejobstatus.php"
    let URL_TERMINATE = "http://192.168.43.27/member/employerfreelancer/terminatejob.php"
    @objc func viewapplications(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["jobid"]
        let title = job["title"]
        
        self.defaultValues.set(id, forKey: "jobid")
        self.defaultValues.set(title, forKey: "jobtitle")
        
        
        
        /*if self.defaultValues.string(forKey: "role") == "freelancer"  {*/
        let myapplications = self.storyboard?.instantiateViewController(withIdentifier: "myapplications") as! Myapplications
        self.navigationController?.pushViewController(myapplications, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    @objc func terminatejob(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["jobid"]
        let jobtitle = job["title"] as! String
        let status = job["jobstatus"] as! String
        let newstatus=status.replacingOccurrences(of: "Job awaiting termination ", with: "Job terminated", options: .literal, range: nil)
        
        let  freelancertitle = self.defaultValues.string(forKey: "full_name")!
        
        let alertController = UIAlertController(title: "Declare "+jobtitle+" terminated?", message: "This operation cannot be reversed", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            //NSLog("OK Pressed")
            
            
            
            //send notification here
            
            let parameters: Parameters=[
                
                "jobid":id
            ]
            Alamofire.request(self.URL_TERMINATE, method: .post, parameters: parameters).responseJSON{
                
                response in
                
                
                
                print(response.result.value)
                
                sender.isHidden=true
                
                
                
                self.table.reloadData()
                //send notification here
                
            }
            
            
            let parameters1: Parameters=[
                "freelancername":newstatus,
                "jobid":id
            ]
            Alamofire.request(self.URL_CHANGEJOBSTATUS, method: .post, parameters: parameters1).responseJSON{
                
                response in
                
                
                
                print(response.result.value)
                
                sender.isHidden=true
                
                
                
                self.table.reloadData()
                //send notification here
                self.viewDidLoad()
            }
            
            //add notification here
            
            self.dismiss(animated: false, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title="My Jobs"
        self.table.reloadData()
        getlist()
self.table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return result.count
       
        //return (result[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlejob", for: indexPath)
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let contentView = cell.viewWithTag(0)
        let title = contentView?.viewWithTag(66) as! UILabel
        let postermail = contentView?.viewWithTag(1) as! UILabel
        let description = contentView?.viewWithTag(2) as! UILabel
        let budgettype = contentView?.viewWithTag(3) as! UILabel
        let budget = contentView?.viewWithTag(4) as! UILabel
        let skills = contentView?.viewWithTag(5) as! UILabel
        let postdate = contentView?.viewWithTag(6) as! UILabel
        let posterimage = contentView?.viewWithTag(150) as! UIImageView
        let applications = contentView?.viewWithTag(75) as! UIButton
        let terminate = contentView?.viewWithTag(76) as! UIButton
        terminate.isHidden=true
        
        let imgpath = job["userimage"] as! String
        
        title.text = job["title"] as! String
        description.text = job["description"] as! String
        postermail.text = job["postermail"] as! String
        budgettype.text = job["budgettype"] as! String
        budget.text = job["budget"] as! String
        skills.text = job["skills"] as! String
        postdate.text = job["datepost"] as! String
        let status = job["jobstatus"] as! String
        let  id = job["jobid"]
        print(id!)
        let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
        let data = try? Data(contentsOf: url!)
        posterimage.image=UIImage(data: data!)
        posterimage.contentMode = .scaleAspectFill
        if (status != "looking for freelancers"){
            applications.isHidden=true
            
        }
        if (status.contains("termination")){
            terminate.isHidden=false
            
            
        }
        terminate.addTarget(self, action: #selector(terminatejob), for: .touchUpInside)
        applications.addTarget(self, action: #selector(viewapplications), for: .touchUpInside)
        return cell
    }
    
    
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        Alamofire.request(URL_LIST_Job, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            self.table.reloadData()
            
            
          
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem!.title="My Jobs"
        self.viewDidLoad()
        
    }


}
