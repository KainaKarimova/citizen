//
//  SignUpSMSViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class SignUpSMSViewController: BaseViewController {
  
  // MARK:- Properties
  
  var presenter: SignUpSMSPresentation?
  
  var userData: UserModel! {
    didSet {
      phoneNumberLabel.text = CitizenUtil.getFormattedPhoneNumber(phoneNumber: userData.phone ?? "") 
    }
  }
  
  fileprivate lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "cross"), for: .normal)
    button.addTarget(self, action: #selector(didTapCross), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  fileprivate lazy var sentSmsLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = Constants.SignUpSMS.smsSent
    label.textAlignment = .center
    label.font = Fonts.playRegular?.withSize(20.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var phoneNumberLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = Constants.SignUpSMS.smsSent
    label.textAlignment = .center
    label.font = Fonts.playRegular?.withSize(24.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var codeInputView: SmsInputView = {
    let view = SmsInputView()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
    setupHeader()
    configureViews()
    configureConstraints()
  }
  
  // MARK:- Setup
  
  fileprivate func setupHeader() {
    header.isHidden = true
  }
  
  fileprivate func configureViews() {
    [closeButton, sentSmsLabel, phoneNumberLabel, codeInputView].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      closeButton.widthAnchor.constraint(equalToConstant: 16.0),
      closeButton.heightAnchor.constraint(equalToConstant: 16.0),
      closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.0),
      closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
      
      sentSmsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      sentSmsLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 21.0),
      sentSmsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
      sentSmsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
      
      phoneNumberLabel.centerXAnchor.constraint(equalTo: sentSmsLabel.centerXAnchor),
      phoneNumberLabel.topAnchor.constraint(equalTo: sentSmsLabel.bottomAnchor, constant: 10.0),
      phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
      phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
      
      codeInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50.0),
      codeInputView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 45.0),
  
      contentView.bottomAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 40.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  @objc func didTapCross() {
    didTapLeftButton()
  }
  
  @objc func didTapSubmit() {
    
//    presenter?.didTapSubmit(verificationCode: codeInputTextField.text ?? "", userData: userData)
  }
  
}

extension SignUpSMSViewController: SmsInputDelegate {
  func didFinishWith(code: String) {
    presenter?.didTapSubmit(verificationCode: code, userData: userData)
  }
}

extension SignUpSMSViewController: SignUpSMSView {
  // TODO: implement view output methods
}

extension SignUpSMSViewController: CitizenHeaderDelegate {
  func didTapLeftButton() {
    presenter?.didTapLeftButton()
  }
}
