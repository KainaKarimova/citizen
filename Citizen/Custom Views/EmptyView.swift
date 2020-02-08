//
//  EmptyView.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

protocol EmptyViewDelegate: class {
  func didTapReloadButton()
}

class EmptyView: UIView {
  
  var emptyLabel = UILabel()
  weak var delegate: EmptyViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initViews()
  }
  
  private func initViews() {
    self.backgroundColor = UIColor.white
    
    addSubview(emptyLabel)
    emptyLabel.translatesAutoresizingMaskIntoConstraints = false
    emptyLabel.text = Constants.Misc.nothingFoundError
    emptyLabel.textAlignment = .center
    emptyLabel.numberOfLines = 0
    emptyLabel.font = UIFont.systemFont(ofSize: 15.0)
    
    let labelLeftCon = NSLayoutConstraint(item: emptyLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 32.0)
    let labelRightCon = NSLayoutConstraint(item: emptyLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -32.0)
    let labelYCon = NSLayoutConstraint(item: emptyLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -32.0)
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = DesignUtil.citizenThemeGreen()
    button.addShadow()
    button.setTitle(Constants.Misc.refresh, for: .normal)
    button.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
    addSubview(button)
    let buttonWidth = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 250.0)
    let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 50.0)
    let buttonBottomCon = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: emptyLabel, attribute: .top, multiplier: 1.0, constant: -32.0)
    let buttonXAlign = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    
    addConstraints([labelLeftCon, labelRightCon, labelYCon, buttonWidth, buttonHeight, buttonBottomCon, buttonXAlign])
  }
  
  @objc func reloadData() {
    delegate?.didTapReloadButton()
  }
  
}
