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
import BetterSegmentedControl

class ForgotPasswordViewController: ParentVC {
    
    @IBOutlet weak var control1: BetterSegmentedControl!
    
    
    @IBOutlet weak var mobileTextField: MDCTextField!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var btnSendOtp: UIButton!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var lblTxtHint: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    var viewModel = SignInViewModel()
    
    var emailController: MDCTextInputControllerUnderline!
    var mobileController: MDCTextInputControllerUnderline!

    var isFormSocailLoginScreen = false
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        lblTitle.text = "Forgot password".localized
        lblMsg.text = "I want to reset password using".localized
        self.navigationController?.navigationBar.tintColor = AppStaticColors.accentColor
        btnSendOtp.setTitle("Send OTP".localized, for: .normal)
        btnLogin.setTitle("Send OTP".localized, for: .normal)
        
        lblTxtHint.text = "Mobile No. With Country Code i.e 919898989898".localized + "Mobile Noo".localized
        
        control1.segments = LabelSegment.segments(withTitles: ["Mobile".localized, "Email".localized], numberOfLines: 1, normalBackgroundColor: nil, normalFont: UIFont.mySystemFont(ofSize: 16.0), normalTextColor: AppStaticColors.profileTabColor, selectedBackgroundColor: AppStaticColors.accentColor, selectedFont: UIFont.mySystemFont(ofSize: 16.0), selectedTextColor: UIColor.white)
        
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        backBtn.setImage(UIImage(named: "backArrow")?.flipImage(), for: .normal)
        
//        let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
//                backBtn.image = img?.flipImage()
        
        DispatchQueue.main.async { [self] in
            self.emailController = MDCTextInputControllerUnderline(textInput: self.emailTextField)
            
            self.mobileController = MDCTextInputControllerUnderline(textInput: self.mobileTextField)
            let allTextFieldController: [MDCTextInputControllerUnderline] = [self.emailController,self.mobileController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.blackColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderNormalColor = AppStaticColors.profileTabColor
                textFieldController.inlinePlaceholderColor = AppStaticColors.labelColor
                textFieldController.inlinePlaceholderFont = UIFont.mySystemFont(ofSize: 13.0)
                textFieldController.textInputFont = UIFont.mySemiboldSystemFont(ofSize: 16.0)
                textFieldController.underlineHeightActive = 1
            }
            
            self.emailController.placeholderText = "Email Address*".localized
            self.mobileController.placeholderText = "Mobile No".localized
           
            control1.addTarget(self,action: #selector(self.navigationSegmentedControlValueChanged(_:)),
                                                 for: .valueChanged)
            
            if Defaults.language == "ar" {
                emailTextField.semanticContentAttribute = .forceRightToLeft
                mobileTextField.semanticContentAttribute = .forceRightToLeft
                emailTextField.textAlignment = .right
                mobileTextField.textAlignment = .right
            } else {
                emailTextField.semanticContentAttribute = .forceLeftToRight
                mobileTextField.semanticContentAttribute = .forceLeftToRight
                emailTextField.textAlignment = .left
                mobileTextField.textAlignment = .left
            }
            
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
    
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        guard let emailId = emailTextField.text, emailId.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter Email id".localized)
            return
        }
        
        guard !NetworkManager.sharedInstance.checkValidEmail(data: emailId) == false else {
            self.showWarningSnackBar(msg: "Please enter Valid Email Id".localized)
            return
        }
        
        var dict = [String: Any]()
        dict["username"] = emailId
        self.callRequest(dict: dict, apiCall: .forgetPassword)
    }
    
    
    @IBAction func sendOtpAction(_ sender: Any) {
        
        guard let mobileNumber = mobileTextField.text, mobileNumber.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter Mobile Number".localized)
            return
        }
        
        var dict = [String: Any]()
        dict["username"] = mobileNumber
        self.callRequest(dict: dict, apiCall: .forgetPassword)
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        
    }
  
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            viewOtp.isHidden = false
            viewPassword.isHidden = true
        } else {
            viewOtp.isHidden = true
            viewPassword.isHidden = false
        }
    }
    
    // MARK: - Api act
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .sendOTP {
                    
                } else if apiCall == .createAccount {
                    self?.navigationController?.popViewController(animated: true)
                } else if apiCall == .forgetPassword {
                    if(self?.viewOtp.isHidden == false){
                        let customerLoginVC = OPTViewController.instantiate(fromAppStoryboard: .customer)
                        customerLoginVC.strMobileNo = (self?.lblCountryCode.text)! + (self?.mobileTextField.text)!
                        customerLoginVC.strNumber = (self?.mobileTextField.text)!
                        self?.navigationController?.pushViewController(customerLoginVC, animated: true)
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    
                }
                
            } else {
            }
        }
    }
}

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
