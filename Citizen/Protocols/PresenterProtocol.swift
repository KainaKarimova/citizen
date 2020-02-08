//
//  PresenterProtocol.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol InteractorOutputProtocol: class {
  @discardableResult
  func handleError(_ error: NSError?) -> Bool
  
  @discardableResult
  func handleErrorMessage(_ error: NSError?) -> Bool
  
  @discardableResult
  func handleFirebaseError(_ error: NSError?, completion: ( () -> Void)?) -> Bool
}
