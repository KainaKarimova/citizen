//
//  Validator.swift
//  Citizen
//
//  Created by Karina Karimova on 9/25/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

let phoneRegexMap = [
  "SA" : "^\\d{12}$",
  "default" : "^\\d{11}$"
]

let nameRegex = "^[A-ZА-ЯЁӘІҢҒҮҰҚӨҺ][A-Za-zА-Яа-яЁёӘәІіҢңҒғҮүҰұҚқӨөҺһ'][A-Za-zА-Яа-яЁёӘәІіҢңҒғҮүҰұҚқӨөҺһ\\-.' ]*$"

class Validator {
  static let minimumPasswordLength = 6
  
  static func isValidPhoneNumber(phoneNumber: String?) -> Bool {
//    var country = Locale.current.regionCode ?? ""
    var phoneRegex: String
    var country: String?
    if let char = phoneNumber?[0] {
      switch char {
      case "7":
        country = "RU"
      case "9":
        country = "SA"
      default:
        country = nil
      }
    }
    guard country != nil else { return false }
    
    if let regex = phoneRegexMap[country!] {
      phoneRegex = regex
    } else {
      phoneRegex = phoneRegexMap["default"]!
    }
    
    let phonePredicate = NSPredicate.init(format: "SELF MATCHES %@", phoneRegex)
    return phonePredicate.evaluate(with: phoneNumber)
  }
  
  static func isValidName(name: String?) -> Bool {
    guard let name = name else { return false }
    let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    
    return nameTest.evaluate(with: name)
  }
  
  static func isValidPassword(password: String?) -> Bool {
    if (password?.count)! < Validator.minimumPasswordLength {
      return false
    }
    let pattern = "^[A-Za-z0-9.,:;?!'\"`^&=|~*+%\\-<>@\\[\\]{}()/\\\\_$#]{6,100}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", pattern)
    let passwordTest2 = NSPredicate(format: "SELF MATCHES %@", pattern)
    let passwordTest3 = NSPredicate(format: "SELF MATCHES %@", pattern)
    return passwordTest.evaluate(with: password)
      || passwordTest2.evaluate(with: password)
      || passwordTest3.evaluate(with: password)
  }
  
}
