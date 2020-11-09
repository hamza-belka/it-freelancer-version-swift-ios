//
//  AcceuilListjob.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 18/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit

class AcceuilListjob: UIViewController {

    @IBAction func selectview(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0 {
            self.cjoblist.alpha = 1
            self.csaved.alpha = 0
            self.applylist.alpha=0
            self.cjoblist.reloadInputViews()
            
            var myClass : Listjobs = self.children[0] as! Listjobs
            myClass.table.reloadData()
            myClass.viewWillAppear(false)
            

        } else if sender.selectedSegmentIndex == 1{ self.cjoblist.alpha = 0
            self.csaved.alpha = 1
             self.applylist.alpha=0
            
            self.csaved.reloadInputViews()
            var myClass : Savedjob = self.children[1] as! Savedjob
            myClass.table.reloadData()
            myClass.viewWillAppear(false)
            
        }else {self.cjoblist.alpha = 0
            self.csaved.alpha = 0
            self.applylist.alpha=1
            self.applylist.reloadInputViews()
            var myClass : AppliedJob = self.children[2] as! AppliedJob
            myClass.table.reloadData()
            myClass.viewWillAppear(false)
            
        }
        
    }
    @IBOutlet weak var applylist: UIView!
    @IBOutlet weak var cjoblist: UIView!
    @IBOutlet weak var csaved: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title="Jobs"
          self.cjoblist.alpha = 1
         self.csaved.alpha = 0
         self.applylist.alpha=0
        
        
        
       
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        self.reloadInputViews()
        
    
   
    

   

}
}
