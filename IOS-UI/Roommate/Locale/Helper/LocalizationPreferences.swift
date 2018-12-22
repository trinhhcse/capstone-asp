//
//  LocalizationPreferences.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
//This class get and set current locale into UserDefaults
class LocalizationPreferences{
    private let keyCurrentLocale = "CURRENT_LOCALE"
    private let defaultLocale = "vi"
    
    static let shared = LocalizationPreferences()
    
    func currentLocale() -> String {
        if let locale = UserDefaults.standard.value(forKey: keyCurrentLocale){
            return locale as! String
        }
        return defaultLocale
    }
    
    func setCurrentLocale(_ locale:String) {
        UserDefaults.setValue(locale, forKey: keyCurrentLocale)
    }
}
