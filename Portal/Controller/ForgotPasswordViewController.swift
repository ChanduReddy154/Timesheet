//
//  ForgotPasswordViewController.swift
//  Portal
//
//  Created by Chandu Reddy on 23/01/21.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func forgotButtonTapped(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                       },
                       completion: { Void in()  }
        )
        guard let email = emailField.text, !email.isEmpty else {
           toastMessages(message: "Please enter email.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
        if error != nil {
            self.toastMessages(message: "Email is not registered with us.")
            return
        }else {
            let alert = UIAlertController(title: "ResetPassword", message: "The reset link is sent to your mail", preferredStyle: UIAlertController.Style.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)  { (action) in
                self.emailField.text = ""
            }
            
            alert.addAction(alertAction)
            self.present(alert, animated: true)
            
        }
    }
    }
    
    func toastMessages(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-130, width: 250, height: 60))
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.backgroundColor = UIColor.link.withAlphaComponent(0.6)
        toastLabel.textColor = .black
        toastLabel.layer.cornerRadius = 15
        toastLabel.layer.borderWidth = 1
        toastLabel.layer.borderColor = UIColor.gray.cgColor
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1
        //toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        toastLabel.clipsToBounds = true
        //toastLabel.frame = CGRect(x: 50, y: 500, width: view.frame.width - 60, height: 50)
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isAnimated) in
            toastLabel.removeFromSuperview()
        }
    }

    
}
