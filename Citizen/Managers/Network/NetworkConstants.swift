//
//  NetworkConstants.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct NetworkConstants{
  
  static let emailPrefix = "@citizen.com"
  fileprivate static let rootRefPath = "citizenTest"
  //let rootRefPath = "citizen"
  
  static var rootRef: DatabaseReference {
    get {
      return Database.database().reference().child(rootRefPath)
    }
  }
  
}
