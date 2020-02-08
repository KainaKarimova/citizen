//
//  TextInputView.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

enum TextInputType {
  case text
  case phone
  case password
}

protocol phoneNumberDelegate: class {
  func enteredNumber(isCorrect: Bool)
}

protocol TextInputDelegate: class {
  func didBeginEditing(_ textInput: TextInputView)
  func didFinishEditing(_ textInput: TextInputView)
  func didChange(_ textInput: TextInputView)
}

class TextInputView: BaseView {
  
  // MARK:- Properties
  
  weak var delegate: phoneNumberDelegate?
  weak var textfieldDelegate: TextInputDelegate?
  
  var type = TextInputType.text {
    didSet {
      switch type {
      case .text:
        inputTextField.keyboardType = .default
        inputTextField.isSecureTextEntry = false
      case .phone:
        let text = inputTextField.text
        inputTextField.text = CitizenUtil.getFormattedPhoneNumber(phoneNumber: text)
        inputTextField.keyboardType = .phonePad
        inputTextField.isSecureTextEntry = false
      case .password:
        inputTextField.keyboardType = .default
        inputTextField.isSecureTextEntry = true
      }
    }
  }
  
  var isActive = true {
    didSet {
      if isActive {
        backgroundColor = .white
        isUserInteractionEnabled = true
      } else {
        backgroundColor = Colors.inactiveColor
        isUserInteractionEnabled = false
      }
    }
  }
  
  var errorMessage = "" {
    didSet {
      errorLabel.text = errorMessage
    }
  }
  
  var iconImage: UIImage! {
    didSet {
      iconImageView.image = iconImage
    }
  }
  
  var iconWidth: CGFloat = 30 {
    didSet {
      iconWidthConstraint.constant = iconWidth
    }
  }
  var iconHeight: CGFloat = 30 {
    didSet {
      iconHeightConstraint.constant = iconHeight
    }
  }
  
  fileprivate var iconWidthConstraint: NSLayoutConstraint!
  fileprivate var iconHeightConstraint: NSLayoutConstraint!
  
  fileprivate lazy var iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = UIViewContentMode.scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = DesignUtil.citizenThemeGreen()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var inputTextField: UITextField = {
    let tf = UITextField()
    tf.font = Fonts.playRegular?.withSize(18.0)
    tf.setupAccessoryInput()
    tf.delegate = self
    tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  fileprivate lazy var indicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView()
    view.activityIndicatorViewStyle = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var successImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = #imageLiteral(resourceName: "check")
    iv.isHidden = true
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textColor = .red
    label.layer.shadowOpacity = 0.0
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    label.font = Fonts.playRegular?.withSize(16.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK:- Setup
  
  override func setupView() {
    super.setupView()
    self.addShadow(cornerRadius: 10)
    backgroundColor = .white
    configureViews()
    configureConstraints()
  }
  
  fileprivate func configureViews() {
    [iconImageView, separatorView, inputTextField, indicatorView, errorLabel, successImageView].forEach {
      addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    
    iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: iconWidth)
    iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: iconHeight)
    
    [
      iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.0),
      iconWidthConstraint,
      iconHeightConstraint,
      
      separatorView.heightAnchor.constraint(equalToConstant: 28.0),
      separatorView.widthAnchor.constraint(equalToConstant: 1.0),
      separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      separatorView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 9.0),
      
      inputTextField.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 10.0),
      inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0),
      inputTextField.trailingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: -10.0),
      inputTextField.heightAnchor.constraint(equalTo: heightAnchor),
      
      indicatorView.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
      indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
      
      successImageView.widthAnchor.constraint(equalToConstant: 24.0),
      successImageView.heightAnchor.constraint(equalToConstant: 24.0),
      successImageView.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
      successImageView.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
      
//      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1.0),
      errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      errorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2),
      errorLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -1.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
 
  func showActivityIndicator() {
    hideSuccess()
    indicatorView.startAnimating()
    self.isUserInteractionEnabled = false
  }
  
  func hideActivityIndicator() {
    indicatorView.stopAnimating()
    self.isUserInteractionEnabled = true
  }
  
  func showSuccess() {
    hideActivityIndicator()
    successImageView.image = #imageLiteral(resourceName: "check")
    successImageView.isHidden = false
  }
  
  func showFail() {
    hideActivityIndicator()
    successImageView.image = #imageLiteral(resourceName: "red_cross")
    successImageView.isHidden = false
  }
  
  func hideSuccess() {
    successImageView.isHidden = true
  }
  
  func isSuccess() -> Bool {
    return successImageView.isHidden == false && successImageView.image == #imageLiteral(resourceName: "check")
  }
  
  func isCorrectNumber() -> Bool {
    let text = inputTextField.text ?? ""
    let number = CitizenUtil.getTextWithNumbersOnly(text: text)
    return Validator.isValidPhoneNumber(phoneNumber: number)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    errorMessage = ""
    hideSuccess()
    textfieldDelegate?.didChange(self)
    if type == .phone {
      let text = inputTextField.text ?? ""
      let formattedText = CitizenUtil.getFormattedPhoneNumber(phoneNumber: text)
      inputTextField.text = formattedText
      let number = CitizenUtil.getTextWithNumbersOnly(text: formattedText)
      if Validator.isValidPhoneNumber(phoneNumber: number) {
        delegate?.enteredNumber(isCorrect: true)
      } else {
        delegate?.enteredNumber(isCorrect: false)
      }
    }
  }
  
  func getPhoneNumber() -> String {
    return "+" + CitizenUtil.getTextWithNumbersOnly(text: inputTextField.text ?? "")
  }
  
}

extension TextInputView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    errorMessage = ""
    hideSuccess()
    textfieldDelegate?.didBeginEditing(self)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textfieldDelegate?.didFinishEditing(self)
  }
}
