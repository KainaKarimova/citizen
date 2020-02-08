//
//  UserModel.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class UserModel: Mappable {
  var phone: String?
  var password: String?
  var name: String?
  var city: String?
  var rank: String?
  
  init(phone: String?, password: String?, name: String?, city: String?, rank: String?) {
    self.phone = phone
    self.password = password
    self.name = name
    self.city = city
    self.rank = rank
  }
  
  init(dataObject: NSDictionary) {
    self.name = dataObject["name"] as? String
    self.phone = dataObject["phone"] as? String
    self.city = dataObject["city"] as? String
    self.rank = dataObject["rank"] as? String
  }
  
  func toDataObject() -> [String : Any?] {
    let data = [
      "name" : name,
      "city" : city,
      "rank" : rank
    ]
    return data
  }
  
}
