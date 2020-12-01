//
//  GroupLinkQRVC.swift
//  ChatApp
//
//  Created by  Muhammad Asyraf on 02/12/2020.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import QRCode

class GroupLinkQRVC: UIViewController {

    @IBOutlet weak var ivLinkQR: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var groupQRLink: UILabel!
    
    var groupName = ""
    var groupLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblGroupName.text = "Group Invitation\n\(groupName)"
        groupQRLink.text = groupLink
        self.ivLinkQR.image = {
            print("QR Value:\(groupLink)")
            var qrCode = QRCode("\(groupLink)")!
            qrCode.size = self.ivLinkQR.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()
    }
    @IBAction func onClickCopyClipboard(_ sender: Any) {
        UIPasteboard.general.string = groupLink
    }
    @IBAction func onCLickShare(_ sender: Any) {
        if let url = URL(string: groupLink){
            let promoText = "Check out this app for solustack"
            let activityVC = UIActivityViewController(activityItems: [promoText,url], applicationActivities: nil)
            self.present(activityVC,animated: true)
        }
    }
    @IBAction func onClickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension UIViewController{
    func toGroupQRLink(groupLink:String,groupName:String){
        let storyboard: UIStoryboard = UIStoryboard(name: "GroupInfoSB", bundle: nil )
        let main: GroupLinkQRVC = storyboard.instantiateViewController(withIdentifier: "GroupLinkQRVC") as! GroupLinkQRVC
        main.groupLink = groupLink
        main.groupName = groupName
        main.modalPresentationStyle = .overFullScreen
        main.modalTransitionStyle = .crossDissolve
        self.present(main, animated: true, completion: nil)
    }

}
