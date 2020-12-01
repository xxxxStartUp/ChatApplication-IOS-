//
//  SnackBar+Extension.swift
//  Powerbankz
//
//  Created by  Muhammad Asyraf on 07/09/2020.
//  Copyright © 2020  Muhammad Asyraf. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

extension UIViewController{
    func snackbar(_ text:String){
        if(text != ""){
            if(text != "Login Expired"){
                let message = MDCSnackbarMessage()
                message.text = text
                MDCSnackbarManager.init().show(message)
            }
        }else{
            print("snackbar bypass")
        }
    }
}

extension FireService{
    func snackbar(_ text:String){
        if(text != ""){
            if(text != "Login Expired"){
                let message = MDCSnackbarMessage()
                message.text = text
                MDCSnackbarManager.init().show(message)
            }
        }else{
            print("snackbar bypass")
        }
    }
}
