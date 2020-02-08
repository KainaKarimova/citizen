//
//  ForgotPasswordViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: BaseViewController, NetworkStatusListener {
  
  // MARK:- Properties
  
  var presenter: ForgotPasswordPresentation?
  var isFirstLaunch = false
  
  fileprivate lazy var logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "Logo")
    iv.contentMode = UIViewContentMode.scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var phoneInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "phone")
    //    view.inputTextField.placeholder = Constants.SignIn.phone
    view.type = .phone
    view.textfieldDelegate = self
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var resetButton: UIButton = {
    let button = UIButton()
    button.setTitle("Восстановить пароль", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addShadow(cornerRadius: 10.0)
    button.titleLabel?.font = Fonts.playBold?.withSize(18.0)
    button.addTarget(self, action: #selector(didTapForget), for: .touchUpInside)
    button.backgroundColor = Colors.inactiveColor
    button.isUserInteractionEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  fileprivate lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "cross"), for: .normal)
    button.addTarget(self, action: #selector(didTapCross), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    header.isHidden = true
    view.backgroundColor = Colors.mainBackgroundColor
    configureViews()
    configureConstraints()
  }
  
  // MARK:- Setup
  
  fileprivate func configureViews() {
    
    view.addSubview(closeButton)
    view.bringSubview(toFront: closeButton)
    
    [logoImageView, phoneInput, resetButton].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    
    [
      closeButton.widthAnchor.constraint(equalToConstant: 16.0),
      closeButton.heightAnchor.constraint(equalToConstant: 16.0),
      closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
      closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
      
      logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 67.0),
      logoImageView.widthAnchor.constraint(equalToConstant: 188.0),
      logoImageView.heightAnchor.constraint(equalToConstant: 161.0),
      
      phoneInput.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30.0),
      phoneInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      phoneInput.widthAnchor.constraint(equalToConstant: 270.0),
      phoneInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      resetButton.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: 20.0),
      resetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      resetButton.widthAnchor.constraint(equalToConstant: 270.0),
      resetButton.heightAnchor.constraint(equalToConstant: 52.0),
      
      contentView.bottomAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 50.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  @objc func didTapCross() {
    presenter?.didTapClose()
  }
  
  @objc func didTapForget() {
    phoneInput.inputTextField.resignFirstResponder()
    presenter?.checkIfUserExists(phoneInput.getPhoneNumber())
    phoneInput.showActivityIndicator()
  }
  
  func networkStatusDidChange(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
    if status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan) {
      hideNoNetworkView()
    }
  }
  
}

extension ForgotPasswordViewController: phoneNumberDelegate {
  func enteredNumber(isCorrect: Bool) {
    if isCorrect {
      resetButton.backgroundColor = DesignUtil.citizenThemeGreen()
      resetButton.isUserInteractionEnabled = true
    } else {
      resetButton.backgroundColor = Colors.inactiveColor
      resetButton.isUserInteractionEnabled = false
    }
  }
}

extension ForgotPasswordViewController: TextInputDelegate {
  func didChange(_ textInput: TextInputView) {
    
  }
  
  func didBeginEditing(_ textInput: TextInputView) {

  }
  
  func didFinishEditing(_ textInput: TextInputView) {
    
  }
}

extension ForgotPasswordViewController: ForgotPasswordView {
  // TODO: implement view output methods
  func updateWith(exists: Bool) {
    if exists {
      phoneInput.showSuccess()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.presenter?.didTapForget(phone: self.phoneInput.getPhoneNumber())
      }
    } else {
      phoneInput.showFail()
      phoneInput.errorMessage = "Пользователя с таким номером не существует"
    }
    
  }
}
