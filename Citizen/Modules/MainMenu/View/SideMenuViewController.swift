//
//  SideMenuViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
  
  // MARK:- Properties
  
  var presenter: MainMenuPresentation?
  
  let presentationData = [
    MenuCellPresentation(type: .profile, iconImage: #imageLiteral(resourceName: "profile"), title: Constants.MainMenu.profile),
    MenuCellPresentation(type: .info, iconImage: #imageLiteral(resourceName: "info"), title: Constants.MainMenu.info),
    MenuCellPresentation(type: .history, iconImage: #imageLiteral(resourceName: "history"), title: Constants.MainMenu.history),
    MenuCellPresentation(type: .exit, iconImage: #imageLiteral(resourceName: "exit"), title: Constants.MainMenu.exit)
  ]
  
  fileprivate lazy var borderView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 20
    view.layer.borderWidth = 1
    view.layer.borderColor = DesignUtil.citizenThemeGreen().cgColor
    view.backgroundColor = UIColor.white
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "logo_mini")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  let reuseIdentifier = "MenuCellId"
  fileprivate lazy var menuTableView: UITableView = {
    let tbv = UITableView()
    tbv.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)
    tbv.delegate = self
    tbv.dataSource = self
    tbv.backgroundColor = .clear
    tbv.isScrollEnabled = false
    tbv.separatorStyle = .none
    tbv.translatesAutoresizingMaskIntoConstraints = false
    return tbv
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear//.white
    configureViews()
    configurConstraints()
  }
  
  // MARK:- Setup
  
  fileprivate func configureViews() {
    [borderView, iconImageView, menuTableView].forEach {
      view.addSubview($0)
    }
    view.sendSubview(toBack: borderView)
  }
  
  fileprivate func configurConstraints() {
    [
      borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      borderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
      borderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      borderView.widthAnchor.constraint(equalToConstant: 250.0),
      
      iconImageView.widthAnchor.constraint(equalToConstant: 54.0),
      iconImageView.heightAnchor.constraint(equalToConstant: 44.0),
      iconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -101.0),
      iconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 33.0),
      
      menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
      menuTableView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0.0),
      menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      menuTableView.widthAnchor.constraint(equalToConstant: 250.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presentationData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
    cell.presentationData = presentationData[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! MenuCell
    guard let presentationData = cell.presentationData else { return }
    presenter?.didSelect(presentationData: presentationData)
  }
}
