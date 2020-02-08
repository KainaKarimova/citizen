//
//  ChangePasswordViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: BaseViewController, NetworkStatusListener {
  
  // MARK:- Properties
  
  var presenter: ChangePasswordPresentation?
  
  fileprivate lazy var logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "Logo")
    iv.contentMode = UIViewContentMode.scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var passwordInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "lock")
    view.inputTextField.placeholder = "Введите новый пароль"
    view.inputTextField.isSecureTextEntry = true
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var passwordConfirmInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "lock")
    view.inputTextField.placeholder = "Подтвердите пароль"
    view.inputTextField.isSecureTextEntry = true
    view.textfieldDelegate = self
    view.isActive = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var changeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Сменить пароль", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addShadow(cornerRadius: 10.0)
    button.titleLabel?.font = Fonts.playBold?.withSize(18.0)
    button.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
    button.backgroundColor = DesignUtil.citizenThemeGreen()
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
    
    [logoImageView, passwordInput, passwordConfirmInput, changeButton].forEach {
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
      
      passwordInput.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30.0),
      passwordInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      passwordInput.widthAnchor.constraint(equalToConstant: 270.0),
      passwordInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      passwordConfirmInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 30.0),
      passwordConfirmInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      passwordConfirmInput.widthAnchor.constraint(equalToConstant: 270.0),
      passwordConfirmInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      changeButton.topAnchor.constraint(equalTo: passwordConfirmInput.bottomAnchor, constant: 30.0),
      changeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      changeButton.widthAnchor.constraint(equalToConstant: 270.0),
      changeButton.heightAnchor.constraint(equalToConstant: 52.0),
      
      contentView.bottomAnchor.constraint(equalTo: changeButton.bottomAnchor, constant: 150.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  @objc func didTapCross() {
    presenter?.didTapClose()
  }
  
  func check(textInput: TextInputView) {
    if textInput.inputTextField.text?.isEmpty ?? true {
      textInput.hideSuccess()
      return
    }
    
    switch textInput {
    case passwordInput:
      let password = passwordInput.inputTextField.text ?? ""
      if Validator.isValidPassword(password: password) {
        passwordInput.showSuccess()
      } else {
        if password.count < 6 {
          passwordInput.errorMessage = "Длина пароля должна быть минимум 6 символов"
        } else {
          passwordInput.errorMessage = "Некорректный пароль"
        }
        passwordInput.showFail()
      }
    case passwordConfirmInput:
      if passwordInput.inputTextField.text == passwordConfirmInput.inputTextField.text {
        passwordConfirmInput.showSuccess()
      } else {
        passwordConfirmInput.errorMessage = "Пароли не совпадают"
        passwordConfirmInput.showFail()
      }
    default:
      textInput.showSuccess()
    }
  }
  
  func checkInputs(showError: Bool) -> Bool {
    
    //    phone name city rank password
    let inputViewsWithErrorMessages = [
      (passwordInput, "Введите пароль"),
      (passwordConfirmInput, "Подтвердите пароль")
    ]
    
    for (inputView, errorMessage) in inputViewsWithErrorMessages {
      if inputView.isSuccess() == false {
        if showError {
          inputView.shake()
          if inputView.inputTextField.text?.isEmpty == true {
            inputView.errorMessage = errorMessage
          }
//          scrollView.scroll(toView: inputView, animated: true)
        }
        return false
      }
    }
    return true
  }
  
  @objc func didTapChange() {
    
    [
      passwordInput.inputTextField,
      passwordConfirmInput.inputTextField
      ].forEach {
        $0.resignFirstResponder()
    }
    
    if !checkInputs(showError: true) {
      return
    }
    
    let pass = passwordInput.inputTextField.text ?? ""
    presenter?.didTapChange(password: pass)
  }
  
  func networkStatusDidChange(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
    if status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan) {
      hideNoNetworkView()
    }
  }
  
}

extension ChangePasswordViewController: TextInputDelegate {
  func didChange(_ textInput: TextInputView) {
    
    let password = passwordInput.inputTextField.text
    passwordConfirmInput.isActive = Validator.isValidPassword(password: password)
  }
  
  func didBeginEditing(_ textInput: TextInputView) {
    
  }
  
  func didFinishEditing(_ textInput: TextInputView) {
    check(textInput: textInput)
  }
}

//phone name city rank password passwordConfirm

extension ChangePasswordViewController: ChangePasswordView {
  // TODO: implement view output methods

}
