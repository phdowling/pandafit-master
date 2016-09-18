//
//  LevelSelectionViewController.swift
//  PandaFit
//
//  Created by Felix Sonntag on 17/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit

class LevelSelectionViewController: UIViewController {

    let infoMessage = "Your panda is in content mood at the moment. Walk a little to make him happy and preserve him from dying. 🐼"
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func startingPandaSelected(_ sender: AnyObject) {
        
        if let name = nameTextField.text {
            if name == "" {
                let alertController = self.createNoNameAlertController()
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = self.createConfirmationAlertController(level: "StartingPanda")
                UserDefaults.standard.set(name, forKey: "name")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func mediumPandaSelected(_ sender: AnyObject) {
        
        if let name = nameTextField.text {
            if name == "" {
                let alertController = self.createNoNameAlertController()
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = self.createConfirmationAlertController(level: "MediumPanda")
                UserDefaults.standard.set(name, forKey: "name")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func superPandaSelected(_ sender: AnyObject) {
        
        if let name = nameTextField.text {
            if name == "" {
                let alertController = self.createNoNameAlertController()
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = self.createConfirmationAlertController(level: "SuperPanda")
                UserDefaults.standard.set(name, forKey: "name")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func createNoNameAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "No Name Entered", message:"Please enter a name for your panda", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright!", style: .default))
        return alertController
    }
    
    func createConfirmationAlertController(level: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Super Panda", message:
            self.infoMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright!", style: .default) { (action) in
            let statusViewController = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
            UserDefaults.standard.set(level, forKey: "level")
            self.present(statusViewController, animated: true, completion: nil)
        })
        return alertController
        
    }
}

extension LevelSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
