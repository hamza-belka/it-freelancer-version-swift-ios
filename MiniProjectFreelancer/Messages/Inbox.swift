//
//  Inbox.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 11/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Inbox: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    let defaultValues = UserDefaults.standard
    var result:NSArray = []
    let URL_LISTMSG = "http://192.168.43.27/member/messages/inbox.php"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let contentView = cell.viewWithTag(0)
        let view=contentView?.viewWithTag(1) as! UIView
        let posterimage = view.viewWithTag(2) as! UIImageView
        let title = view.viewWithTag(3) as! UILabel
        let date = view.viewWithTag(4) as! UILabel
        let object = view.viewWithTag(5) as! UILabel
        
        
        
        
        let imgpath = job["userimage"] as! String
        
        
        title.text = job["fullname"] as! String
        date.text = job["date"] as! String
        object.text = job["object"] as! String
        
       
      
        let  id = job["msgid"]
        print(id!)
        let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
        let data = try? Data(contentsOf: url!)
        posterimage.image=UIImage(data: data!)
        posterimage.contentMode = .scaleAspectFill
       
      
        
        return cell
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.reloadData()
        getlist()
        self.table.reloadData()
        // Do any additional setup after loading the view.
    }
    func getlist(){
        let parameters: Parameters=[
            "userid":self.defaultValues.integer(forKey: "userid")
        ]
        Alamofire.request(URL_LISTMSG, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
            self.table.reloadData()
            
            
            
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = result[indexPath.row] as! Dictionary<String,Any>
        let  id = job["msgid"] as! Int
        let senderid = job["senderid"] as! Int
        
      
        
        print(id)
        self.defaultValues.set(id, forKey: "msgid")
        
        
        let messagedetails = self.storyboard?.instantiateViewController(withIdentifier: "messagedetails") as! Messagedetails
        self.navigationController?.pushViewController(messagedetails, animated: true)
        self.dismiss(animated: false, completion: nil)
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
