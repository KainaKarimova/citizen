//
//  UserManager.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserProfileManager {
  static let shared: UserProfileManager = UserProfileManager()

//  lazy var isLoggedIn = Preferences<Bool>("logged_in")
  var isLoggedIn: Bool {
    get {
      if let _ = Auth.auth().currentUser {
        return true
      } else {
        return false
      }
    }
  }
  lazy var verifiactionId = Preferences<String>("verifiaction_id")
  lazy var phoneNumber = Preferences<String>("phone_number")
  
  var stateListener: AuthStateDidChangeListenerHandle?
//  lazy var token = Preferences<String>()
//  lazy var isPasscodeSet = Preferences<Bool>("isPasscodeSet")
//  lazy var registrationToken = Preferences<String>("registration_token")
//  lazy var deviceUUID = Preferences<String>("UUID")
  
//  func saveUserToken(token: String, refreshToken: String) {
//    self.token.value = token
//    self.refreshToken.value = refreshToken
//    debugPrint("got tokens - \(token), refresh - \(refreshToken)")
//  }
  
  func getCurrentUser() -> User? {
    return Auth.auth().currentUser
  }
  
  func userLoggedIn() {
    stateListener = Auth.auth().addStateDidChangeListener { (auth, user) in
      if user == nil {
        print("NotLoggedIn")
        self.userLoggedOut()
      }
    }
  }
  
  func userLoggedOut() {
    if let listener = stateListener {
      Auth.auth().removeStateDidChangeListener(listener)
      RootRouter().presentLoginScreen(in: UIApplication.shared.keyWindow!, isFirstLaunch: false)
    }
  }
  
//  func userLoggedIn() {
//    self.role.value = 1
//    self.isLoggedIn.value = true
//    self.selectedRoleIndex.value = 0
//    self.registrationToken.value = nil
//
//    if #available(iOS 10.0, *) {
//      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//      UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (success, error) in
//        if let token = InstanceID.instanceID().token(), success == true {
//          ProfileAPIService.registerDeviceForNotifications(pushToken: token)
//        }
//      })
//    } else {
//      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//      UIApplication.shared.registerUserNotificationSettings(settings)
//    }
//  }
  
//  func userLoggedOut() {
//    InstanceID.instanceID().deleteID { (error) in
//      if error != nil {
//        debugPrint("unable to delete firebase token on logout", error!)
//      }
//    }
//    clearWebCache()
//    self.isPasscodeSet.value = nil
//    self.role.value = nil
//    self.isLoggedIn.value = nil
//    self.selectedRoleIndex.value = nil
//    self.token.value = nil
//    self.refreshToken.value = nil
//    self.roleID.value = nil
//    CityManager.shared.selectedCityID = nil
//    self.roles = BehaviorSubject(value: [RoleModel]())
//    self.balanceSubject = BehaviorSubject(value: Double(-1))
//    LTHPasscodeViewController.deletePasscode()
//    if (UIApplication.shared.delegate as? AppDelegate)?.chatManager != nil {
//      (UIApplication.shared.delegate as? AppDelegate)?.chatManager = nil
//    }
//  }
  
}
