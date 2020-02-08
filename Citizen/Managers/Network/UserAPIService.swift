//
//  UserAPIService.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserAPIService {
  
  static func checkIfUserExists(phoneNumber: String, completion: @escaping(Bool?, Error?) -> Void) {
   
    let ref = NetworkConstants.rootRef
    
    ref.child("users").child(phoneNumber).observeSingleEvent(of: .value, with: { (snapshot) in
      
      let exists = snapshot.exists()
      completion(exists, nil)
      
    }) { (error) in
      
      completion(nil, error)
    }
    
  }
  
  static func signUpWith(verificationID: String, verificationCode: String, userData: UserModel, completion: @escaping(AuthDataResult?, Error?) -> Void) {
    
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
    
    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
      if let error = error {
        completion(authResult, error)
        return
        
      }
      guard let phone = UserProfileManager.shared.phoneNumber.value else { return }
      guard let password = userData.password else { return }
      
      let email = phone + NetworkConstants.emailPrefix
      
      Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
          if let error = error {
            completion(nil, error)
            return
          }
          
          let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
          changeRequest?.displayName = phone
          changeRequest?.commitChanges { (error) in
            if error != nil {
              print("Error setting displayName")
            }
          }
          
          let id = Auth.auth().currentUser?.uid
          
          var user = userData.toDataObject()
          user["phone"] = phone
          user["id"] = id
          user["password"] = password
          
          let ref = NetworkConstants.rootRef
          ref.child("users").child(phone).setValue(user, withCompletionBlock: { (error, ref) in
            completion(authResult, error)
          })
        })
      })
    }
  }
  
  static func verifyCode(verificationID: String, verificationCode: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
    
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
    
    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
      if let error = error {
        completion(authResult, error)
        return
      }
      signOut(completion: { (error) in
        if let error = error {
          print("Error logging out while verifying code:", error)
          completion(authResult, error)
          return
        }
        completion(authResult, error)
      })
      
      
    }
  }
  
  static func signInWith(phoneNumber: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
    
    let email = phoneNumber + NetworkConstants.emailPrefix
    
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
      completion(authResult, error)
    }
    
  }
  
  static func verifyPhoneNumberWith(phone: String, completion: @escaping(String?, Error?) -> Void) {
    PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
      UserProfileManager.shared.verifiactionId.value = verificationID
      UserProfileManager.shared.phoneNumber.value = phone
      completion(verificationID, error)
    }
  }
  
  static func signOut(completion: @escaping(Error?) -> Void) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      completion(signOutError)
    }
    completion(nil)
  }
  
  static func fetchProfileInfo(completion: @escaping(NSDictionary?, Error?) -> Void) {
    
    let ref = NetworkConstants.rootRef
    let phone = Auth.auth().currentUser?.displayName
    
    ref.child("users").child(phone!).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let value = snapshot.value as? NSDictionary {
        completion(value, nil)
      }
    }) { (error) in
      completion(nil, error)
    }
    
  }
  
  static func changePasswordTo(newPassword: String, phone: String, completion: @escaping(Error?) -> Void) {
    
    let ref = NetworkConstants.rootRef
    ref.child("users").child(phone).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let value = snapshot.value as? NSDictionary {
        if let password = value["password"] as? String {
          signInWith(phoneNumber: phone, password: password, completion: { (result, error) in
            if let error = error {
              completion(error)
              return
            }
            
            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
              if let error = error {
                completion(error)
                return
              }
              ref.child("users").child(phone).child("password").setValue(newPassword, withCompletionBlock: { (error, ref) in
                if let error = error {
                  completion(error)
                  return
                }
                signOut(completion: { (error) in
                  if let error = error {
                    print("Error signing out while changing password:", error)
                    return
                  }
                  completion(nil)
                })
              })
            })
          })
        }
      } else {
        print("No password")
      }
      
    }) { (error) in
      completion(error)
    }

  }
}
