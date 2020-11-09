//
//  Newmessage.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 11/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class Newmessage: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var URL_GETCONTACTS="";
    let URL_ADDMSG="http://192.168.43.27/member/messages/addmessage.php"
    let URL_MSGNOTIF = "http://192.168.43.27/member/sendmessagenotification.php?send_notification"
    var result:NSArray = []
    var selectedvalue=""
    var receivertoken=""
    var receiverid=0
    
    let defaultValues = UserDefaults.standard
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return result.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let job = result[row] as! Dictionary<String,Any>
        let contactname=job["fullname"] as! String
        print("selected name"+contactname)
        
        return contactname
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let job = result[row] as! Dictionary<String,Any>
        selectedvalue=job["fullname"] as! String
        receivertoken=job["token"] as! String
        receiverid=job["userid"] as! Int
        
        
        
        self.selectedcontactlabel.text=selectedvalue
        
        
    }
    

    @IBOutlet weak var contactpickers: UIPickerView!
    
    @IBOutlet weak var selectedcontactlabel: UILabel!
    
    @IBOutlet weak var object: UITextField!
    @IBOutlet weak var messagebody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let role=self.defaultValues.string(forKey: "role")
        if(role == "freelancer"){
            URL_GETCONTACTS="http://192.168.43.27/member/messages/contactemployers.php"
        }else{
            URL_GETCONTACTS="http://192.168.43.27/member/messages/contactfreelancers.php"

        }
        self.contactpickers.reloadAllComponents()
        self.getcontacts();
        self.contactpickers.reloadAllComponents()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendmessage(_ sender: UIButton) {
        if((self.messagebody.text=="") || (self.messagebody.text==nil) )
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
            let title = username+" sent you a message"
            let txtobject = self.object.text as! String
            let txtmessage = self.messagebody.text as! String
            
        
        
        let parameters: Parameters=[
            "title":title,
            "object":txtobject,
            "messagebody":txtmessage,
            "senderid":self.defaultValues.integer(forKey: "userid"),
            "sendertoken":self.defaultValues.string(forKey: "usertoken")!,
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
                        self.sendnotification(receivertoken: self.receivertoken, sendertoken: self.defaultValues.string(forKey: "usertoken")!)
                        print("message added ")
                        let alert = UIAlertController(title: "Message Submitted", message: "YOUR Message HAVE BEEN ADDED", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        
                        self.present(alert,animated: true,completion: nil)
                        
                        
                        
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
    func getcontacts(){
       
        Alamofire.request(URL_GETCONTACTS, method: .get).responseJSON{
            
            response in
            
            
            
            print(response.result.value)
            
            self.result = response.result.value as! NSArray
           
            self.contactpickers.reloadAllComponents()
            
            
            
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
