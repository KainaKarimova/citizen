//
//  InfoViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {
  
  // MARK:- Properties
  
  var presenter: InfoPresentation?
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
    setupHeader()
    configureViews()
    configureConstraints()
  }
  
  // MARK:- Setup
  
  fileprivate func setupHeader() {
    header.delegate = self
    header.title = Constants.Info.info
    header.leftButtonImage = #imageLiteral(resourceName: "back")
  }
  
  fileprivate func configureViews() {
    [].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension InfoViewController: InfoView {
  // TODO: implement view output methods
}

extension InfoViewController: CitizenHeaderDelegate {
  func didTapLeftButton() {
    presenter?.didTapLeftButton()
  }
}
