//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/15/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    //Use this method to update the specified scene with the data from the provided activity object. UIKit calls this method on your app's main thread only after it receives all of the data for an activity object, which might originate from a different device.
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
                //check to see if there is an incomingURL
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL is \(incomingURL)")
        //this will parse the incoming dynamiclink URL and turn it into an object
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("Found an error! \(error?.localizedDescription)")
                    return
                }
                //check if the dynamic link object exists
                if let dynamicLink = dynamicLink{
                    self.handleIncomingDynamicLink(dynamicLink: dynamicLink)
                    
                }
            }
    
    }
    }
    
    func handleIncomingDynamicLink(dynamicLink:DynamicLink){
        guard let url = dynamicLink.url else{
            print("That's weird. My dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
        
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            print("I have received a URL through a custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromUniversalLink:url){
            self.handleIncomingDynamicLink(dynamicLink: dynamicLink)
            
        }
    }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

