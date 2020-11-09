//
//  Job.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 23/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit

class Jobs: Codable{

    let jobs: [Job]
    
    init(jobs: [Job]) {
        self.jobs = jobs
    }
}


class Job: Codable {
    let title: String
    let description: String
    let budgettype: String
    let budget: String
    let skills: String
    let postermail: String
    let posterid: Int
    let datepost: Date
    
    init(title: String, description: String, budgettype: String, budget: String, skills: String, postermail: String, posterid: Int, datepost: Date) {
        self.title = title
        self.description = description
        self.budgettype = budgettype
        self.budget = budget
        self.skills = skills
        self.postermail = postermail
        self.posterid = posterid
        self.datepost = datepost
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
