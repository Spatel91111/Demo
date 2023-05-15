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

class ChangePasswordViewController: ParentVC {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var confirmPasswordTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var confirmPasswordController: MDCTextInputControllerUnderline!
    var passwordController: MDCTextInputControllerUnderline!
   
    var viewModel = SignInViewModel()
    weak var delegate: LoginPop?
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    let defaults = UserDefaults.standard
    var strUser = ""
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        lblTitle.text = "Change Password".localized
        self.navigationController?.navigationBar.tintColor = AppStaticColors.accentColor
       
        btnLogin.setTitle("Change Password".localized, for: .normal)
       
        self.confirmPasswordTextField.delegate = self
        self.passwordTextField.delegate = self
        
        DispatchQueue.main.async { [self] in
            self.confirmPasswordController = MDCTextInputControllerUnderline(textInput: self.confirmPasswordTextField)
            self.passwordController = MDCTextInputControllerUnderline(textInput: self.passwordTextField)
            let allTextFieldController: [MDCTextInputControllerUnderline] = [self.confirmPasswordController, self.passwordController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.blackColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderNormalColor = AppStaticColors.profileTabColor
                textFieldController.inlinePlaceholderColor = AppStaticColors.labelColor
                textFieldController.inlinePlaceholderFont = UIFont.mySystemFont(ofSize: 13.0)
                textFieldController.textInputFont = UIFont.mySemiboldSystemFont(ofSize: 16.0)
                textFieldController.underlineHeightActive = 1
            }
            
            self.passwordController.placeholderText = "New Password".localized + "*"
            self.confirmPasswordController.placeholderText = "Confirm New Password".localized + "*"

            backBtn.setImage(UIImage(named: "backArrow")?.flipImage(), for: .normal)
            
            
            if Defaults.language == "ar" {
                confirmPasswordTextField.semanticContentAttribute = .forceRightToLeft
                passwordTextField.semanticContentAttribute = .forceRightToLeft
                confirmPasswordTextField.textAlignment = .right
                passwordTextField.textAlignment = .right
            } else {
                confirmPasswordTextField.semanticContentAttribute = .forceLeftToRight
                passwordTextField.semanticContentAttribute = .forceLeftToRight
                confirmPasswordTextField.textAlignment = .left
                passwordTextField.textAlignment = .left
            }
            
//            let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
//                    backBtn.image = img?.flipImage()
        
        }
    }
    
       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    
    override func viewWillDisappear(_ animated: Bool) {
//        if isFormSocailLoginScreen == true {
//            self.navigationController?.navigationBar.isHidden =  true
//        }
        
    }
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        
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
        
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter Confirm Password".localized)
            return
        }
        
        guard password == confirmPassword else {
            self.showWarningSnackBar(msg: "Password and Confirm Password dose not match".localized)
            return
        }
        
        
        var dict = [String: Any]()
        dict["password"] = self.passwordTextField.text ?? ""
        dict["username"] = self.strUser
        callRequest(dict: dict, apiCall: .changePassword)
    }
    // MARK: - Api act
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .changePassword {
                    
                    for controller in (self?.navigationController!.viewControllers)! as Array {
                            if controller.isKind(of: NewLoginViewController.self) {
                                _ =  self?.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                }
            } else {
            }
        }
    }
}

extension ChangePasswordViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            if textField == passwordTextField || textField == confirmPasswordTextField {
                if (string == " ") {
                    return false
                }
            }
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
