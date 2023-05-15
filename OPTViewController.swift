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

class OPTViewController: ParentVC {

    @IBOutlet weak var mobileTextField: MDCTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var strMobileNo = ""
    var strNumber = ""
    var paramDict = [String: Any]()
    var perameterDict = [String: Any]()
    var mobileController: MDCTextInputControllerUnderline!
    var isFromSingup = false
    var viewModel: CreateAnAccountViewModel!
    weak var delegate: LoginPop?
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
//                backBtn.image = img?.flipImage()
        
        backBtn.setImage(UIImage(named: "backArrow")?.flipImage(), for: .normal)
        
        viewModel = CreateAnAccountViewModel()
        
        lblTitle.text = "Verify OTP".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        btnResend.setTitle("Resend OTP".localized, for: .normal)
        
        DispatchQueue.main.async { [self] in
            
            self.mobileController = MDCTextInputControllerUnderline(textInput: self.mobileTextField)
            let allTextFieldController: [MDCTextInputControllerUnderline] = [self.mobileController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.blackColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderNormalColor = AppStaticColors.profileTabColor
                textFieldController.inlinePlaceholderColor = AppStaticColors.labelColor
                textFieldController.inlinePlaceholderFont = UIFont.mySystemFont(ofSize: 13.0)
                textFieldController.textInputFont = UIFont.mySemiboldSystemFont(ofSize: 16.0)
                textFieldController.underlineHeightActive = 1
            }
            
            
            self.mobileController.placeholderText = "Enter OTP".localized
           
            
            //lblTxt.text =  String(format: NSLocalizedString("We have sent an OTP to your Mobile '%@'", comment: ""),strMobileNo)
            
            if Defaults.language == "ar" {
                lblTxt.text = "لقد أرسلنا رمز التحقق إلى هاتفك المحمول" + strMobileNo
               
            } else {
                lblTxt.text = "We have sent an Verification Code to your Mobile \(strMobileNo)"
            }
            
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
            self.btnSign.setAttributedTitle(attribute, for: .normal)
           
            if Defaults.language == "ar" {
                mobileTextField.semanticContentAttribute = .forceRightToLeft
                mobileTextField.textAlignment = .right
                
            } else {
                mobileTextField.semanticContentAttribute = .forceLeftToRight
                mobileTextField.textAlignment = .left
                
            }
            
        }
    }
       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    
    override func viewWillDisappear(_ animated: Bool) {
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventManager.sharedInstance.eventTrack(token: "cbt8p5", amount: 1.0, revenueCurrency: "EUR") //Event for OTP Screen
    }
    //CreateAnAccountViewController
    @IBAction func createAnAccountAct(_ sender: Any) {
//        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
//        self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
    }
    
    @IBAction func varifyOTP(_ sender: Any) {
        if isFromSingup == true {
            
            guard let mobileNumber = mobileTextField.text, mobileNumber.count != 0 else {
                self.showWarningSnackBar(msg: "Please enter Authorization Code".localized)
                return
            }
            
            paramDict["OTP"] = self.mobileTextField.text ?? ""
            viewModel.signupDictionary = paramDict
            viewModel.callingHttppApi { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                    EventManager.sharedInstance.eventTrack(token: "frxy58", amount: 1.0, revenueCurrency: "EUR") //Event for SignUp User
                    self?.loginPop()
                } else {
                }
            }
           // callRequest(dict: paramDict, apiCall: .createAccount)
        } else {
            guard let mobileNumber = mobileTextField.text, mobileNumber.count != 0 else {
                self.showWarningSnackBar(msg: "Please enter Authorization Code".localized)
                return
            }
            
            paramDict["OTP"] = self.mobileTextField.text ?? ""
            paramDict["mobile"] = self.strNumber
            
            viewModel.verifyDic = paramDict
            viewModel.callingHttpVerifyCodeApi { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                    let customerCreateAccountVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .customer)
                    customerCreateAccountVC.strUser = self!.strNumber
                    self?.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
                } else {
                }
            }
//            perameterDict["OTP"] = self.mobileTextField.text ?? ""
//            perameterDict["username"] = strNumber
//            callRequest(dict: perameterDict, apiCall: .verifyOTP)
            
            
        }
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        if isFromSingup == true {
            var dict = [String: Any]()
            dict["mobilenumber"] = strNumber
            dict["isforgot"] = false
            //callRequest(dict: dict, apiCall: .resendOTP)
            viewModel.verifyDic = dict
            viewModel.callingHttpResendCodeApi(completion: { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                } else {
                }
            })
        } else {
            var dict = [String: Any]()
            dict["isforgot"] = true
            dict["mobilenumber"] = strNumber
            //callRequest(dict: dict, apiCall: .resendOTP)
            
            viewModel.verifyDic = dict
            viewModel.callingHttpResendCodeApi(completion: { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                } else {
                }
            })
        }
    }

    
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
            } else {
            }
        }
    }
    
}

extension OPTViewController : LoginPop {
    func loginPop() {
        self.navigationController?.popViewController(animated: false)
        if isFromSingup == true {
            self.delegate?.loginPop()
        }
    }
}
