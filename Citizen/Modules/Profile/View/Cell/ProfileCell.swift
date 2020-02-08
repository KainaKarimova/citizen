//
//  ProfileCell.swift
//  Citizen
//
//  Created by Karina Karimova on 9/24/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class ProfileCellPresentation {
  
  var title: String
  var content: String
  
  init(title: String, content: String) {
    
    self.title = title
    self.content = content
  }
}

class ProfileCell: UITableViewCell {
  
  // MARK:- Properties
  
  var presentationData: ProfileCellPresentation? {
    didSet {
      guard let data = presentationData else { return }
      configure(data: data)
    }
  }
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = "kek"
    label.font = Fonts.playBold?.withSize(18.0)
    label.textColor = DesignUtil.citizenThemeGreen()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = "cheburek"
    label.font = Fonts.playRegular?.withSize(16.0)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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
    [titleLabel, contentLabel].forEach {
      addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.0),
      
      contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 3.0),
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  func configure(data: ProfileCellPresentation) {
    titleLabel.text = data.title
    contentLabel.text = data.content
  }
  
}
