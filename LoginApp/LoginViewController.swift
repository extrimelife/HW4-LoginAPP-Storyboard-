//
//  ViewController.swift
//  LoginApp
//
//  Created by roman Khilchenko on 11.08.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgetUserNameButton: UIButton!
    @IBOutlet var forgetPasswordButton: UIButton!
    
    private let login = "User"
    private let password = "Password"
    
    
    //MARK: - Переопределенные методы
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
        registerForKeyboardNotifications()
    }
    deinit {
        removeKeyboardNotifications()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let greetingVc = segue.destination as? GreetingViewController else { return }
        greetingVc.userLabel = loginTextField.text
        greetingVc.modalPresentationStyle = .overCurrentContext
    }
    
    //MARK: - IBAction UIButton
    @IBAction func loginButtonAction() {
        guard loginTextField.text == login && passwordTextField.text == password else {
            showAlert(title: "Invalid login or password", message: "Please enter correct login and password")
            return
        }
    }
    
    
    @IBAction func forgotUserNameAction() {
        showAlert(title: "Oops!", message: "Your name is \(login) \u{1F609}")
    }
    
    
    @IBAction func forgotPasswordAction() {
        showAlert(title: "Oops!", message: "Your password is \(password) \u{1F609}")
    }
    
    
    @IBAction func unwindSeque(_ seque: UIStoryboardSegue) {
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Приватные методы
    private func setupTextField() {
        let textFields = [loginTextField, passwordTextField]
        let textFieldPlaceholder = ["User Name", "Password"]
        for (index, textField) in textFields.enumerated() {
            guard let textField = textField else { return }
            textField.placeholder = textFieldPlaceholder[index]
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 16)
            textField.clearButtonMode = .whileEditing
        }
    }
    
    private func setupButton() {
        let buttons = [loginButton, forgetUserNameButton, forgetPasswordButton]
        let buttonNames = ["Log In", "Forgot User Name?", "Forgot Password?"]
        for (index, button) in buttons.enumerated() {
            guard let button = button else { return }
            button.setTitle(buttonNames[index], for: .normal)
            
        }
    }
}


//MARK: - extension UIAlertController
extension LoginViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordTextField.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: - extention для клавиатуры,чтобы не перекрывала контент
extension LoginViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow(_ notification: NSNotification) {
        let kbFrameSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        view.bounds.origin = CGPoint(x: 0, y: kbFrameSize.size.width / 12)
    }
    
    @objc private func kbWillHide() {
        view.bounds.origin = CGPoint.zero
    }
}
