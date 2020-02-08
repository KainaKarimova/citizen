//
//  MappableProtocol.swift
//  Citizen
//
//  Created by Karina Karimova on 9/24/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol Mappable: class {
  func toDataObject() -> [String : Any?]
}
