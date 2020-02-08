//
//  PaddingTextField.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class PaddingTextField: UITextField {
  
  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
}
