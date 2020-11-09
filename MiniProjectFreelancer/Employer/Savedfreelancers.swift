//
//  Savedfreelancers.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 24/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Savedfreelancers:UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    var result:NSArray = []
    let defaultValues = UserDefaults.standard
    let URL_SAVED_FREE = "http://192.168.43.27/member/employerfreelancer/savedfreelancers.php"
    
    
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        table.reloadData()
        getlist()
        table.reloadData()

        // Do any additional setup after loading the view.
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
        
        
        let posterimage = contentView?.viewWithTag(1) as! UIImageView
        
        
        
        
        
        
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let imgpath = job["imagepath"] as! String
        
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
        Alamofire.request(URL_SAVED_FREE, method: .post, parameters: parameters).responseJSON{
            
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
