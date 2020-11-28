//
//  Navigation.swift
//  AST Plus
//
//  Created by  Muhammad Asyraf on 30/09/2020.
//

import UIKit
import Foundation
import UIKit
import SafariServices

extension UIStoryboard{
    func getInstantVC(_ name:String)-> UIViewController{
        return instantiateViewController(withIdentifier: name)
    }
}

extension UIViewController{
    func root()-> UIViewController{
        let viewControllers = self.navigationController!.viewControllers
        let countTopHeirachyPosition = viewControllers.count - 2
        return viewControllers[countTopHeirachyPosition]
    }
    func push(to vc: UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func present(to vc: UIViewController,_ animated:Bool){
        if(animated){
            self.modalTransitionStyle = .crossDissolve
            self.modalPresentationStyle = .overCurrentContext
        }
        self.present(vc, animated: true, completion: nil)
    }
    func openURLInApp(request: String){
        let shareString = "\(request)"
        let url = URL(string: shareString)!
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    func getStoryboardbyName(_ name:String)-> UIStoryboard{
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil )
        return storyboard
    }
    func onBackbuttonPressed(_ animated:Bool){
        self.navigationController?.popViewController(animated: animated)
    }
    
//    func restartApplication () {
//        let viewController : SplashScreen = getStoryboardbyName("Main").getInstantVC("SplashScreen") as! SplashScreen
//        let navCtrl = UINavigationController(rootViewController: viewController)
//        navCtrl.isNavigationBarHidden = true
//
//        guard
//                let window = UIApplication.shared.keyWindow,
//                let rootViewController = window.rootViewController
//                else {
//            return
//        }
//        navCtrl.view.frame = rootViewController.view.frame
//        navCtrl.view.layoutIfNeeded()
//
//        UIView.transition(with: window, duration: 0.0, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = navCtrl
//        })
//    }
    
//    func toMainActivity () {
//        let viewController : MainActivity = getStoryboardbyName("Main").getInstantVC("MainActivity") as! MainActivity
//        let navCtrl = UINavigationController(rootViewController: viewController)
//        navCtrl.isNavigationBarHidden = true
//
//        guard
//                let window = UIApplication.shared.keyWindow,
//                let rootViewController = window.rootViewController
//                else {
//            return
//        }
//        navCtrl.view.frame = rootViewController.view.frame
//        navCtrl.view.layoutIfNeeded()
//
//        UIView.transition(with: window, duration: 0.0, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = navCtrl
//        })
//    }
//    func toLogin () {
//        let viewController : Login = getStoryboardbyName("Main").getInstantVC("Login") as! Login
//        let navCtrl = UINavigationController(rootViewController: viewController)
//        navCtrl.isNavigationBarHidden = true
//
//        guard
//                let window = UIApplication.shared.keyWindow,
//                let rootViewController = window.rootViewController
//                else {
//            return
//        }
//        navCtrl.view.frame = rootViewController.view.frame
//        navCtrl.view.layoutIfNeeded()
//
//        UIView.transition(with: window, duration: 0.0, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = navCtrl
//        })
//    }
    func toDynamicLinkQRVC (qrString: String,promoText: String,linkUrl: URL,friendEmail: String) {
        let viewController : DynamicLinkQRVC = getStoryboardbyName("DynamicLink").getInstantVC("DynamicLinkQRVC") as! DynamicLinkQRVC
        viewController.QRString = qrString
        viewController.PromoText = promoText
        viewController.LinkUrl = linkUrl
        viewController.FriendEmail = friendEmail
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        present(to: viewController, true)
    }
}
