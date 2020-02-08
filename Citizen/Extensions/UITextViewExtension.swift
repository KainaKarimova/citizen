//
//  UITextViewExtension.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

extension UITextView {
  
  func setupAccessoryInput() {
    let toolbar = UIToolbar(frame: CGRect.init(x: 0.0, y: 0.0, width: self.frame.width, height: 44.0))
    let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "chevron_down"), style: .plain, target: self, action: #selector(hideKeyboard))
    dismissButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
    dismissButton.tintColor = DesignUtil.citizenThemeGreen()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    toolbar.items = [flexSpace, dismissButton]
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    toolbar.addGestureRecognizer(tapGestureRecognizer)
    
    self.inputAccessoryView = toolbar
  }
  
  @objc func hideKeyboard() {
    self.resignFirstResponder()
  }
}
