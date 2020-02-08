//
//  ProfileViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
  
  // MARK:- Properties
  
  var presenter: ProfilePresentation?
  
  var presentationData = [ProfileCellPresentation]() {
    didSet {
      profileTableView.reloadData()
    }
  }
  
  fileprivate lazy var avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "avatarPlaceholder")
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  let reuseIdentifier = "ProfileCellId"
  var tableViewHeightConstraint: NSLayoutConstraint!
  fileprivate lazy var profileTableView: UITableView = {
    let tbv = UITableView()
    tbv.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    tbv.delegate =  self
    tbv.dataSource = self
    tbv.backgroundColor = .white
    tbv.addShadow(cornerRadius: 6.0)
    tbv.isScrollEnabled = false
    tbv.separatorInset = .zero
    tbv.translatesAutoresizingMaskIntoConstraints = false
    return tbv
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
    showActivityIndicator()
    setupHeader()
    configureViews()
    configureConstraints()
  }
  
  // MARK:- Setup
  
  fileprivate func setupHeader() {
    header.delegate = self
    header.title = Constants.Profile.profile
    header.leftButtonImage = #imageLiteral(resourceName: "back")
  }
  
  fileprivate func configureViews() {
    [avatarImageView, profileTableView].forEach {
      contentView.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    
    tableViewHeightConstraint = profileTableView.heightAnchor.constraint(equalToConstant: 0.0)
    [
      avatarImageView.widthAnchor.constraint(equalToConstant: 149.0),
      avatarImageView.heightAnchor.constraint(equalToConstant: 126.0),
      avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      avatarImageView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40.0),
      
      profileTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.0),
      profileTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40.0),
      tableViewHeightConstraint,
      profileTableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32.0),
      
      contentView.bottomAnchor.constraint(equalTo: profileTableView.bottomAnchor, constant: 40.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

extension ProfileViewController: ProfileView {
  // TODO: implement view output methods
  func updateWith(userData: UserModel) {
    presentationData = [
      ProfileCellPresentation(title: "Имя", content: userData.name ?? ""),
      ProfileCellPresentation(title: "Телефон", content: userData.phone ?? ""),
      ProfileCellPresentation(title: "Город", content: userData.city ?? ""),
      ProfileCellPresentation(title: "Ранк в Dota2", content: userData.rank ?? "")
    ]
    
    tableViewHeightConstraint.constant = 70.0 * CGFloat(presentationData.count)
  }
  
  
}

extension ProfileViewController: CitizenHeaderDelegate {
  func didTapLeftButton() {
    presenter?.didTapLeftButton()
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
    cell.presentationData = presentationData[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
}
