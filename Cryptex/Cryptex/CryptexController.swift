//
//  CryptexController.swift
//  Cryptex
//
//  Created by Taylor Lyles on 5/1/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation

class CryptexController {
    
    init() {
        randomCryptex()
    }
    
    private var cryptexs = [Cryptex(password: "Lambda", hint: "We go to what school?")]
    
    var currentCryptex: Cryptex?
    
    func randomCryptex() {
       currentCryptex = cryptexs.randomElement()
    }

}

