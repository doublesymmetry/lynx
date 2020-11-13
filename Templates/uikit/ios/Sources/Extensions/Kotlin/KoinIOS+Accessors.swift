//
//  KoinIOS+Accessors.swift
//  Lynx
//
//  Created by David Chavez on 12.11.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import shared

extension KoinIOS {
    func logger(tag: String) -> Kermit {
        return get(objCClass: Kermit.self, parameter: tag) as! Kermit
    }
}
