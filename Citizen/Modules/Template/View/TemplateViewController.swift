//
//  TemplateViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class TemplateViewController: BaseViewController {
  
  // MARK:- Properties
  
  var presenter: TemplatePresentation?
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
//    setupHeader()
    configureViews()
    configureConstraints()
  }
  
  // MARK:- Setup
  
//  fileprivate func setupHeader() {
//    header.isHidden = true
//    header.delegate = self
//    header.title =
//    header.leftButtonImage =
//  }
  
  fileprivate func configureViews() {
    [].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      contentView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 40.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension TemplateViewController: TemplateView {
  // TODO: implement view output methods
}

//extension TemplateViewController: CitizenHeaderDelegate {
//  func didTapLeftButton() {
//    presenter?.didTapLeftButton()
//  }
//}
