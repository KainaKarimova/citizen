//
//  HistoryViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
  
  // MARK:- Properties
  
  var presenter: HistoryPresentation?
  
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
    header.title = Constants.History.history
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

extension HistoryViewController: HistoryView {
  // TODO: implement view output methods
}

extension HistoryViewController: CitizenHeaderDelegate {
  func didTapLeftButton() {
    presenter?.didTapLeftButton()
  }
}
