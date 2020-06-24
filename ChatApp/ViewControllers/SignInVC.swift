//
//  SignInVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func Login(_ sender: Any) {
        
        login()
       // self.goToTab()
    }
    
    
    
    
    
    func login() -> Void {
        if let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){
                
                FireService.sharedInstance.signIn(email: email, password: password) { (completed) in
                    if completed{
                        print("Signed In Successfully")
                        let controller =  UIAlertController.alertUser( title: "Sucess", message: "you signed in sucesfully", whatToDo: "Go to home screen")
                        self.present(controller, animated: true) {
                            
                            self.goToTab()
                        }
                        
                    }
                    else{
                        let controller =  UIAlertController.alertUser( title: "error", message: "Firebase Error Signing in", whatToDo: "Try again")
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                }
                
            }
            else{
                
                let controller =  UIAlertController.alertUser( title: "Error with email or password", message: "Wrong email or password format", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    
}

extension UIAlertController {
    
    
    static func alertUser(title : String , message : String , whatToDo : String) -> UIAlertController {
        
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertControler.addAction(UIAlertAction(title: whatToDo, style: .cancel))
        return alertControler
        
    }
}


extension UIViewController {
    
    
    func goToTab(){
        self.dismiss(animated: true) {
            let vc = UIStoryboard(name: "MainTabStoryboard", bundle: nil).instantiateInitialViewController()!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
