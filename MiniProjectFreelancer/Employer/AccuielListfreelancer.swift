//
//  AccuielListfreelancer.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 24/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit

class AccuielListfreelancer: UIViewController {

 
    @IBOutlet weak var listfree: UIView!
    
    @IBOutlet weak var segmentedb: UISegmentedControl!
    @IBOutlet weak var saved: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title="Saved freelancers"

        self.listfree.alpha = 0
        self.saved.alpha = 1
        self.listfree.reloadInputViews()
        self.saved.reloadInputViews()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func selectipage(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.listfree.alpha = 0
            self.saved.alpha = 1
            self.listfree.reloadInputViews()
            self.saved.reloadInputViews()
            var myClass : Savedfreelancers = self.children[0] as! Savedfreelancers
            myClass.table.reloadData()
            myClass.viewWillAppear(false)
            
            
        } else{ self.listfree.alpha = 1
            self.saved.alpha = 0
            self.listfree.reloadInputViews()
            self.saved.reloadInputViews()
            
            var myClass : Listfreelance = self.children[1] as! Listfreelance
            myClass.table.reloadData()
            myClass.viewWillAppear(false)
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem!.title="Jobs"
        self.segmentedb.selectedSegmentIndex=0
        self.viewDidLoad()
self.reloadInputViews()
       
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
