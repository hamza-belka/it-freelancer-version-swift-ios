//
//  Currentjobs.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 10/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class Currentjobs: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
    
    
    @IBOutlet weak var table: UITableView!
    let URL_CURRENTJOBS = "http://192.168.43.27/member/jobs/getcurrentjobs.php"
    let URL_CHANGEJOBSTATUS = "http://192.168.43.27/member/jobs/changejobstatus.php"
    let URL_COMPLETNOTIF = "http://192.168.43.27/member/completnotif.php?send_notification"
    
    
    
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid"),
        ]
        Alamofire.request(URL_CURRENTJOBS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            
            
            self.table.reloadData()
            
        }
        
    }
    
    
    @objc func completejob(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["jobid"] as! Int
        let  jobtitle = job["title"] as! String
        let  employertoken = job["token"] as! String
        let  posterid = job["posterid"]
        print(id)
        let  freelancertitle = self.defaultValues.string(forKey: "full_name")!
        
        let alertController = UIAlertController(title: "Declare "+jobtitle+" completed?", message: "This operation cannot be reversed", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            //NSLog("OK Pressed")
            
            let parameters: Parameters=[
                "freelancername":"Job awaiting termination (assigned to "+freelancertitle+")",
                "jobid":id
            ]
            Alamofire.request(self.URL_CHANGEJOBSTATUS, method: .post, parameters: parameters).responseJSON{
                
                response in
                
                
                
                print(response.result.value)
                
                sender.isHidden=true
                
                
                 self.sendnotification(jobid: id, jobtitle: jobtitle, employertoken: employertoken)
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
         self.navigationController?.navigationBar.topItem!.title="Current Jobs"
        
        table.reloadData()
        getlist()
        table.reloadData()
        
        
        
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
        let posterimage = contentView?.viewWithTag(150) as! UIImageView
        let jobstatus = contentView?.viewWithTag(200) as! UILabel
        let jobcomplete = contentView?.viewWithTag(8) as! UIButton
        
        
        
        
        
        
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
        let  id = job["jobid"]
        print(id!)
        let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
        let data = try? Data(contentsOf: url!)
        posterimage.image=UIImage(data: data!)
        posterimage.contentMode = .scaleAspectFill
        print(imgpath)
        print(posterimage.image == nil)
        let status = job["jobstatus"] as! String
        if (!status.contains("in progress")){
            jobcomplete.isHidden=true
            
        }
        
       jobcomplete.addTarget(self, action: #selector(completejob), for: .touchUpInside)
        
        
        
        return cell
        
    }
    
    func sendnotification(jobid:Int, jobtitle:String, employertoken:String){
        let username = self.defaultValues.string(forKey: "full_name")!
        let txtmessage = username+" just declared "+jobtitle+" for completion"
        
        let parameters: Parameters=[
            "textmsg":txtmessage,
            "jobid":jobid,
            "jobtitle":jobtitle,
            "token":employertoken
            
        ]
        Alamofire.request(URL_COMPLETNOTIF, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            self.table.reloadData()
            
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
