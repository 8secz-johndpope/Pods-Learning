//
//  VerifyOTPViewController.swift
//  Sketch It
//
//  Created by kamlesh on 25/08/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class VerifyOTPViewController: UIViewController {
    
    var counter = 120
    var userName = ""
    var mobileNumber = ""
    var CCode = ""
    var VerificationID = ""
    
    private lazy var lblTitle : UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        title.textAlignment = .center
        title.textColor = .black
        title.text = "VERIFY OTP"
        return title
    }()
    
    private lazy var lblWait : UILabel = {
        let wait = UILabel()
        wait.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        wait.textAlignment = .center
        wait.numberOfLines = 0
        wait.textColor = .black
        wait.text = "Verification Code sent to your mobile number"
        return wait
    }()
    
    private lazy var lblLine : UILabel = {
        let line = UILabel()
        line.text = ""
        line.backgroundColor = .black
        return line
    }()
    
    private lazy var lblWaitForResendOTP : UILabel = {
        let wait = UILabel()
        wait.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        wait.textAlignment = .center
        wait.numberOfLines = 0
        wait.textColor = .black
        wait.text = ""
        return wait
    }()
    
    private lazy var txtFieldOTP : UITextField = {
        let OTP = UITextField()
        OTP.font = UIFont(name: "HelveticaNeue", size: 15)
        OTP.becomeFirstResponder()
        OTP.textContentType = .oneTimeCode
        OTP.textAlignment = .center
        OTP.textColor = .black
        OTP.attributedPlaceholder = NSAttributedString(string: "Enter OTP Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return OTP
    }()
    
    private lazy var btnResendOTP : UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("RESEND OTP", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        button.addTarget(self, action: #selector(btnResendOTPTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var btnContinue : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        button.addTarget(self, action: #selector(btnContinueTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.style = .gray
        loader.color = .gray
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Adding Subviews to the Superview
        view.addSubview(lblTitle)
        view.addSubview(lblWait)
        view.addSubview(txtFieldOTP)
        view.addSubview(lblLine)
        view.addSubview(btnResendOTP)
        view.addSubview(lblWaitForResendOTP)
        view.addSubview(btnContinue)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        AutoLayoutForAllViews()
        
        self.lblWaitForResendOTP.isHidden = false
        self.btnResendOTP.isUserInteractionEnabled = false
        
        
        //MARK: Timer for reactivating the RESEND OTP Button
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.counter > 0 {
                self.lblWaitForResendOTP.text = "Resend OTP will Activate after \(self.counter)s"
                self.counter -= 1
            } else {
                Timer.invalidate()
                self.lblWaitForResendOTP.isHidden = true
                self.btnResendOTP.backgroundColor = .white
                self.btnResendOTP.isUserInteractionEnabled = true
            }
        }
        
    }
    
    private func AutoLayoutForAllViews() {
        
        // For Title(VERIFY OTP) Logo
        lblTitle.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(20)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view).offset(-200)
            make.height.equalTo(25)
        }
        
        // For Label Verify Otp
        lblWait.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(20)
            make.height.greaterThanOrEqualTo(20)
            make.top.equalTo(lblTitle.snp.bottom).offset(80)
        }
        
        // For Verify OTP Input Field
        txtFieldOTP.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(35)
            make.top.equalTo(lblWait.snp.bottom).offset(10)
        }
        
        // For input field underline
        lblLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(1)
            make.top.equalTo(txtFieldOTP.snp.bottom).offset(5)
        }
        
        // For Button Resend OTP
        btnResendOTP.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(45)
            make.width.equalTo(150)
            make.top.equalTo(lblLine.snp.bottom).offset(30)
        }
        
        lblWaitForResendOTP.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(40)
            make.centerX.equalTo(view)
            make.top.equalTo(btnResendOTP.snp.bottom).offset(5)
        }
        
        // For Button Continue OTP
        btnContinue.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(30)
            make.height.equalTo(45)
            make.top.equalTo(lblWaitForResendOTP.snp.bottom).offset(50)
        }
        
        // For Loader
        activityIndicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalTo(view)
        }
        
    }
    
    //MARK: Resend OTP Button Settings
    @objc func btnResendOTPTapped() {
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        PhoneAuthProvider.provider().verifyPhoneNumber("\(CCode+mobileNumber)", uiDelegate: nil) { (verificationID, err) in
            if err != nil {
                let alert = UIAlertController(title: "Error in sending OTP", message: "\(err!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }else{
                self.VerificationID = verificationID!
                self.lblWaitForResendOTP.isHidden = false
                self.btnResendOTP.backgroundColor = .lightGray
                self.btnResendOTP.isUserInteractionEnabled = false
                self.counter = 120
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if self.counter > 0 {
                        self.lblWaitForResendOTP.text = "Resend OTP will Activate after \(self.counter)s"
                        self.counter -= 1
                    } else {
                        Timer.invalidate()
                        self.lblWaitForResendOTP.isHidden = true
                        self.btnResendOTP.backgroundColor = .white
                        self.btnResendOTP.isUserInteractionEnabled = true
                    }
                }
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    
    //MARK: Verifying OTP and Adding the user record to FireStore DB
    @objc func btnContinueTapped() {
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        if txtFieldOTP.text?.isEmpty == true {
        let alert = UIAlertController(title: "", message: "Please enter OTP", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        }else{
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: VerificationID, verificationCode: txtFieldOTP.text!)
            
            Auth.auth().signIn(with: credential) { (result, err) in
                
                if err != nil {
                    let alert = UIAlertController(title: "Failed to login", message: "\(err!.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }else{
                    let userId = Auth.auth().currentUser?.uid
                    
                    let value = ["userName" : self.userName, "mobileNumber" : self.mobileNumber]
                    
                    globalConstants.firestoreRef.collection("userDetails").document("details").setData(value)
                    
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.set("\(self.userName)", forKey: "userName")
                    UserDefaults.standard.set("\(self.mobileNumber)", forKey: "mobileNumber")
                    UserDefaults.standard.set(userId!, forKey: "userId")
                    
                    
                    let nextViewController = HomeViewController()
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
            }
            
        }
        
    }
}
