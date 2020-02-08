//
//  StringExtension.swift
//  Citizen
//
//  Created by Karina Karimova on 9/27/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

extension String {
  subscript (i: Int) -> Character? {
    if i < count {
      return self[index(startIndex, offsetBy: i)]
    } else {
      return nil
    }
  }
}
