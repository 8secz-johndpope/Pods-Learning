//
//  ViewController.swift
//  Pods Learning
//
//  Created by kamlesh on 03/09/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class SignInViewController: UIViewController {

    private lazy var lblTitle : UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        title.textAlignment = .center
        title.textColor = .black
        title.text = "LOGIN"
        return title
    }()
    
    private lazy var lblUsername : UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        name.textAlignment = .left
        name.textColor = .black
        name.text = "Username"
        return name
    }()
    
    private lazy var lblMobileNumber : UILabel = {
        let phone = UILabel()
        phone.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        phone.textAlignment = .left
        phone.textColor = .black
        phone.text = "Mobile Number"
        return phone
    }()
    
    private lazy var lblLine1 : UILabel = {
        let line1 = UILabel()
        line1.text = ""
        line1.backgroundColor = .black
        return line1
    }()
    
    private lazy var lblLine2 : UILabel = {
        let line2 = UILabel()
        line2.text = ""
        line2.backgroundColor = .black
        return line2
    }()
    
    private lazy var lblDivider : UILabel = {
        let div = UILabel()
        div.text = ""
        div.backgroundColor = .black
        return div
    }()
    
    private lazy var txtFieldName : UITextField = {
        let username = UITextField()
        username.font = UIFont(name: "HelveticaNeue", size: 15)
        username.becomeFirstResponder()
        username.textAlignment = .left
        username.textColor = .black
        username.attributedPlaceholder = NSAttributedString(string: "Enter your name here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return username
    }()
    
    private lazy var txtFieldCCode : UITextField = {
        let phone = UITextField()
        phone.font = UIFont(name: "HelveticaNeue", size: 15)
        phone.textAlignment = .center
        phone.textColor = .black
        phone.text = "+91"
        phone.isUserInteractionEnabled = false
        return phone
    }()
    
    private lazy var txtFieldMobileNumber : UITextField = {
        let phone = UITextField()
        phone.font = UIFont(name: "HelveticaNeue", size: 15)
        phone.textAlignment = .left
        phone.textColor = .black
        phone.keyboardType = .phonePad
        phone.attributedPlaceholder = NSAttributedString(string: "Enter Mobile Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return phone
    }()
    
    private lazy var btnVerifyMobileNumber : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Send OTP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        button.addTarget(self, action: #selector(btnSendOtpTapped), for: .touchUpInside)
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
        
        //MARK: NavigationBar Settings
        self.navigationItem.hidesBackButton = true
        
        //MARK: Adding Subviews to the Superview
        view.addSubview(lblTitle)
        view.addSubview(lblMobileNumber)
        view.addSubview(lblUsername)
        view.addSubview(lblLine2)
        view.addSubview(lblLine1)
        view.addSubview(lblDivider)
        view.addSubview(txtFieldCCode)
        view.addSubview(txtFieldName)
        view.addSubview(txtFieldMobileNumber)
        view.addSubview(btnVerifyMobileNumber)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        AutoLayoutForAllViews()
        
    }
    
     private func AutoLayoutForAllViews() {
             
             
             // For Title(LOGIN)
             lblTitle.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.centerX.equalToSuperview()
                 make.centerY.equalTo(view).offset(-200)
                 make.height.equalTo(25)
             }
             
             // For Label Username
             lblUsername.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(20)
                 make.top.equalTo(lblTitle.snp.bottom).offset(80)
             }
             
             // For Username Input Field
             txtFieldName.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(35)
                make.top.equalTo(lblUsername.snp.bottom).offset(5)
             }
             
             // For input field underline
             lblLine1.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(1)
                 make.top.equalTo(txtFieldName.snp.bottom).offset(5)
             }
             
             // For label Mobile Number
             lblMobileNumber.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(20)
                 make.top.equalTo(lblLine1.snp.bottom).offset(30)
             }
             
             // For Mobile Number Country Code
             txtFieldCCode.snp.makeConstraints { (make) in
                 make.width.equalTo(40)
                 make.height.equalTo(35)
                 make.top.equalTo(lblMobileNumber.snp.bottom).offset(5)
                 make.leading.equalTo(view).inset(20)
             }
             
             // Seperator
             lblDivider.snp.makeConstraints { (make) in
                 //make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(20)
                 make.width.equalTo(1)
                 make.top.equalTo(txtFieldCCode).offset(10)
                 make.leading.equalTo(txtFieldCCode.snp.trailing).offset(5)
             }
             
             // For Mobile Number Input Field
             txtFieldMobileNumber.snp.makeConstraints { (make) in
                 make.leading.equalTo(lblDivider.snp.trailing).offset(10)
                 make.trailing.equalTo(view.snp.trailing).inset(20)
                 make.height.equalTo(35)
                 make.top.equalTo(txtFieldCCode)
             }
             
             // For input field underline
             lblLine2.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(20)
                 make.height.equalTo(1)
                 make.top.equalTo(txtFieldMobileNumber.snp.bottom).offset(5)
             }
             
             // For Button Send OTP
             btnVerifyMobileNumber.snp.makeConstraints { (make) in
                 make.leading.trailing.equalTo(view).inset(30)
                 make.height.equalTo(45)
                 make.top.equalTo(txtFieldMobileNumber.snp.bottom).offset(80)
             }
             
             // For Loader
             activityIndicator.snp.makeConstraints { (make) in
                 make.width.height.equalTo(100)
                 make.center.equalTo(view)
             }
             
         }
         
         
         //MARK: User Signup Validation and Integration
         
         @objc func btnSendOtpTapped() {
             
             self.activityIndicator.startAnimating()
             self.view.isUserInteractionEnabled = false
             
             if txtFieldName.text?.isEmpty == true {
                 let alert = UIAlertController(title: "", message: "Please enter your name", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default))
                 self.present(alert, animated: true, completion: nil)
                 self.activityIndicator.stopAnimating()
                 self.view.isUserInteractionEnabled = true
             } else if (txtFieldMobileNumber.text?.isEmpty == true) || (txtFieldMobileNumber.text?.count != 10) {
                 let alert = UIAlertController(title: "", message: "Please enter a valid mobile number", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default))
                 self.present(alert, animated: true, completion: nil)
                 self.activityIndicator.stopAnimating()
                 self.view.isUserInteractionEnabled = true
             }else{
                 PhoneAuthProvider.provider().verifyPhoneNumber("\(txtFieldCCode.text!+txtFieldMobileNumber.text!)", uiDelegate: nil) { (verificationID, err) in
                     if err != nil {
                         let alert = UIAlertController(title: "Error in sending OTP", message: "\(err!.localizedDescription)", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Ok", style: .default))
                         self.present(alert, animated: true, completion: nil)
                         self.activityIndicator.stopAnimating()
                         self.view.isUserInteractionEnabled = true
                     }else{
                         let nextViewController = VerifyOTPViewController()
                         nextViewController.userName = self.txtFieldName.text!
                         nextViewController.mobileNumber = self.txtFieldMobileNumber.text!
                         nextViewController.CCode = self.txtFieldCCode.text!
                         nextViewController.VerificationID = verificationID!
                         self.activityIndicator.stopAnimating()
                         self.view.isUserInteractionEnabled = true
                         self.navigationController?.pushViewController(nextViewController, animated: true)
                     }
                 }
             }
         }
     }
