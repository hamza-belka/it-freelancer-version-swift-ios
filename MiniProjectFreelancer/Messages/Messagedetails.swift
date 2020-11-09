//
//  Messagedetails.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 11/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire

class Messagedetails: UIViewController {
let defaultValues = UserDefaults.standard
    let URL_MSGDETAILS = "http://192.168.43.27/member/messages/msgdetails.php"
    let URL_ADDMSG="http://192.168.43.27/member/messages/addmessage.php"
    let URL_MSGNOTIF = "http://192.168.43.27/member/sendmessagenotification.php?send_notification"
    var receivertoken=""
    var receiverid=0
    @IBAction func reply(_ sender: UIButton) {
        if((self.replyfield.text=="") || (self.replyfield.text==nil) )
        {
            let alertController = UIAlertController(title: "Send Message ", message: "Message body cannot be empty", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                //NSLog("OK Pressed")
                
                self.dismiss(animated: false, completion: nil)
                
                
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            let username = self.defaultValues.string(forKey: "full_name")!
            let title = username+" replied to your message"
            let txtobject = self.object.text as! String
            let txtmessage = self.replyfield.text as! String
            
            
            
            let parameters: Parameters=[
                "title":title,
                "object":txtobject,
                "messagebody":txtmessage,
                "senderid":self.defaultValues.integer(forKey: "userid"),
                "sendertoken":self.defaultValues.string(forKey: "token")!,
                "receiverid":receiverid,
                "receivertoken":receivertoken]
            
            Alamofire.request(URL_ADDMSG, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        //if there is no error
                        if((jsonData.value(forKey: "status") as! Int == 0)){
                            
                            print("message added ")
                            let alert = UIAlertController(title: "Message Submitted", message: "YOUR Message HAVE BEEN ADDED", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            
                            alert.addAction(action)
                            
                            self.present(alert,animated: true,completion: nil)
                            
                             self.sendnotification(receivertoken: self.receivertoken, sendertoken: self.defaultValues.string(forKey: "usertoken")!)
                            
                            
                        }
                    }
                    
            }
        }
        let role=self.defaultValues.string(forKey: "role")
        if(role == "freelancer"){
            let dashboardfreelancer = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! DashbordFreelancer
            self.navigationController?.pushViewController(dashboardfreelancer, animated: true)
            self.dismiss(animated: false, completion: nil)
        }else{
            let dashboardemployer = self.storyboard?.instantiateViewController(withIdentifier: "dashboardemployer") as! DashboardEmployer
            self.navigationController?.pushViewController(dashboardemployer, animated: true)
            self.dismiss(animated: false, completion: nil)}
        
        
        
    }
    @IBOutlet weak var reply: UIButton!
    @IBOutlet weak var replyfield: UITextView!
    @IBOutlet weak var senderimg: UIImageView!
    @IBOutlet weak var sendername: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var object: UILabel!
    @IBOutlet weak var msgbody: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let msgid=self.defaultValues.integer(forKey: "msgid")
        getdetails(msgid: msgid)

        // Do any additional setup after loading the view.
    }
    func getdetails(msgid:Int){
        let parameters: Parameters=[
            "messageid":msgid
        ]
        Alamofire.request(URL_MSGDETAILS, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            let result = response.result.value as! NSDictionary
            let jsonData = result.value(forKey: "message") as! NSDictionary
            self.sendername.text=jsonData.value(forKey: "fullname") as! String
            self.date.text=jsonData.value(forKey: "date") as! String
            self.object.text=jsonData.value(forKey: "object") as! String
            self.msgbody.text=jsonData.value(forKey: "messagebody") as! String
            let imgpath = jsonData.value(forKey: "userimage") as! String
            let url = URL(string:"http://192.168.43.27/member/profiles/"+imgpath)
            self.receivertoken=jsonData.value(forKey: "sendertoken") as! String
            self.receiverid=jsonData.value(forKey: "senderid") as! Int
            let data = try? Data(contentsOf: url!)
            self.senderimg.image=UIImage(data: data!)
            self.senderimg.contentMode = .scaleAspectFill
            if ((jsonData.value(forKey: "senderid") as! Int)==self.defaultValues.integer(forKey: "userid")){
                self.reply.isHidden=true
                self.replyfield.isHidden=true
                
            }
            
            
            
            
            
            
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
    func sendnotification(receivertoken:String, sendertoken:String){
        let username = self.defaultValues.string(forKey: "full_name")!
        let txtmessage = username+" just sent you a message"
        
        let parameters: Parameters=[
            "textmsg":self.object.text as! String,
            "type":"message",
            "title":txtmessage,
            "token":receivertoken,
            "sendertoken":sendertoken
        ]
        Alamofire.request(URL_MSGNOTIF, method: .post, parameters: parameters).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            
            
            
            
            
        }
        
    }
}
