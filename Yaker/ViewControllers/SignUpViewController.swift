//
//  SignUpViewController.swift
//  Yaker
//
//  Created by Francisco Barreto on 30/10/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var yakrLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        dismissKey()
        
        signUpButton.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let textFieldColor = UIColor.init(named: "loginAndSignUpTextFieldsBackground")

        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = textFieldColor
        usernameTextField.backgroundColor = textFieldColor
        passwordTextField.backgroundColor = textFieldColor
        confirmPasswordTextField.backgroundColor = textFieldColor
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        var email = ""
        let username = usernameTextField.text!
        var password = ""
        let confirmPassword = confirmPasswordTextField.text!
        
        if emailTextField.text != "" {
            if isValidEmail(emailStr: emailTextField.text!) {
                email = emailTextField.text!
            } else {
                displayAlert(withTitle: "Error", withMessage: "Please enter a valid email")
                return
            }
        } else {
            displayAlert(withTitle: "Error", withMessage: "Please enter an email adress")
            return
        }
        
        if username == "" {
            displayAlert(withTitle: "Error", withMessage: "Please enter a username")
            return
        }
        
        if passwordTextField.text != "" {
            if isValidPassword(passwordStr: passwordTextField.text!) {
                password = passwordTextField.text!
            } else {
                displayAlert(withTitle: "Error", withMessage: "Your password must be at least 8 characters long and have one number and one uppercase letter")
                return
            }
        } else {
            displayAlert(withTitle: "Error", withMessage: "Please enter a password")
            return
        }
        
        
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { (snapshot, error) in
                guard let userID = Auth.auth().currentUser?.uid else { return }
                guard let databaseReference = self.ref else { return }
                
                let userInfo = ["email": email,
                                "password": password,
                                "username": username]
                
                if error != nil {
                    print("=> Error: \(error!.localizedDescription)")
                    self.displayAlert(withTitle: "Error", withMessage: error!.localizedDescription)
                } else {
                    databaseReference.child("users").child(userID).setValue(userInfo)
                    
                    self.performSegue(withIdentifier: "goToOnboarding", sender: self)
                    
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                      
                    }
                }

            }
            
        } else {
            displayAlert(withTitle: "Error", withMessage: "Passwords don't match")
        }
        
        
    }
    
    
    @IBAction func goBackToLoginTapped(_ sender: UIButton) {
    }
    
    
    //MARK: Keyboard Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
                
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
            signUpButtonBottomConstraint.constant = 15
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
            signUpButtonBottomConstraint.constant = 88
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    

}
