//
//  LoginViewController.swift
//  Yaker
//
//  Created by Francisco Barreto on 29/10/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var yakrLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("=> Current User: \(String(describing: Auth.auth().currentUser))")
        
        Auth.auth().addStateDidChangeListener { auth, user in
          if let user = user {
            // User is signed in.
            self.performSegue(withIdentifier: "goToFeed", sender: nil)
          }
        }

        
        dismissKey()
        
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let textFieldColor = UIColor.init(named: "loginAndSignUpTextFieldsBackground")

        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = textFieldColor
        passwordTextField.backgroundColor = textFieldColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)])
        
        emailTextField.textContentType = .oneTimeCode
        passwordTextField.textContentType = .oneTimeCode
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        var email = ""
        var password = ""
        
        if emailTextField.text != "" {
            if isValidEmail(emailStr: emailTextField.text!) {
                email = emailTextField.text!
            } else {
                displayAlert(withTitle: "Error", withMessage: "Please enter a valid email")
                return
            }
        } else {
            displayAlert(withTitle: "Error", withMessage: "Please enter your email")
            return
        }
        
        if passwordTextField.text != "" {
            if isValidPassword(passwordStr: passwordTextField.text!) {
                password = passwordTextField.text!
            } else {
                displayAlert(withTitle: "Error", withMessage: "Please enter a valid password")
                return
            }
        } else {
            displayAlert(withTitle: "Error", withMessage: "Please enter your password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("=> Error: \(error!.localizedDescription)")
                strongSelf.displayAlert(withTitle: "Error", withMessage: error!.localizedDescription)
                return
            } else {                
                strongSelf.performSegue(withIdentifier: "goToFeed", sender: nil)
            }
            
        }
        
    }
    
    //MARK: Keyboard Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
                
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
            loginButtonBottomConstraint.constant = 70
            
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
            loginButtonBottomConstraint.constant = 188
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    

}
