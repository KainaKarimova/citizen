//
//  DesignUtil.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class DesignUtil {
  
  static func configureToAppAppearance() {
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().barTintColor = .white
  }
  
  static func citizenThemeGreen() -> UIColor {
    return UIColor(red:0.24, green:0.69, blue:0.42, alpha:1.0)
  }
  
  
}
