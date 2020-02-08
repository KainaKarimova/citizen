//
//  HistoryPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class HistoryPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: HistoryView?
  var router: HistoryWireframe?
  var interactor: HistoryUseCase?
}

extension HistoryPresenter: HistoryPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  func didTapLeftButton() {
    router?.popBack()
  }
}

extension HistoryPresenter: HistoryInteractorOutput {
  // TODO: implement interactor output methods
}
