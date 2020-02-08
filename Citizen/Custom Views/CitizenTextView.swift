//
//  CitizenTextView.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class CitizenTextView: BaseView {

  // MARK:- Properties
  
  var placeHolder = "" {
    didSet {
      textViewDidEndEditing(inputTextView)
    }
  }
  
  lazy var inputTextView: UITextView = {
    let tv = UITextView()
    tv.text = placeHolder
    tv.textColor = .lightGray
    tv.font = Fonts.playRegular?.withSize(18.0)
    tv.delegate = self
    tv.setupAccessoryInput()
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  
  // MARK:- Setup
  
  override func setupView() {
    super.setupView()
    addShadow(cornerRadius: 20.0)
    backgroundColor = .white
    configureViews()
    configureConstraints()
  }
  
  fileprivate func configureViews() {
    addSubview(inputTextView)
  }
  
  fileprivate func configureConstraints() {
    [
      inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
      inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 6.0),
      inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
      inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension CitizenTextView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = placeHolder
      textView.textColor = UIColor.lightGray
    }
  }
  
}
