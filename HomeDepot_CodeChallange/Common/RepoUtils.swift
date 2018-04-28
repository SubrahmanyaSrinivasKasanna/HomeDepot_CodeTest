//
//  RepoUtils.swift
//  HomeDepot_CodeChallange
//
//  Created by  MyMac on 4/27/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit

public class RepoUtils{
    /**
     To show the alert in the application
     - parameter controller:  Controller which need to display alert
     - parameter title:  Title for alert
     - parameter message:  Message for alert
     */
    static func showAlert(controller: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
