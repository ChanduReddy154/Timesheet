//
//  RegistrationViewController.swift
//  Portal
//
//  Created by Chandu Reddy on 22/01/21.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class RegistrationLoginViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    let spinner = JGProgressHUD(style: .dark)
    @IBOutlet  weak var fullName: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPass: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    let toastView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPass!.contentHorizontalAlignment = .right
        forgotPass.isHidden = true
        registerButton.layer.cornerRadius = registerButton.frame.width / 2
        registerButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
       // view.addSubview(toastView)
        toastView.frame = CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-130, width: 250, height: 80)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
@IBAction func registerButtonTapped(_ sender: UIButton) {
        
        let image1 = UIImage(systemName: "arrow.right.circle.fill")
        let image2 = UIImage(systemName: "arrow.right.circle")
    let emailText = email.text
    let passText = passWord.text
    let nameText = fullName.text
        if registerButton.currentImage == image1 {
          //  print("Register Button")
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
            
            guard !emailText!.isEmpty, !passText!.isEmpty, !nameText!.isEmpty else {
                toastMessages(message: "Please fill all the mandetory fields.")
                return
            }
            spinner.show(in: view)
            FirebaseAuth.Auth.auth().createUser(withEmail: emailText!, password: passText!) { (result, error) in
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                if error != nil {
                    self.toastMessages(message: "Email Already Exists")
                    return
                }
                guard result != nil, error == nil else {
                    print("Error while creating user")
                    return
                }
                DataBaseManager.shared.insertUser(with: Users(userName: nameText!, userEmail: emailText!, userPassword: passText!))
                self.performSegue(withIdentifier: "send", sender: self)
            }
            
        }  else  if registerButton.currentImage ==  image2 {
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
            guard !emailText!.isEmpty, !passText!.isEmpty else {
                toastMessages(message: "Please Enter Email and Password.")
                return
            }
           // validEmailAndPassword()
            spinner.show(in: view)
            FirebaseAuth.Auth.auth().signIn(withEmail: emailText!, password: passText!) { [self] (result, error) in
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                guard error == nil else {
                    self.toastMessages(message: "Email or Password is incorrect.")
                   
                    return
                }
                if error != nil {
                    print("Error while signing in")
                }
               // UserDefaults.standard.set(email, forKey: "email")
                self.performSegue(withIdentifier: "send", sender: self)
                //self.navigationController?.dismiss(animated : true, completion : nil)
            }
            
        } else {
            print("No Button tapped")
        }
    }
    
    func validEmailAndPassword() {
        let emailText = email.text
        let passText = passWord.text
        if isValidEmail(emailText!) == false {
            toastMessages(message: "Please enter valid email.")
        }
        if isValidPassword(passText!) == false {
            toastMessages(message: "Password must be atleast 6 characters with alteast 1 numeric, 1 capital and 1 special character")
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if signInButton.currentTitle == "SignIn" {
            email.text = ""
            passWord.text = ""
            UITextField.transition(with: fullName, duration: 0.1,
                                   options: .transitionFlipFromBottom,
                                   animations: {
                                    self.fullName.isHidden = true
                                    self.nameView.isHidden = true
                                   })
            registerButton.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
            titleText.text = "SignIn"
            forgotPass.isHidden = false
            textLabel.text = "Don't Have an Acc?"
            signInButton.setTitle("SignUp", for: .normal)
        } else if signInButton.currentTitle == "SignUp" {
            email.text = ""
            fullName.text = ""
            passWord.text = ""
            UITextField.transition(with: fullName, duration: 0.1,
                                   options: .transitionFlipFromTop,
                                   animations: {
                                    self.fullName.isHidden = false
                                    self.nameView.isHidden = false
                                   })
            forgotPass.isHidden = true
            titleText.text = "SignUp"
            registerButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
            textLabel.text = "Already Have An Acc?"
            signInButton.setTitle("SignIn", for: .normal)
        }
        
        
    }
    
    
    @IBAction func forgotPassTapped(_ sender: Any) {
      performSegue(withIdentifier: "forgot", sender: self)
       // navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }

    func toastMessages(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-160, width: 250, height: 80))
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
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isAnimated) in
            toastLabel.removeFromSuperview()
        }
    }
       
    
    func gradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.link.cgColor, UIColor.gray.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}

 func isValidPassword(_ password : String) -> Bool {
    let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordTest.evaluate(with: password)
}

 func isValidEmail(_ email : String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

