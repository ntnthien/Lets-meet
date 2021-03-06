//
//  MoreViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/10/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class MoreViewController: BaseViewController {
    private var authStateDidChangeHandle: FIRAuthStateDidChangeListenerHandle?
    
    private(set) var auth: FIRAuth? = FIRAuth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If you haven't set up your authentications correctly these buttons
        // will still appear in the UI, but they'll crash the app when tapped.
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeAuthStateDidChangeListener(handle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    @IBAction func loginButtonTouched(sender: AnyObject) {
//        let controller = self.authUI!.authViewController()
//        self.presentViewController(controller, animated: true, completion: nil)
//    }
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
      //  LoginManager().logOut()
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let tb = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        self.presentViewController(tb, animated: true, completion: nil)
        do {
            try self.auth?.signOut()
        } catch let error {
            // Again, fatalError is not a graceful way to handle errors.
            // This error is most likely a network error, so retrying here
            // makes sense.
            fatalError("Could not sign out: \(error)")
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    static func fromStoryboard(storyboard: UIStoryboard = AppDelegate.mainStoryboard) -> MoreViewController {
        return storyboard.instantiateViewControllerWithIdentifier(MORE_VC_ID) as! MoreViewController
    }
}
