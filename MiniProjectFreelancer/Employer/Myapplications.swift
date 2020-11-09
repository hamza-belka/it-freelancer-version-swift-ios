//
//  Myapplications.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 09/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Myapplications: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
    let URL_MYAPPLICATIONS = "http://192.168.43.27/member/employerfreelancer/myapplicationsemp.php"
    let URL_INSERTHIRE = "http://192.168.43.27/member/employerfreelancer/hire.php"
    let URL_CHANGEJOBSTATUS = "http://192.168.43.27/member/jobs/changejobstatus.php"
    let URL_DELETEAPPLICATIONS = "http://192.168.43.27/member/employerfreelancer/deleteallapplications.php"
    let URL_HIRENOTIF = "http://192.168.43.27/member/hirenotif.php?send_notification"
    
    @IBOutlet weak var table: UITableView!
    @objc func hire(_ sender: UIButton) {
        
        var p = 0;
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        print(point)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        if (indexPath.row == nil) {
            p=0
        }else{
            p=indexPath.row
        }
      
        let job = result[p] as! Dictionary<String,Any>
        let  jobid = self.defaultValues.integer(forKey: "jobid")
        let  jobtitle = self.defaultValues.string(forKey: "jobtitle")!
       
        print(jobid)
        print(self.defaultValues.integer(forKey: "userid"))
       
     
        
        
        
        
        
        let  freelancerid = job["userid"] as! Int
        
        let employerid = self.defaultValues.integer(forKey: "userid")
        let freelancertitle = job["fullname"] as! String
        
        let freelancertoken = job["token"] as! String
        
        let alertController = UIAlertController(title: "Hire "+freelancertitle+" for "+jobtitle, message: "This operation cannot be reversed", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            //NSLog("OK Pressed")
            
            self.inserthire(freelancerid: freelancerid,empployerid: employerid,jobid: jobid)
            self.changejobstatus(jobid: jobid,freelancertitle: freelancertitle)
            self.deleteapplications(jobid: jobid)
            self.sendnotification(jobid: jobid,jobtitle: jobtitle, freelancertoken: freelancertoken)
            self.dismiss(animated: false, completion: nil)
            let myjoblist = self.storyboard?.instantiateViewController(withIdentifier: "myjoblist") as! MyJobList
            self.navigationController?.pushViewController(myjoblist, animated: true)
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
        
        
        
        
        
        //self.dismiss(animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(result.count)
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlejob", for: indexPath)
        
        let contentView = cell.viewWithTag(0)
        let fullname = contentView?.viewWithTag(2) as! UILabel
        let adress = contentView?.viewWithTag(4) as! UILabel
        let profiletitle = contentView?.viewWithTag(3) as! UILabel
        let apply = contentView?.viewWithTag(5) as! UIButton
        
        
        let posterimage = contentView?.viewWithTag(1) as! UIImageView
        
        
        
        
        
        
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let imgpath = job["userimage"] as! String
        
        fullname.text = job["fullname"] as! String
        profiletitle.text = job["profiletitle"] as! String
        adress.text = job["location"] as! String
        
        // let  id = job["jobid"]
        //   print(id!)
        
        let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
        let data = try? Data(contentsOf: url!)
        posterimage.image=UIImage(data: data!)
        posterimage.contentMode = .scaleAspectFill
        print(imgpath)
        print(posterimage.image == nil)
        apply.addTarget(self, action: #selector(hire), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["userid"] as! Int
        let freelancername=job["fullname"] as! String
        
        print(id)
        self.defaultValues.set(id, forKey: "freelancerid")
        self.defaultValues.set(freelancername, forKey: "freelancername")
        let freelancerdetails = self.storyboard?.instantiateViewController(withIdentifier: "freelancerdetails") as! Freelancerdetails
        self.navigationController?.pushViewController(freelancerdetails, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.defaultValues.integer(forKey: "jobid"))
        let jobtitle = self.defaultValues.string(forKey: "jobtitle")
        self.navigationController?.navigationBar.topItem!.title="Applications for "+jobtitle!
        self.table.reloadData()
        getlist()
        self.table.reloadData()

        // Do any additional setup after loading the view.
    }
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid"),
            "jobid":self.defaultValues.integer(forKey: "jobid")
            
        ]
        Alamofire.request(URL_MYAPPLICATIONS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            
            
            self.table.reloadData()
            
        }
        
    }
    func inserthire(freelancerid:Int,empployerid:Int,jobid:Int){
        let parameters: Parameters=[
            "freelancerid":freelancerid,
            "jobid":jobid,
            "employerid":empployerid
            
        ]
        Alamofire.request(URL_INSERTHIRE, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            self.table.reloadData()
            
        }
        
    }
    func changejobstatus(jobid:Int,freelancertitle:String){
        let parameters: Parameters=[
            "freelancername":"Job in progress (assigned to "+freelancertitle+")",
            "jobid":jobid
        ]
        Alamofire.request(URL_CHANGEJOBSTATUS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
           
            
            
            self.table.reloadData()
            
        }
        
    }
    func deleteapplications(jobid:Int){
        let parameters: Parameters=[
            "jobid":jobid
        ]
        Alamofire.request(URL_DELETEAPPLICATIONS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            self.table.reloadData()
            
        }
        
    }
    func sendnotification(jobid:Int, jobtitle:String, freelancertoken:String){
        let username = self.defaultValues.string(forKey: "full_name")!
        let txtmessage = username+" just accepted your job application for "+jobtitle
        
        let parameters: Parameters=[
            "textmsg":txtmessage,
            "jobid":jobid,
            "jobtitle":jobtitle,
            "token":freelancertoken
            
        ]
        Alamofire.request(URL_HIRENOTIF, method: .post, parameters: parameters).responseJSON{
            
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
