//
//  String+Extension.swift
//  ChatApp
//
//  Created by  Muhammad Asyraf on 01/12/2020.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import Kingfisher

extension String{
    
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
    
    func replace(this:String,with:String)->String{
        return self.replacingOccurrences(of: this, with: with, options: NSString.CompareOptions.literal, range: nil)
    }
    func saveImage(image: UIImage , named:String) -> Bool {
        guard let data = image.jpegData(compressionQuality:1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(named)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func ImageUrl(iv:UIImageView,scale: UIView.ContentMode,_ saveImageInPhone:Bool){
        iv.image = UIImage(named: "placeholder_square")
        if(self == ""){
            
        }else{
            if(saveImageInPhone){
                let saveName = self.replace(this: "https://", with: "").replace(this: "/", with: "_").replace(this: ".com", with: "").replace(this: "-", with: "").replace(this: ".jpg", with: "").replace(this: ".png", with: "")
                let image = getSavedImage(named: saveName)
                if(image != nil){
                    print("local from Document Success : (saveName)")
                    iv.image = image
                }else{
                    self.getUIImagefromUrl(imageview:iv ,url: "\(self.encodeUrl)")
                }
            }else{
                self.getUIImagefromUrl(imageview:iv ,url: "\(self.encodeUrl)")
            }
        }
        iv.contentMode = scale
    }
    
    func getImageUrl()->UIImage{
        if(self == ""){
            return UIImage()
        }else{
            let saveName = self.replace(this: "https://", with: "").replace(this: "/", with: "_").replace(this: ".com", with: "").replace(this: "-", with: "").replace(this: ".jpg", with: "").replace(this: ".png", with: "")
            if let image = getSavedImage(named: saveName){
                return image
            }else{
                return UIImage()
            }
        }
    }
    
    
    func getUIImagefromUrl(imageview:UIImageView,url : String){
        if((NSURL(string: url)) != nil){
            
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            imageview.kf.indicatorType = .activity
            imageview.kf.setImage(with: resource, placeholder: nil, options: [.processor(DefaultImageProcessor.default)]) { (int64f, int64l) in
                print("progress \(int64f) : \(int64l)")
            } completionHandler: { (image, error, cache, url1) in
                if(error != nil){
                    print(error ?? "no error")
                }else{
                    if let imageNew = image{
                        let imageItem = imageNew
                        let saveName = url.replace(this: "https://", with: "").replace(this: "/", with: "_").replace(this: ".com", with: "").replace(this: "-", with: "").replace(this: ".jpg", with: "").replace(this: ".png", with: "")
                        if(self.saveImage(image: imageItem,named: "\(saveName).png")){
                            print("save image Success \(saveName)")
                        }
                    }
                }
            }
            
//            ImageDownloader.default.downloadImage(with: URL(string: url)!, options: [], progressBlock: nil) {
//                (image, error, url1, data) in
//                let marginHeight = CGFloat(imageview.bounds.size.height * 3)
//                if(image != nil){
//                    //                            print("5 - Load with Scaled \(url)")
//                    let height = (image?.size.height)!/((image?.size.height)!/marginHeight)
//                    let width = (image?.size.width)!/((image?.size.height)!/marginHeight)
//                    let processor = ResizingImageProcessor(referenceSize: CGSize(width: width, height: height))
//                    let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
//
//
//                    imageview.kf.setImage(with: resource, options: [.processor(processor)], completionHandler: { (image, error, cache, url1) in
//                        if(error != nil){
//                            print(error ?? "no error")
//                        }else{
//                            if let imageNew = image{
//                                let imageItem = imageNew
//                                let saveName = url.replace(this: "https://", with: "").replace(this: "/", with: "_").replace(this: ".com", with: "").replace(this: "-", with: "").replace(this: ".jpg", with: "").replace(this: ".png", with: "")
//                                if(self.saveImage(image: imageItem,named: "\(saveName).png")){
//                                    print("save image Success \(saveName)")
//                                }
//                            }
//                        }
//                    })
//                }else{
//                    //                            print("5 - Load cache without Scaled \(url)")
//                    let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
//                    imageview.kf.setImage(with: resource, options: [.cacheMemoryOnly], completionHandler: { (image, error, cache, url1) in
//                        if(error != nil){
//                            print(error ?? "no error")
//                        }else{
//                            if let imageNew = image{
//                                let imageItem = imageNew
//                                let saveName = url.replace(this: "https://", with: "").replace(this: "/", with: "_").replace(this: ".com", with: "").replace(this: "-", with: "").replace(this: ".jpg", with: "").replace(this: ".png", with: "")
//                                if(self.saveImage(image: imageItem,named: "\(saveName).png")){
//                                    print("save image Success \(saveName)")
//                                }
//                            }
//                        }
//                    })
//                }
//            }
        }else{
            imageview.image = UIImage(named: "placeholder_square")
        }
    }
}
