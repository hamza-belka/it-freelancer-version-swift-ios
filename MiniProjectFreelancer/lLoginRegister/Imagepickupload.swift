//
//  Imagepickupload.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 02/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
class Imagepickupload: UIViewController {
    let URL_ADD_PROFILE = "http://192.168.43.27/member/profiles/addprofileinfosandimage.php"
    @IBOutlet weak var about: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var profiletitle: UITextField!
    var imagepicker = UIImagePickerController()
    @IBOutlet weak var imgpicker: UIImageView!
 
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
        
      
        

        // Do any additional setup after loading the view.
    }
    
 
    

    @IBAction func next(_ sender: UIButton) {
        let title=profiletitle.text!
        let location = adress.text!
        let abt = about.text!
        let image = imgpicker.image!
        let usermail = defaultValues.string(forKey: "usermail")!
        let userid = defaultValues.integer(forKey: "userid")
        
        
        
        let imgstrin = imgpicker.image!.pngData()!.base64EncodedString() as! String
  
      
        
        let parameters: Parameters=[
            "profiletitle":title,
            "location":location,
            "about":abt,
            "image":imgstrin,
            "userid":userid,
            "usermail":usermail]
        
        Alamofire.request(URL_ADD_PROFILE, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if((jsonData.value(forKey: "status") as! Int == 0)){
                        
                       
                       print("added successfully!")
                        //self.defaultValues.set(userid, forKey: "userid")
                        
                        
                        
                        if self.defaultValues.string(forKey: "role") == "freelancer"  {
                      let regeducation = self.storyboard?.instantiateViewController(withIdentifier: "regeducation") as! Regeducation
                        self.navigationController?.pushViewController(regeducation, animated: true)
                        self.dismiss(animated: false, completion: nil)
                 }else{ let dashboardemployer = self.storyboard?.instantiateViewController(withIdentifier: "dashboardemployer") as! DashboardEmployer
                         self.navigationController?.pushViewController(dashboardemployer, animated: true)
                         self.dismiss(animated: false, completion: nil)
                         
                         
                         }
                        //switching the screen
                        
                    }
                    
                }
                
        }
        
        
    }
    
 
    @IBAction func getimage(_ sender: UIButton) {
        imagepicker.sourceType = .photoLibrary
        imagepicker.allowsEditing = false
        present(imagepicker, animated: true , completion: nil )
        
        
    }}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


/*extension Imagepickupload : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
     @objc func imagePickerController(_ picker :UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if  let image = info[.originalImage] as? UIImage   {
            imgpicker.image = image
            
            
        
        }
        dismiss(animated: true, completion: nil)
    }
    
}*/

extension Imagepickupload : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker :UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if  let image = info[.originalImage] as? UIImage   {
            imgpicker.image = image            }
        dismiss(animated: true, completion: nil)
    }
    
}
