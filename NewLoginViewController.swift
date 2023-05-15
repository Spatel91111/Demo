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

class NewLoginViewController: ParentVC {
    
    
    
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var btnSignEmail: UIButton!
    
    @IBOutlet weak var lblTxtHint: UILabel!

    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var emailController: MDCTextInputControllerUnderline!
    var passwordController: MDCTextInputControllerUnderline!
   
    var isFormSocailLoginScreen = false
    
    var viewModel = SignInViewModel()
    weak var delegate: LoginPop?
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    let defaults = UserDefaults.standard
    var isFromOtherPage = false
    var isFromHome = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = "Log in with".localized
        self.navigationController?.navigationBar.tintColor = AppStaticColors.accentColor
       
        btnLogin.setTitle("Log in".localized, for: .normal)
        btnForgotPassword.setTitle("Forgot password?".localized, for: .normal)
        lblTxtHint.text = "Mobile No. With Country Code i.e 919898989898".localized + "Mobile Noo".localized
        
//        let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
        //backBtn.image =
            backBtn.setImage(UIImage(named: "backArrow")?.flipImage(), for: .normal)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
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
        
        DispatchQueue.main.async { [self] in
            self.emailController = MDCTextInputControllerUnderline(textInput: self.emailTextField)
            self.passwordController = MDCTextInputControllerUnderline(textInput: self.passwordTextField)
            let allTextFieldController: [MDCTextInputControllerUnderline] = [self.emailController, self.passwordController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.blackColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderNormalColor = AppStaticColors.profileTabColor
                textFieldController.inlinePlaceholderColor = AppStaticColors.labelColor
                textFieldController.inlinePlaceholderFont = UIFont.mySystemFont(ofSize: 13.0)
                textFieldController.textInputFont = UIFont.mySemiboldSystemFont(ofSize: 16.0)
                textFieldController.underlineHeightActive = 1
            }
            
            self.emailController.placeholderText = "Email/mobile number".localized
            self.passwordController.placeholderText = "Password".localized
            
           
            let strNumber = "Don't have an Account?".localized + " " + "Sign Up".localized
            let changeText = "Sign Up".localized
            let chnagesText = "Don't have an Account?".localized
            let range = NSString(string: strNumber).range(of: changeText, options: String.CompareOptions.caseInsensitive)
            let range1 = NSString(string: strNumber).range(of: chnagesText, options: String.CompareOptions.caseInsensitive)
            let attribute = NSMutableAttributedString.init(string: strNumber)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppStaticColors.accentColor, range: range)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.mySemiboldSystemFont(ofSize: 14.0), range: range)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 124.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0), range: range1)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.mySystemFont(ofSize: 15.0), range: range1)
            
            self.btnSignEmail.setAttributedTitle(attribute, for: .normal)
        
        }
    }
    
       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isFromHome {
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        
    }
    
    override func actionBackTap(_ sender: UIBarButtonItem) {
        
        if delegate != nil {
            self.delegate?.loginPop()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
            
       
    }
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let customerLoginVC = ForgotPasswordViewController.instantiate(fromAppStoryboard: .customer)

        self.navigationController?.pushViewController(customerLoginVC, animated: true)
    }
    
   
    @IBAction func btnCreateAccount(_ sender: Any) {
        let customerLoginVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        customerLoginVC.delegate = self
        self.navigationController?.pushViewController(customerLoginVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        guard let emailId = emailTextField.text, emailId.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter Email Id or Mobile Number".localized)
           // emailTextField.shake()
            return
        }
        
        if emailId.contains("@") {
            if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
                self.showWarningSnackBar(msg: "Please enter Valid Email Id".localized)
               // emailTextField.shake()
                return
            }
        }
        
        guard let password = passwordTextField.text, password.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter Password".localized)
            //passwordTextField.shake()
            return
        }
        
        guard password.count > 3 else {
            self.showWarningSnackBar(msg: "Please enter Valid Password, password Length is 4 to 16".localized)
           // passwordTextField.shake()
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
                    
                    if self?.isFromOtherPage == false {
                        if let signInHandler = self?.signInHandler {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                            signInHandler()
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                        }
                    
                        self?.navigationController?.popViewController(animated: false)
                        
                        if self?.delegate != nil {
                            self?.delegate?.loginPop()
                        }
                    } else {
                        self?.delegate?.loginPop()
                    }
                    
                    
                }
            } else {
            }
        }
    }
}
extension NewLoginViewController: LoginPop {
    func loginPop() {

    }
}
extension NewLoginViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
