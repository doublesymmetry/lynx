//
//  SedCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class SedCommand: ConcreteCommand {
    let file: String?
    var script: String
    var editInPlace: Bool

    init(script: String, file: String? = nil, editInPlace: Bool = false) {
        self.file = file
        self.script = script
        self.editInPlace = editInPlace
    }

    override var description: String {
        var rawCommand: [String] = ["LC_ALL=C", "sed"]

        if editInPlace { rawCommand.append(contentsOf: ["-i", "''"]) }

        rawCommand.append("'\(script)'")

        if let file = file { rawCommand.append("'\(file)'") }

        return rawCommand.joined(separator: " ")
    }
}
