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
        
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){

                FireService.sharedInstance.SignUp(email: email, password: password) { (completed) in
                    if completed{
                        print("Signed Up Successfully")
                        self.goToTab()
                    }
                    else{
                        print("Error occured while signing up")
                    }
                }

            }
            else{
                print("Wrong email or password format")
            }
        }
        //print("Signed Up Successfully")
        
   }
    func goToTab(){
        let vc = UIStoryboard(name: "MainTabStoryboard", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
 
    

}
