//
//  AddFriendQRVC.swift
//  ChatApp
//
//  Created by  Muhammad Asyraf on 02/12/2020.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import QRCode
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class AddFriendQRVC: UIViewController {
    
    @IBOutlet weak var ivLinkQR: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var groupQRLink: UILabel!
    
    var YourName = ""
    var YourLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblGroupName.text = "My Personal Contact QR\n\(globalUser.toFireUser.name)"
        
            self.YourLink = createDynamicQR()
            self.groupQRLink.text = YourLink
            self.ivLinkQR.image = {
                print("QR Value:\(YourLink)")
                var qrCode = QRCode("\(YourLink)")!
                qrCode.size = self.ivLinkQR.bounds.size
                qrCode.errorCorrection = .High
                return qrCode.image
            }()
    }
    @IBAction func onClickCopyClipboard(_ sender: Any) {
        UIPasteboard.general.string = YourLink
    }
    @IBAction func onCLickShare(_ sender: Any) {
        if let url = URL(string: YourLink){
            let promoText = "Check out this app for solustack"
            let activityVC = UIActivityViewController(activityItems: [promoText,url], applicationActivities: nil)
            self.present(activityVC,animated: true)
        }
    }
    @IBAction func onClickClose(_ sender: Any) {
        createDynamicQR()
        dismiss(animated: true, completion: nil)
    }
    
    func createDynamicQR()->String{
        let linkValue = "\(globalUser.toFireUser.email)\(Date().DateConvert("yyyy-MM-ddHH:mm:ss"))"
        let encryp = MD5(string: linkValue).base64EncodedString()
        FireService.sharedInstance.addCustomData(data: ["hashKey":encryp], user: globalUser.toFireUser) { (error, sucess) in
            if sucess {
                print("DynamicQRGenerated")
                FireService.sharedInstance.refreshUserInfo(email: globalUser.toFireUser.email)
            }
        }
        return encryp
    }
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
//                    CC_SHA256(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
}
