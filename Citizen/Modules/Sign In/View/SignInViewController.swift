//
//  SignInViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: BaseViewController, NetworkStatusListener {
  
  // MARK:- Properties
  
  var presenter: SignInPresentation?
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
  
  fileprivate lazy var passwordInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "lock")
    view.inputTextField.placeholder = Constants.SignIn.password
    view.type = .password
    view.alpha = 0
    view.isUserInteractionEnabled = false
    view.inputTextField.isSecureTextEntry = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var signInButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constants.SignIn.next, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addShadow(cornerRadius: 10.0)
    button.titleLabel?.font = Fonts.playBold?.withSize(18.0)
    button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    button.backgroundColor = Colors.inactiveColor
    button.isUserInteractionEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
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
  
  fileprivate lazy var forgotButton: UIButton = {
    let button = UIButton(type: UIButtonType.system)
    button.setTitle(Constants.SignIn.forgotPassword, for: .normal)
    button.setTitleColor(DesignUtil.citizenThemeGreen(), for: .normal)
    button.addTarget(self, action: #selector(didTapForget), for: .touchUpInside)
    button.titleLabel?.font = Fonts.playBold?.withSize(14.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  fileprivate lazy var helpButton: UIButton = {
    let button = UIButton(type: UIButtonType.system)
    button.setTitle(Constants.SignIn.help, for: .normal)
    button.setTitleColor(DesignUtil.citizenThemeGreen(), for: .normal)
    button.titleLabel?.font = Fonts.playBold?.withSize(14.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK:- Lifecycle
  
  var animatingViews = [UIView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    header.isHidden = true
    view.backgroundColor = Colors.mainBackgroundColor
    configureViews()
    configureConstraints()
    if isFirstLaunch {
      prepareAnimation()
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if isFirstLaunch {
        animate()
    }
  }
  
  // MARK:- Setup
  
  fileprivate func configureViews() {
    
    [logoImageView, phoneInput, passwordInput, signInButton, signUpButton, forgotButton, helpButton].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    
    [
      logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 67.0),
      logoImageView.widthAnchor.constraint(equalToConstant: 188.0),
      logoImageView.heightAnchor.constraint(equalToConstant: 161.0),
      
      phoneInput.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30.0),
      phoneInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      phoneInput.widthAnchor.constraint(equalToConstant: 270.0),
      phoneInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      passwordInput.topAnchor.constraint(equalTo: phoneInput.topAnchor, constant: 0.0),
      passwordInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      passwordInput.widthAnchor.constraint(equalToConstant: 270.0),
      passwordInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      signInButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 20.0),
      signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      signInButton.widthAnchor.constraint(equalToConstant: 270.0),
      signInButton.heightAnchor.constraint(equalToConstant: 52.0),
      
      signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20.0),
      signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      signUpButton.widthAnchor.constraint(equalToConstant: 270.0),
      signUpButton.heightAnchor.constraint(equalToConstant: 52.0),
      
      forgotButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30.0),
      forgotButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      forgotButton.widthAnchor.constraint(equalToConstant: 115.0),
      forgotButton.heightAnchor.constraint(equalToConstant: 15.0),
      
      helpButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 18.0),
      helpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      helpButton.widthAnchor.constraint(equalToConstant: 200.0),
      helpButton.heightAnchor.constraint(equalToConstant: 15.0),
      contentView.bottomAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: 50.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  func prepareAnimation() {
    let coef: CGFloat = 1.42236024845
    let transform = CGAffineTransform(scaleX: coef, y: coef).concatenating(CGAffineTransform(translationX: 0, y: 124))
    logoImageView.transform = transform
    
    animatingViews = [phoneInput, passwordInput, signInButton, signUpButton]
    animatingViews.forEach {
      $0.transform = CGAffineTransform(translationX: -322, y: 0)
    }
    
    helpButton.alpha = 0
    forgotButton.alpha = 0
    
    statusBarView.alpha = 0
  }
  
  func animate() {
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.logoImageView.transform = .identity
      self.helpButton.alpha = 1
      self.forgotButton.alpha = 1
      self.statusBarView.alpha = 1
    }) { (completed) in
      
    }
    let pause = 0.2
    for i in animatingViews.indices {
      let delay = pause + 0.1 * Double(i)
      UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction], animations: {
        self.animatingViews[i].transform = .identity
      }) { (completed) in
        
      }
    }
  }
  
  func isSignInHidden() -> Bool {
    return passwordInput.alpha == 0
  }
  
  func showSignIn() {
    passwordInput.isUserInteractionEnabled = true
    signInButton.setTitle(Constants.SignIn.signIn, for: .normal)
    
    UIView.animate(withDuration: 0.5) {
      self.passwordInput.alpha = 1
    }
    
    UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut, .allowUserInteraction], animations: {
      [self.signInButton, self.passwordInput, self.signUpButton, self.forgotButton, self.helpButton].forEach {
//        $0.transform = CGAffineTransform(translationX: 0, y: 72.0)
        $0.frame.origin.y += 72.0
      }
    })
  }
  
  func hideSignIn() {
    if isSignInHidden() {
      return
    }
    
    passwordInput.isUserInteractionEnabled = false
    signInButton.setTitle(Constants.SignIn.next, for: .normal)
    UIView.animate(withDuration: 0.2) {
      self.passwordInput.alpha = 0
    }
    
    UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut, .allowUserInteraction], animations: {
      [self.signInButton, self.passwordInput, self.signUpButton, self.forgotButton, self.helpButton].forEach {
//        $0.transform = .identity
        $0.frame.origin.y -= 72.0
      }
    })
  }
  
  @objc func didTapSignIn() {
    
    [phoneInput.inputTextField, passwordInput.inputTextField].forEach {
      $0.resignFirstResponder()
    }
    
    if isSignInHidden() {
      presenter?.checkIfUserExists(phoneInput.getPhoneNumber())
      phoneInput.showActivityIndicator()
//      passwordInput.inputTextField.becomeFirstResponder()
      return
    }
    
    let phone = phoneInput.getPhoneNumber()
    
    presenter?.didTapSignIn(
      phone: phone,
      password: passwordInput.inputTextField.text ?? ""
    )
  }
  
  @objc func didTapSignUp() {
    phoneInput.inputTextField.resignFirstResponder()
    passwordInput.inputTextField.resignFirstResponder()
    presenter?.didTapSignUp()
  }
  
  @objc func didTapForget() {
    presenter?.didTapForget(phone: phoneInput.getPhoneNumber())
  }
  
  func networkStatusDidChange(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
    if status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan) {
      hideNoNetworkView()
    }
  }
  
}

extension SignInViewController: phoneNumberDelegate {
  func enteredNumber(isCorrect: Bool) {
    if isCorrect {
      signInButton.backgroundColor = DesignUtil.citizenThemeGreen()
      signInButton.isUserInteractionEnabled = true
    } else {
      signInButton.backgroundColor = Colors.inactiveColor
      signInButton.isUserInteractionEnabled = false
    }
  }
}

extension SignInViewController: TextInputDelegate {
  func didChange(_ textInput: TextInputView) {
    
  }
  
  func didBeginEditing(_ textInput: TextInputView) {
    if textInput.type == .phone {
      hideSignIn()
    }
  }
  
  func didFinishEditing(_ textInput: TextInputView) {
    
  }
}

extension SignInViewController: SignInView {
  // TODO: implement view output methods
  func updateWith(exists: Bool) {
    if exists {
      phoneInput.showSuccess()
      showSignIn()
    } else {
      phoneInput.showFail()
      phoneInput.errorMessage = "Пользователя с таким номером не существует"
    }
    
  }
}
