//
//  ProfilePresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class ProfilePresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: ProfileView?
  var router: ProfileWireframe?
  var interactor: ProfileUseCase?
}

extension ProfilePresenter: ProfilePresentation {
  // TODO: implement presentation methods
  
  func viewDidLoad() {
    view?.showActivityIndicator()
    interactor?.fetchProfileInfo()
  }
  
  func refresh() {
    
  }
  
  func didTapLeftButton() {
    router?.popBack()
  }
}

extension ProfilePresenter: ProfileInteractorOutput {
  // TODO: implement interactor output methods
  func gotProfileInfo(data: UserModel) {
    view?.hideActivityIndicator()
    view?.updateWith(userData: data)
  }
}
