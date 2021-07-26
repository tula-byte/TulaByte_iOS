//
//  AudienceViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit

class AudienceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keyboard notification listeners
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowing), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHiding), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dismissKeyboard()
    }
    
    
    
    //outlets
    @IBOutlet weak var outEmailTextField: TulaTextField!
    @IBOutlet weak var outSignUpButton: TulaButton!
    
    //actions
    @IBAction func btnSignUp(_ sender: Any) {
        if (defaults.value(forKey: nwConnectedKey) as! Bool) == true {
            dismissKeyboard()
            let url = URL(string: "https://api.buttondown.email/v1/subscribers")!
            var request = URLRequest(url: url)
            
            request.setValue("Token 4cbc3002-2f3a-43d2-b382-65084192a049", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["email": outEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
            let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            request.httpMethod = "POST"
            request.httpBody = bodyData
            
            present(showLoadingIndicator(), animated: true, completion: nil)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    if let error = error {
                        self.displayErrorAlert(type: 0)
                        NSLog("TBT ERROR: Url session didn't work: \(error)")
                    } else if let response = response as? HTTPURLResponse {
                        if response.statusCode == 201 {
                            self.displaySuccessAlert(type: 0)
                        } else if response.statusCode == 400 {
                            let answer = String(data: data!, encoding: .utf8)
                            NSLog("TBT EMAIL: \(String(describing: answer))")
                            let pattern = "*That email address * is already subscribed*"
                            
                            if self.wildcard(answer!, pattern: pattern) {
                                self.displaySuccessAlert(type: 1)
                            } else {
                                self.displayErrorAlert(type: 1)
                            }
                        }
                    } else {
                        self.displayErrorAlert(type: 0)
                    }
                }
            }.resume()
        } else {
            dismiss(animated: true) {
                self.displayErrorAlert(type: 2)
            }
        }
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        defaults.setValue(true, forKey: "completedOnboarding")
        performSegue(withIdentifier: "onboardingComplete", sender: self)
    }
    
    
    @IBAction func txtEmail(_ sender: Any) {
        if outEmailTextField.text != nil {
            outSignUpButton.isEnabled = true
        } else {
            outSignUpButton.isEnabled = false
        }
    }
    
    @IBAction func txtEmailReturnPressed(_ sender: Any) {
        dismissKeyboard()
        btnSignUp(self)
    }
    
    
    //functions
    @objc func keyboardShowing(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardHiding(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func displayErrorAlert(type: Int) {
        var title = ""
        var message = ""
        
        switch type {
        case 0:
            title = "Error"
            message = "Something went wrong. Please try again."
        case 1:
            title = "Invalid Email"
            message = "The input email is invalid. Please try another email"
        case 2:
            title = "No Internet!"
            message = "You don't have a valid internet connection. Subscribing to the newsletter is not possible without an internet connection."
        default:
            break
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    func displaySuccessAlert(type: Int) {
        var title = ""
        var message = ""
        
        switch type {
        case 0:
            title = "Subscribed Succesfully"
            message = "You were succesfully subscribed to the TulaByte newsletter."
        case 1:
            title = "Already Subscribed"
            message = "You are already subscribed to the newsletter!"
        default:
            break
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            defaults.setValue(true, forKey: "completedOnboarding")
            self.performSegue(withIdentifier: "onboardingComplete", sender: self)
        }))
        self.present(ac, animated: true, completion: nil)
    }
    
    func wildcard(_ string: String, pattern: String) -> Bool {
        let pred = NSPredicate(format: "self LIKE %@", pattern)
        return !NSArray(object: string).filtered(using: pred).isEmpty
    }
}
