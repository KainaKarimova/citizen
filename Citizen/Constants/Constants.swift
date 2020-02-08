//
//  Constants.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  
  struct SignIn {
    static let signIn = "Войти"
    static let next = "Далее"
    static let signUp = "Регистрация"
    static let phone = "Телефон"
    static let name = "Имя"
    static let city = "Город"
    static let password = "Пароль"
    static let confirmPassword = "Подтвердите пароль"
    static let passwordsDoNotMatch = "Пароли не совпадают!"
    static let forgotPassword = "Забыли пароль?"
    static let help = "Связаться с техподдержкой"
  }
  
  struct MainMenu {
    static let message = "Сообщение"
    static let chooseCategory = "Выберите категорию"
    static let inputMessage = "Введите текст сообщения..."
    static let addPhoto = "Прикрепить фотографию"
    static let sendMessage = "Отправить сообщение"
    static let profile = "Профиль"
    static let info = "Инфо"
    static let history = "История"
    static let exit = "Выйти"
  }
  
  struct Profile {
    static let profile = "Профиль"
  }
  
  struct Info {
    static let info = "Инфо"
  }
  
  struct History {
    static let history = "История"
  }
  
  struct SignUpSMS {
    static let smsSent = "SMS код отправлен на номер"
  }
  
  struct Misc {
    static let nothingFoundError = "Ничего не найдено"
    static let networkError = "Не удаётся установить соединение с сервером. Попробуйте заново"
    static let genericError = "Ошибка!"
    static let refresh = "Обновить"
  } 
}

struct Colors {
  
  static let mainBackgroundColor = UIColor(red:0.94, green:0.95, blue:0.98, alpha:1.0)
  static let navigationTextColor = UIColor(red: 79.0/255.0, green: 87.0/255.0, blue: 99.0/255.0, alpha: 1.0)
  static let blueColor = UIColor(red: 78.0/255.0, green: 142.0/255.0, blue: 237.0/255.0, alpha: 1.0)
  static let inactiveColor = UIColor(red:0.55, green:0.63, blue:0.73, alpha:1.0)
}

struct Fonts {
  static let playRegular = UIFont(name: "Play-Regular", size: UIFont.labelFontSize)
  static let playBold = UIFont(name: "Play-Bold", size: UIFont.labelFontSize)
}

