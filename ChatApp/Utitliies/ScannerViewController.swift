import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var pastViewController = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }

    func found(code: String) {
        FireService.sharedInstance.searchOneFriendWithhashKey(hashKey: code) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let user = user else {return}
            
                var isFriendExisted = false
                FireService.sharedInstance.loadAllFriends(user: globalUser.toFireUser) { (friends, error) in
                    
                    if let friends = friends{
                        var friendData : Friend = Friend.init(email: "", username: "", id: "")
                        for friend in friends{
                            if(user.email == friend.email){
                                isFriendExisted = true
                                friendData = friend
                            }
                        }
                        DispatchQueue.main.async {
                            if(!isFriendExisted){
                                FireService.sharedInstance.searchOneFreindWithEmail(email:user.email) { (freind, error) in
                                    if let error = error {
                                        print(error)
                                        self.pastViewController.snackbar("cannot add friend, deoes not exsist")
                    //                    fatalError("cannot add friend, deoes not exsist")
                                    }
                                    if let friend = freind {
                    //                        guard let globalUser = globalUser else {return}
                                        FireService.sharedInstance.addFriend(user:globalUser.toFireUser,sender: globalUser.toFireUser, friend: friend) { (sucess, error) in
                                            if let error = error{
                                                print(error)
                                            }else{
                                                if sucess {
                                                    self.pastViewController.snackbar("sucessfully added contact")
                                                    print("sucessfully added contact")
                                                }
                                            }
                                        }
                                    }
                                }
                            }else{
                                self.snackbar("\(friendData.username) is already a friend")
                            }
                        }
                        
                    }
                    
            }
            
        }
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
