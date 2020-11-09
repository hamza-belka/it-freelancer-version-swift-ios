//
//  Messagescontroller.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 11/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit

class Messagescontroller: UIViewController {

   
    
    @IBOutlet weak var segmentedbutton: UISegmentedControl!
    @IBAction func newmessage(_ sender: UIButton) {
        let newmessage = self.storyboard?.instantiateViewController(withIdentifier: "newmessage") as! Newmessage
        self.navigationController?.pushViewController(newmessage, animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    @IBOutlet weak var linbox: UIView!
    @IBOutlet weak var lsent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title="Messages"
        self.linbox.alpha = 1
        self.lsent.alpha = 0
        self.linbox.reloadInputViews()
        self.lsent.reloadInputViews()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectindex(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.linbox.alpha = 1
            self.lsent.alpha = 0
            self.linbox.reloadInputViews()
            self.lsent.reloadInputViews()
            
            
        } else{ self.linbox.alpha = 0
            self.lsent.alpha = 1
            self.linbox.reloadInputViews()
            self.lsent.reloadInputViews()
            
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
