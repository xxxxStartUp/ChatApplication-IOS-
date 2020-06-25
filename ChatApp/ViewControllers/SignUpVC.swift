//
//  SignUpVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: Constants.loginTabStoryBoardSegue, sender: self)
        
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUp()
        
        //self.goToTab()
        
        
    }
    
    
    func signUp(){
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){
                
                let data =
                    [ "firstname" : name,
                      "email":email
                    ]
                
                let user = FireUser(userID: 1, userName: name, userEmail: email, creationDate: Date())

                
                FireService.sharedInstance.SignUp(email: email, password: password) { (completed) in
                    if completed{
                        
                        FireService.sharedInstance.addData(user:user, data: data) { (error, sucess) in
                            
                            
                            if sucess{
                                let controller =  UIAlertController.alertUser( title: "Sucess", message: "you are signed up", whatToDo: "good job!")
                                self.present(controller, animated: true) {
                                    self.goToTab()
                                }
                                
                            }else{
                                let controller =  UIAlertController.alertUser( title: "error", message: error?.localizedDescription ?? "firebase error in save function", whatToDo: "Try again")
                                self.present(controller, animated: true, completion: nil)
                                
                            }
                        }
                        
                        
                        
                    }
                    else{
                        let controller =  UIAlertController.alertUser( title: "error", message: "Firebase Error Signing in", whatToDo: "Try again")
                        self.present(controller, animated: true, completion: nil)
                        print("Error occured while signing up")
                    }
                }
                
            }
            else{
                let controller =  UIAlertController.alertUser( title: "error", message: "Error with email and passowrd validator ", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
}


extension UIViewController {
    // to user this just type: let user = UIViewController.user
    
    var user : FireUser? {
        if let user = UserDefaults.standard.object(forKey: "user") as? FireUser{
            return user
        }else{
            return nil
        }
    }
}
