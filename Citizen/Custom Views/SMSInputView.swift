//
//  SMSInputView.swift
//  Citizen
//
//  Created by Karina Karimova on 9/25/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

protocol SmsInputDelegate: class {
  func didFinishWith(code: String)
}

protocol OneDigitDelegate: class {
  func deleteOnEmptyPressed(textField: UITextField)
  func deleteOnFilledPressed(textField: UITextField)
}

class OneDigitTextField: UITextField {
  weak var oneDigitDelegate: OneDigitDelegate?
  
  override func deleteBackward() {
    if text! == "" {
      oneDigitDelegate?.deleteOnEmptyPressed(textField: self)
    } else {
      oneDigitDelegate?.deleteOnFilledPressed(textField: self)
    }
    super.deleteBackward()
  }
}

@IBDesignable
class SmsInputView: UIView, UITextFieldDelegate, OneDigitDelegate {
  weak var delegate: SmsInputDelegate?
  var textFields = [OneDigitTextField]()
  var bottomLines = [UIView]()
  var codeLength = 6
  var padding: CGFloat = 16.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initViews()
  }
  
  private func initViews() {
    for i in 0..<codeLength {
      let txtFld = OneDigitTextField()
      txtFld.font = UIFont.systemFont(ofSize: 36.0)
      txtFld.textColor = .black
      txtFld.textAlignment = .center
      txtFld.delegate = self
      txtFld.oneDigitDelegate = self
      txtFld.backgroundColor = self.backgroundColor
      txtFld.tintColor = txtFld.backgroundColor
      txtFld.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
      txtFld.keyboardType = .numberPad
      addSubview(txtFld)
      setupConstraints(textField: txtFld, index: i)
      textFields.append(txtFld)
    }
    textFields.first!.becomeFirstResponder()
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(findLastTextFieldForEditing), for: .touchDown)
    addSubview(button)
    let buttonLeftCon = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
    let buttonRightCon = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
    let buttonTopCon = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
    let buttonBotCon = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    addConstraints([buttonLeftCon, buttonRightCon, buttonTopCon, buttonBotCon])
  }
  
  private func setupConstraints(textField: UITextField, index: Int) {
    textField.translatesAutoresizingMaskIntoConstraints = false
    let width = (220 - (CGFloat(codeLength + 1) * padding))/4.0
    let txtLeftCon = NSLayoutConstraint(
      item: textField,
      attribute: .left,
      relatedBy: .equal,
      toItem: self,
      attribute: .left,
      multiplier: 1.0,
      constant: CGFloat(width * CGFloat(index) + padding * CGFloat(index + 1))
    )
    let txtWidthCon = NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: width)
    let txtBotCon = NSLayoutConstraint(
      item: textField,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: -8.0
    )
    let txtTopCon = NSLayoutConstraint(
      item: textField,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0.0
    )
    addConstraints([txtLeftCon, txtWidthCon, txtTopCon, txtBotCon])
    let bottomLine = UIView()
    bottomLine.backgroundColor = .black
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    bottomLines.append(bottomLine)
    addSubview(bottomLine)
    let lineHeight: CGFloat = 2.0
    let lineTopCon = NSLayoutConstraint(item: bottomLine, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    let lineWidthCon = NSLayoutConstraint(item: bottomLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: width)
    let lineHeightCon = NSLayoutConstraint(item: bottomLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute:. notAnAttribute, multiplier: 0.0, constant: lineHeight)
    let lineCenter = NSLayoutConstraint(item: bottomLine, attribute: .centerX, relatedBy: .equal, toItem: textField, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    addConstraints([lineTopCon, lineWidthCon, lineHeightCon, lineCenter])
  }
  
  func getCode() -> String {
    var code = ""
    for txtFld in textFields {
      code += txtFld.text!
    }
    return code
  }
  
  @objc func textFieldChanged(textField: UITextField) {
    if textField.text!.count == 1 {
      textField.endEditing(true)
      for i in 0..<textFields.count {
        let txtFld = textFields[i]
        if txtFld == textField {
          bottomLines[i].backgroundColor = DesignUtil.citizenThemeGreen()
          let nextIndex = i + 1
          if nextIndex == codeLength {
            delegate?.didFinishWith(code: getCode())
          } else {
            textFields[nextIndex].becomeFirstResponder()
          }
        }
      }
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentString = textField.text! as NSString
    let newString = currentString.replacingCharacters(in: range, with: string)
    return newString.count <= 1
  }
  
  @objc func findLastTextFieldForEditing() {
    for textField in textFields {
      if textField.text == "" {
        textField.becomeFirstResponder()
        return
      }
    }
    
    textFields.last!.becomeFirstResponder()
  }
  
  func goToPrevTextField(textField: OneDigitTextField) {
    let index = textFields.index(of: textField)
    let prevIndex = index! - 1
    if prevIndex >= 0 {
      textFields[prevIndex].becomeFirstResponder()
      textFields[prevIndex].text = ""
      bottomLines[prevIndex].backgroundColor = .black
    }
  }
  
  func deleteOnEmptyPressed(textField: UITextField) {
    goToPrevTextField(textField: textField as! OneDigitTextField)
  }
  
  func deleteOnFilledPressed(textField: UITextField) {
    let index = textFields.index(of: textField as! OneDigitTextField)
    bottomLines[index!].backgroundColor = .black
  }
  
}
