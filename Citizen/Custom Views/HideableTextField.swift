//
//  HideableTextField.swift
//  Citizen
//
//  Created by Karina Karimova on 9/25/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class HideableTextField: SkyFloatingLabelTextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAccessoryInput()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupAccessoryInput()
  }
  
  override func becomeFirstResponder() -> Bool {
    super.becomeFirstResponder()
    
    if !isSecureTextEntry { return true }
    
    if let currentText = text { insertText(text ?? "") }
    
    return true
  }
  
  override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return false
  }
  
}
