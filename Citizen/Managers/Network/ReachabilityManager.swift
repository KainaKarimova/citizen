//
//  ReachabilityManager.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

public protocol NetworkStatusListener: class {
  func networkStatusDidChange(status: NetworkReachabilityManager.NetworkReachabilityStatus)
}

class ReachabilityManager: NSObject {
  static let shared = ReachabilityManager()
  var listeners = [NetworkStatusListener]()
  
  let reachability = NetworkReachabilityManager()!
  
  func isReachable() -> Bool {
    return reachability.isReachable
  }
  
  func startMonitoring() {
    debugPrint("Starting listening")
    reachability.listener = { status in
      switch status {
      case .notReachable:
        debugPrint("not reachable")
      case .reachable(_):
        debugPrint("reachable via")
      case .unknown:
        break
      }
      
      for listener in self.listeners {
        listener.networkStatusDidChange(status: status)
      }
    }
    reachability.startListening()
  }
  
  func stopMonitoring() {
    debugPrint("Stoping listening")
    reachability.stopListening()
  }
  
  func addListener(listener: NetworkStatusListener?) {
    print("added listener")
    if let listener = listener {
      listeners.append(listener)
    }
  }
  
  func removeListener(listener: NetworkStatusListener) {
    print("removed listener")
    listeners = listeners.filter { $0 !== listener }
  }
  
}
