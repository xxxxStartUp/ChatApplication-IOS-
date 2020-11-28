//
//  DynamicLinkQRVC.swift
//  ChatApp
//
//  Created by  Muhammad Asyraf on 28/11/2020.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import QRCode
import Foundation
import MessageUI
import FirebaseDynamicLinks

class DynamicLinkQRVC: UIViewController {
    
    var QRString = ""
    var PromoText = ""
    var LinkUrl : URL?
    var FriendEmail = ""
    @IBOutlet weak var tvPromoText: UILabel!
    @IBOutlet weak var imageQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvPromoText.text = PromoText
        self.imageQR.image = {
            print("QR Value:\(QRString)")
            var qrCode = QRCode("\(QRString)")!
            qrCode.size = self.imageQR.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()
    }
    @IBAction func onClick_Share(_ sender: Any) {
        if(PromoText == "Friend Invitation"){
            if let url = LinkUrl{
                self.composeMail(url: url, friendEmail: FriendEmail)
            }else{
                let activityVC = UIActivityViewController(activityItems: [PromoText,QRString], applicationActivities: nil)
                self.present(activityVC,animated: true)
            }
        }else{
            let activityVC = UIActivityViewController(activityItems: [PromoText,QRString], applicationActivities: nil)
            self.present(activityVC,animated: true)
        }
    }
    @IBAction func onClick_Close(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            print("success dismiss view")
        }
    }
    @IBAction func onClick_CopyClipBoard(_ sender: Any) {
        UIPasteboard.general.string = "\(QRString)"
    }
}
extension DynamicLinkQRVC:MFMailComposeViewControllerDelegate{
    
    func composeMail(url:URL,friendEmail:String){
        print("Func is called")
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services not available")
            
            let activityVC = UIActivityViewController(activityItems: [PromoText,QRString], applicationActivities: nil)
            self.present(activityVC,animated: true)
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([friendEmail])
        composer.setSubject("\(globalUser.toFireUser.name) sent a friend request on the Soluchat App")

        composer.setMessageBody("Hello," + "\n" + "\n\(globalUser.toFireUser.name) has invited you to be a friend. Use the link below to accept his request and start chatting!" + "\n" + "\nThanks for choosing our app for your messaging needs. From all of us here at Solustack, Happy chatting!" + "\n" + "\n" + "\(url)", isHTML: false)
        
        present(composer, animated: true, completion: nil)
        
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Hello is dismissed")
        controller.dismiss(animated: true, completion: nil)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error{
            // create the alert
            let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            fatalError()
        }
        switch result {
            
        case .sent:
            DispatchQueue.main.async {
                // create the alert
                let alert = UIAlertController(title: "Invite Sent", message: "The invite has been sent to the selected contacts", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                 self.goToTab()
            }
        case .cancelled:
            self.goToTab()
            print("The cancel button has been clicked")
        case .failed:
            // create the alert
            let alert = UIAlertController(title: "Invite not sent", message: "The invite failed to be sent.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            self.goToTab()
        default:
            print("not sure")
            self.goToTab()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    


}
