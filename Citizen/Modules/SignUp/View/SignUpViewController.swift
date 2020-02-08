//
//  SignUpViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: BaseViewController, NetworkStatusListener {
  
  // MARK:- Properties
  
  var presenter: SignUpPresentation?
  
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
    view.inputTextField.placeholder = Constants.SignIn.phone
    view.type = .phone
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var nameInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "profile")
    view.inputTextField.placeholder = Constants.SignIn.name
    view.inputTextField.keyboardType = UIKeyboardType.default
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var cityInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "city")
    view.inputTextField.placeholder = Constants.SignIn.city
    view.inputTextField.keyboardType = UIKeyboardType.default
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var rankInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "menu")
    view.inputTextField.placeholder = "Ранк в Dota2"
    view.inputTextField.keyboardType = UIKeyboardType.default
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var passwordInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "lock")
    view.inputTextField.placeholder = Constants.SignIn.password
    view.inputTextField.isSecureTextEntry = true
    view.textfieldDelegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var passwordConfirmInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "lock")
    view.inputTextField.placeholder = Constants.SignIn.confirmPassword
    view.inputTextField.isSecureTextEntry = true
    view.textfieldDelegate = self
    view.isActive = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constants.SignIn.signUp, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addShadow(cornerRadius: 10.0)
    button.titleLabel?.font = Fonts.playBold?.withSize(18.0)
    button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
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
    
    [logoImageView, phoneInput, nameInput, cityInput, rankInput, passwordInput, passwordConfirmInput, signUpButton].forEach {
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
      
      nameInput.widthAnchor.constraint(equalToConstant: 270.0),
      nameInput.heightAnchor.constraint(equalToConstant: 52.0),
      nameInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      nameInput.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: 30.0),
      
      cityInput.widthAnchor.constraint(equalToConstant: 270.0),
      cityInput.heightAnchor.constraint(equalToConstant: 52.0),
      cityInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      cityInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 30.0),
      
      rankInput.widthAnchor.constraint(equalToConstant: 270.0),
      rankInput.heightAnchor.constraint(equalToConstant: 52.0),
      rankInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      rankInput.topAnchor.constraint(equalTo: cityInput.bottomAnchor, constant: 30.0),
      
      passwordInput.topAnchor.constraint(equalTo: rankInput.bottomAnchor, constant: 30.0),
      passwordInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      passwordInput.widthAnchor.constraint(equalToConstant: 270.0),
      passwordInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      passwordConfirmInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 30.0),
      passwordConfirmInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      passwordConfirmInput.widthAnchor.constraint(equalToConstant: 270.0),
      passwordConfirmInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      signUpButton.topAnchor.constraint(equalTo: passwordConfirmInput.bottomAnchor, constant: 30.0),
      signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      signUpButton.widthAnchor.constraint(equalToConstant: 270.0),
      signUpButton.heightAnchor.constraint(equalToConstant: 52.0),
      
      contentView.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 50.0)
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
    case phoneInput:
      let text = phoneInput.inputTextField.text
      let number = CitizenUtil.getTextWithNumbersOnly(text: text)
      if Validator.isValidPhoneNumber(phoneNumber: number) {
        phoneInput.showActivityIndicator()
        presenter?.checkIfUserExists(phoneInput.getPhoneNumber())
      }
    case nameInput:
      let name = nameInput.inputTextField.text
      if Validator.isValidName(name: name) {
        nameInput.showSuccess()
      } else {
        nameInput.errorMessage = "Введите корректное имя"
        nameInput.showFail()
      }
    case cityInput:
      let city = cityInput.inputTextField.text
      if Validator.isValidName(name: city) {
        cityInput.showSuccess()
      } else {
        cityInput.errorMessage = "Введите корректное имя города"
        cityInput.showFail()
      }
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
      (phoneInput, "Введите номер телефона"),
      (nameInput, "Введите имя"),
      (cityInput, "Введите город"),
      (rankInput, "Введите ранк в dota2"),
      (passwordInput, "Введите пароль"),
      (passwordConfirmInput, "Подтвердите пароль")
    ]
    
    for (inputView, errorMessage) in inputViewsWithErrorMessages {
      if inputView.isSuccess() == false {
        if showError {
          inputView.shake()
          if inputView.type == .phone && !inputView.isCorrectNumber() {
            inputView.errorMessage = errorMessage
          }
          if inputView.inputTextField.text?.isEmpty == true {
            inputView.errorMessage = errorMessage
          }
          scrollView.scroll(toView: inputView, animated: true)
        }
        return false
      }
    }
    return true
  }
  
  @objc func didTapSignUp() {
    
    [
      phoneInput.inputTextField,
      nameInput.inputTextField,
      cityInput.inputTextField,
      rankInput.inputTextField,
      passwordInput.inputTextField,
      passwordConfirmInput.inputTextField
      ].forEach {
        $0.resignFirstResponder()
    }
    
    if !checkInputs(showError: true) {
      return
    }
    
    let phone = phoneInput.getPhoneNumber()
    let pass = passwordInput.inputTextField.text
    let name = nameInput.inputTextField.text
    let city = cityInput.inputTextField.text
    let rank = rankInput.inputTextField.text
    
    
    let userData = UserModel(phone: phone, password: pass, name: name, city: city, rank: rank)
    presenter?.didTapSignUp(userData: userData)
  }
  
  func networkStatusDidChange(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
    if status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan) {
      hideNoNetworkView()
    }
  }
  
}

extension SignUpViewController: TextInputDelegate {
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

extension SignUpViewController: SignUpView {
  // TODO: implement view output methods
  func updateWith(exists: Bool) {
    if exists {
      phoneInput.showFail()
      phoneInput.errorMessage = "Пользователь с таким номером уже существует"
      
    } else {
      phoneInput.showSuccess()
    }
  }
}
