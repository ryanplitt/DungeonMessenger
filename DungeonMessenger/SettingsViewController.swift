//
//  SettingsViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/10/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit
import CloudKit



class SettingsViewController: UIViewController {

    @IBOutlet weak var userNameTextLabel: UILabel!
    @IBOutlet weak var raceTextLabel: UILabel!
    @IBOutlet weak var classTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettingsWithInfo()
        reloadInputViews()

        // Do any additional setup after loading the view.
    }
    
    func updateSettingsWithInfo() {
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else {return}
            let user = User(ckRecord: record)
            self.userNameTextLabel.text = user?.userName
            self.raceTextLabel.text = user?.raceName
            self.classTextLabel.text = user?.className
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
