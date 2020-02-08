//
//  MenuCell.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class MenuCellPresentation {
  
  enum CellInfoType {
    case profile
    case info
    case history
    case exit
  }
  
  var type: CellInfoType
  var iconImage: UIImage
  var title: String
  
  init(type: CellInfoType, iconImage: UIImage, title: String) {
    self.iconImage = iconImage
    self.title = title
    self.type = type
  }
}

class MenuCell: UITableViewCell {
  
  // MARK:- Properties
  
  var presentationData: MenuCellPresentation? {
    didSet {
      guard let data = presentationData else { return }
      configure(data: data)
    }
  }
  
  fileprivate lazy var cellButton: CitizenIconButton = {
    let button = CitizenIconButton()
    button.mainColor = .white
    button.isUserInteractionEnabled = false
    button.iconWidth = 26
    button.iconHeight = 28
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK:- Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK:- Setup
  
  fileprivate func configureViews() {
    addSubview(cellButton)
  }
  
  fileprivate func configureConstraints() {
    [
      cellButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      cellButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      cellButton.widthAnchor.constraint(equalToConstant: 214.0),
      cellButton.heightAnchor.constraint(equalToConstant: 46.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  func configure(data: MenuCellPresentation) {
    cellButton.iconImage = data.iconImage
    cellButton.title.text = data.title
  }
  
}

