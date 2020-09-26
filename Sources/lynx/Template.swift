//
//  Template.swift
//  lynx
//
//  Created by David Chavez on 24.09.20.
//

import Foundation

protocol Template {
    var productName: String { get }
    var bundleId: String { get }

    func vivify() throws
    func cleanup() throws
    func printInstructions()
}
