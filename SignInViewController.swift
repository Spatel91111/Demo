//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: LoginViewController.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
//import MaterialComponents.MaterialTextFields_TypographyThemer
import Alamofire

class SignInViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var emailController: MDCTextInputControllerOutlined!
    var passwordController: MDCTextInputControllerOutlined!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    var userEmail: String = ""
    let button = UIButton(type: .custom)
    var viewModel = SignInViewModel()
    weak var delegate: LoginPop?
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    var touchID:TouchID!
    var NotAgainCallTouchId :Bool = false

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
//        backBtn.image = img?.flipImage()
        backBtn.setImage(UIImage(named: "backArrow")?.flipImage(), for: .normal)
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                signView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                signInButton.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                signInButton.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                 createAccountButton.backgroundColor = AppStaticColors.defaultColor
                createAccountButton.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
            } else {
                signView.backgroundColor = AppStaticColors.buttonBackGroundColor
                signInButton.backgroundColor = AppStaticColors.buttonBackGroundColor
                signInButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                 createAccountButton.backgroundColor = AppStaticColors.defaultColor
                createAccountButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            }
        } else {
            signView.backgroundColor = AppStaticColors.buttonBackGroundColor
            signInButton.backgroundColor = AppStaticColors.buttonBackGroundColor
            signInButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
             createAccountButton.backgroundColor = AppStaticColors.defaultColor
            createAccountButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
        }

        #if MARKETPLACE  || BTOB
        emailTextField.text = ""
        passwordTextField.text = ""
        #endif
        #if HYPERLOCAL
        emailTextField.text = ""
        passwordTextField.text = ""
        #endif
        forgotPasswordBtn.titleLabel?.textColor = UIColor.lightGray
        self.navigationItem.title = "Sign In with Email".localized
        signInButton.setTitle("Sign In".localized.uppercased(), for: .normal)
        createAccountButton.setTitle("Create an Account".localized.uppercased(), for: .normal)
        forgotPasswordBtn.setTitle("Forgot password?".localized, for: .normal)
        self.touchID = TouchID(view:self)

        DispatchQueue.main.async {
            self.emailController = MDCTextInputControllerOutlined(textInput: self.emailTextField)
            self.passwordController = MDCTextInputControllerOutlined(textInput: self.passwordTextField)
            let allTextFieldController: [MDCTextInputControllerOutlined] = [self.emailController, self.passwordController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
            }
            self.emailController.placeholderText = "Email Address".localized
            self.passwordController.placeholderText = "Password".localized
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                     self.emailTextField.textColor = UIColor.white
                  self.passwordTextField.textColor = UIColor.white

                     self.emailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                     self.emailController.inlinePlaceholderColor = AppStaticColors.accentColor
                  self.passwordController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                  self.passwordController.inlinePlaceholderColor = AppStaticColors.accentColor
                } else {
                        self.emailTextField.textColor = AppStaticColors.accentColor
                                      self.passwordTextField.textColor = AppStaticColors.accentColor
                }
            } else {
                 self.emailTextField.textColor = AppStaticColors.accentColor
                                                        self.passwordTextField.textColor = AppStaticColors.accentColor
            }
        }
        // MARK: - code for hide show btn
        button.setImage(UIImage(named: "closePassword"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)

        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        if let email = email {
            emailTextField.text = email
            passwordTextField.text = ""
        }
        if #available(iOS 12.0, *) {
            emailTextField.textContentType = .username
            passwordTextField.textContentType = .password
        }

        if Defaults.language == "ar" {
            emailTextField.semanticContentAttribute = .forceRightToLeft
            passwordTextField.semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
        } else {
            emailTextField.semanticContentAttribute = .forceLeftToRight
            passwordTextField.semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
        }

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
                   if self.traitCollection.userInterfaceStyle == .dark {
                       emailTextField.textColor = UIColor.white
                    passwordTextField.textColor = UIColor.white
                    if emailController != nil {
                       emailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                       emailController.inlinePlaceholderColor = AppStaticColors.accentColor
                    passwordController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    passwordController.inlinePlaceholderColor = AppStaticColors.accentColor
                    }
                   } else {
                          emailTextField.textColor = AppStaticColors.accentColor
                                        passwordTextField.textColor = AppStaticColors.accentColor
                   }
               } else {
                   emailTextField.textColor = AppStaticColors.accentColor
                                                          passwordTextField.textColor = AppStaticColors.accentColor
               }
    }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            button.setImage(UIImage(named: "closePassword"), for: .normal)
        } else {
            button.setImage(UIImage(named: "seePassword"), for: .normal)
        }
    }
    
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let AC = UIAlertController(title: "enteremail".localized, message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = "enteremail".localized
            textField.text = self.emailTextField.text
        }
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            guard let emailId = textField.text, emailId.count>1 else {
                self.showWarningSnackBar(msg: "pleasefillemailid".localized)
                return
            }
            if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
                self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
                return
            }
            var dict = [String: Any]()
            dict["username"] = emailId
            self.callRequest(dict: dict, apiCall: .forgetPassword)
        })
        let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Defaults.touchFlag == "1"{
            touchID.askForLocalAuthentication(message: "loginthrough".localized) { [weak self] in
                if $0 {
                    self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                        if sucess{
                            self?.emailTextField.text = Defaults.touchEmail ?? ""
                            self?.passwordTextField.text = Defaults.touchPassword ?? ""
                            self?.NotAgainCallTouchId = true
                            var dict = [String: Any]()
                            dict["username"] = self?.emailTextField.text ?? ""
                            dict["password"] = self?.passwordTextField.text ?? ""
                            dict["token"] = Defaults.deviceToken
                            self?.callRequest(dict: dict, apiCall: .login)
                        }
                    })
                }
            }
        }
    }
    func calltouch(){
        if Defaults.touchFlag != nil && self.NotAgainCallTouchId == false {
            if Defaults.touchFlag == "0" {
                touchID.askForLocalAuthentication(message: "wouldyouliketoconnectappwith".localized) { [weak self] in
                    if $0 {
                        self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                Defaults.touchFlag = "1"
                                Defaults.touchEmail = self?.emailTextField.text ?? ""
                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
                                self?.dismiss(animated: true, completion: {
                                    if let signInHandler = self?.signInHandler {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                        signInHandler()
                                    } else {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                                    }
                                    
                                    self?.delegate?.loginPop()
                                })
                            } else {
                                Defaults.touchFlag = "0"
                                self?.dismiss(animated: true, completion: {
                                    if let signInHandler = self?.signInHandler {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                        signInHandler()
                                    } else {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                                    }
                                    
                                    self?.delegate?.loginPop()
                                })
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
                        self?.dismiss(animated: true, completion: {
                            if let signInHandler = self?.signInHandler {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                signInHandler()
                            } else {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                            }
                            
                            self?.delegate?.loginPop()
                        })
                    }
                }
            } else if Defaults.touchFlag == "1" {
                touchID.askForLocalAuthentication(message: "wouldyouliketoreset".localized) { [weak self] in
                    if $0 {
                        self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                Defaults.touchFlag = "1"
                                Defaults.touchEmail = self?.emailTextField.text ?? ""
                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
                                self?.dismiss(animated: true, completion: {
                                    if let signInHandler = self?.signInHandler {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                        signInHandler()
                                    } else {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                                    }
                                    
                                    self?.delegate?.loginPop()
                                })
                            }else{
                                Defaults.touchFlag = "0"
                                self?.dismiss(animated: true, completion: {
                                    if let signInHandler = self?.signInHandler {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                        signInHandler()
                                    } else {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                                    }
                                    
                                    self?.delegate?.loginPop()
                                })
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
                        self?.dismiss(animated: true, completion: {
                            if let signInHandler = self?.signInHandler {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                                signInHandler()
                            } else {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                            }
                            
                            self?.delegate?.loginPop()
                        })
                    }
                }
            } else {
                self.delegate?.loginPop()
            }
        } else {
            self.dismiss(animated: true, completion: {
                if let signInHandler = self.signInHandler {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                    signInHandler()
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                }
                
                self.delegate?.loginPop()
            })
        }
    }
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        guard let emailId = emailTextField.text, emailId.count != 0 else {
            self.showWarningSnackBar(msg: "enteremail".localized)
            emailTextField.shake()
            return
        }
        
        if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
            self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
            emailTextField.shake()
            return
        }
        
        guard let password = passwordTextField.text, password.count != 0 else {
            self.showWarningSnackBar(msg: "enterpassword".localized)
            passwordTextField.shake()
            return
        }
        var dict = [String: Any]()
        dict["username"] = self.emailTextField.text ?? ""
        dict["password"] = self.passwordTextField.text ?? ""
        dict["token"] = Defaults.deviceToken
        callRequest(dict: dict, apiCall: .login)
    }
    // MARK: - Api act
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .login {
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Login Successfully".localized)
                    self?.calltouch()
                }
            } else {
            }
        }
    }
    
    // MARK: - close btn act
    @IBAction func closeAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAnAccountAct(_ sender: Any) {
        if parentController == "signUp" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
            customerCreateAccountVC.parentController = "signIn"
            customerCreateAccountVC.delegate = delegate
            customerCreateAccountVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
        }
        
        //        self.present(nav, animated: true, completion: nil)
        //        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        //        self.present(nav, animated: true, completion: nil)
    }
}
