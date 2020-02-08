//
//  MainMenuViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class MainMenuViewController: BaseViewController {

  // MARK:- Properties
  
  var presenter: MainMenuPresentation?
  
  fileprivate lazy var categoryInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "menu")
    view.iconWidth = 18
    view.iconHeight = 18
    view.inputTextField.placeholder = Constants.MainMenu.chooseCategory
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var adressInput: TextInputView = {
    let view = TextInputView()
    view.iconImage = #imageLiteral(resourceName: "placemark")
    view.iconWidth = 18
    view.iconHeight = 26
    view.inputTextField.placeholder = Constants.MainMenu.chooseCategory
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var messageView: CitizenTextView = {
    let view = CitizenTextView()
    view.placeHolder = Constants.MainMenu.inputMessage
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var photoButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "photo"), for: .normal)
    //addtarget
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  fileprivate lazy var photoLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.playRegular?.withSize(18.0)
    label.numberOfLines = 1
    label.contentMode = .center
    label.text = Constants.MainMenu.addPhoto
    label.textColor = DesignUtil.citizenThemeGreen()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var sendButton: CitizenIconButton = {
    let button = CitizenIconButton()
    button.iconImage = #imageLiteral(resourceName: "warn")
    button.title.text = Constants.MainMenu.sendMessage
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
    setupHeader()
    configureViews()
    configureConstraints()
    scrollEnabled = false
  }
  
  // MARK:- Setup
  
  fileprivate func setupHeader() {
    header.delegate = self
    header.title = Constants.MainMenu.message
    header.leftButtonImage = #imageLiteral(resourceName: "menu")
  }
  
  fileprivate func configureViews() {
    [categoryInput, adressInput, messageView, photoButton, photoLabel, sendButton].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      categoryInput.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 36.0),
      categoryInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      categoryInput.widthAnchor.constraint(equalToConstant: 289.0),
      categoryInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      adressInput.topAnchor.constraint(equalTo: categoryInput.bottomAnchor, constant: 12.0),
      adressInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      adressInput.widthAnchor.constraint(equalToConstant: 289.0),
      adressInput.heightAnchor.constraint(equalToConstant: 52.0),
      
      messageView.topAnchor.constraint(equalTo: adressInput.bottomAnchor, constant: 22.0),
      messageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      messageView.widthAnchor.constraint(equalToConstant: 289.0),
      messageView.heightAnchor.constraint(equalToConstant: 160.0),
      
      photoButton.widthAnchor.constraint(equalToConstant: 80.0),
      photoButton.heightAnchor.constraint(equalToConstant: 66.0),
      photoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      photoButton.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 22.0),
      
      photoLabel.centerXAnchor.constraint(equalTo: photoButton.centerXAnchor),
      photoLabel.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 1.0),
      
      sendButton.widthAnchor.constraint(equalToConstant: 269.0),
      sendButton.heightAnchor.constraint(equalToConstant: 52.0),
      sendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      sendButton.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 32),
      
      contentView.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 50.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension MainMenuViewController: MainMenuView {
  // TODO: implement view output methods
}

extension MainMenuViewController: CitizenHeaderDelegate {
  func didTapLeftButton() {
    self.sideMenuController?.revealMenu()
    view.endEditing(true)
  }
}
