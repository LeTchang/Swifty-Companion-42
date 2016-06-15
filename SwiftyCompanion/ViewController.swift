//
//  ViewController.swift
//  4chan
//
//  Created by Tchang on 04/06/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var loadButton: UIButton!
    
    var jsonData: JSON?
    var auth = AppAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mvallet - Intra 42"
        self.view.backgroundColor = UIColor(patternImage: UIImage(imageLiteral: "background"))
        
        errorView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        auth.get_token()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError() {
        view.addSubview(errorView)
        let topConstraint = errorView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 150)
        let leftConstraint = errorView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = errorView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = errorView.heightAnchor.constraintEqualToConstant(50)
        NSLayoutConstraint.activateConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        self.errorView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.errorView.alpha = 1.0
        }
    }
    
    func hideError() {
        UIView.animateWithDuration(0.4, animations: {
            self.errorView.alpha = 0
        }) { completed in
            if completed == true {
                self.errorView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func onLoad(sender: UIButton) {
        if loginText.text != "" {
            loadButton.enabled = false
            let login = loginText.text?.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            auth.check_user(login!) {
                completion in
                if completion != nil {
                    self.hideError()
                    self.jsonData = completion
                    self.performSegueWithIdentifier("Profile", sender: nil)
                    self.loadButton.enabled = true
                } else {
                    self.showError()
                    self.loadButton.enabled = true
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Profile" {
            let new = segue.destinationViewController as! ProfileViewController
            new.data = jsonData
        }
    }
}