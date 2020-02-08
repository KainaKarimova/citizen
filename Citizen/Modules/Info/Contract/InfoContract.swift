//
//  InfoContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol InfoView: IndicatableView {
  // TODO: Declare view methods
}

protocol InfoPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapLeftButton()
}

protocol InfoUseCase: class {
  // TODO: Declare use case methods
}

protocol InfoInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
}

protocol InfoWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
