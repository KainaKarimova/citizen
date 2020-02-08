//
//  ViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/10/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK:- Properties
  
  fileprivate lazy var helloLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 80, weight: UIFont.Weight.heavy)
    label.numberOfLines = 2
    label.contentMode = .center
    label.text = "Алибек   Рак"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var crabLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 256, weight: UIFont.Weight.heavy)
    label.numberOfLines = 1
    label.contentMode = .center
    label.text = "🦀"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureViews()
    configureConstraints()
    
  }

  // MARK:- Setup
  
  fileprivate func configureViews() {
    [helloLabel, crabLabel].forEach {
      view.addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
//      helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
      helloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
      helloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
      
//      crabLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      crabLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
//      crabLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
      crabLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      crabLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}

