//
//  Listfreelance.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 24/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class Listfreelance: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
     let URL_LIST_FREE = "http://192.168.43.27/member/employerfreelancer/listfreelancer.php"
    let URL_SAVE_FREE = "http://192.168.43.27/member/employerfreelancer/savefreelancer.php"

    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.reloadData()
        getlist()
        table.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
    
    @objc func Savefreelancer(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: table as UIView)
        let indexPath: IndexPath! = table.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["userid"]
        print(id!)
        print(self.defaultValues.integer(forKey: "userid"))
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid"),
            "freelancerid":id!
        ]
        
        Alamofire.request(URL_SAVE_FREE, method: .post, parameters: parameters).responseJSON
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
                        
                        self.viewDidLoad()
                        
                    }else{
                        //error message in case of invalid credential
                        //self.labelMessage.text = "Invalid username or password"
                        print("save unseccessful")
                    }
                }
                
                
        }}
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(result.count)
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlejob", for: indexPath)
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let imgpath = job["imagepath"] as! String
        
        let contentView = cell.viewWithTag(0)
        let fullname = contentView?.viewWithTag(2) as! UILabel
        let adress = contentView?.viewWithTag(4) as! UILabel
        let profiletitle = contentView?.viewWithTag(3) as! UILabel
        let save = contentView?.viewWithTag(6) as! UIButton

        
        let posterimage = contentView?.viewWithTag(1) as! UIImageView
        
        
        
        
        
        
      
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
        
         save.addTarget(self, action: #selector(Savefreelancer), for: .touchUpInside)
        
        
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
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        Alamofire.request(URL_LIST_FREE, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            
            
            self.table.reloadData()
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getlist()
        self.table.reloadData()
    }


}
