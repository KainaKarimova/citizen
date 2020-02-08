//
//  InfoPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class InfoPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: InfoView?
  var router: InfoWireframe?
  var interactor: InfoUseCase?
}

extension InfoPresenter: InfoPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  
  func didTapLeftButton() {
    router?.popBack()
  }
}

extension InfoPresenter: InfoInteractorOutput {
  // TODO: implement interactor output methods
}
