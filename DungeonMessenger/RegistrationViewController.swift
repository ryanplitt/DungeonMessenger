//
//  RegistrationViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/10/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var raceField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var biographyField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        guard let name = userNameField.text where userNameField.text?.characters.count > 0,
        let race = raceField.text where raceField.text?.characters.count > 0,
            let classField = classTextField.text where classTextField.text?.characters.count > 0 else {return}
        UserController.sharedController.createUser(name, raceName: race, className: classField)
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
