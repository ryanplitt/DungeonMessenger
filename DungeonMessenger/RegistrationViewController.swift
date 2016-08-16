//
//  RegistrationViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/15/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var raceName: UITextField!
    @IBOutlet weak var className: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sumbitButtonTapped(sender: AnyObject) {
        guard let userName = userName.text where userName.characters.count > 0,
        let raceName = raceName.text where raceName.characters.count > 0,
            let className = className.text where className.characters.count > 0 else {return}
        UserController.sharedController.saveNewUser(userName, race: raceName, className: className)
        self.dismissViewControllerAnimated(true) { 
            //
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
