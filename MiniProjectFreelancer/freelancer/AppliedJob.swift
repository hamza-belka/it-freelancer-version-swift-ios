//
//  AppliedJob.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 10/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class AppliedJob: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    
    @IBOutlet weak var table: UITableView!
    
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
    let URL_APPLIED_JOBS = "http://192.168.43.27/member/jobs/appliedjobs.php"
    
    
    
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        Alamofire.request(URL_APPLIED_JOBS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            
            
            self.table.reloadData()
            
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
           
            
        }
        
        
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
}
