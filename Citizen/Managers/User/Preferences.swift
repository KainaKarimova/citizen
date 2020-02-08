//
//  Preferences.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

struct Preferences<T> {
  let key: String
  
  var value: T? {
    get { return UserDefaults.standard.object(forKey: key) as? T }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
  
  init(_ k: String = #function) {
    key = k
  }
}
