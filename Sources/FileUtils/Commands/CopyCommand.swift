//
//  CopyCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class CopyCommand: ConcreteCommand {
    let source: String
    let target: String
    let recursive: Bool
    let verbose: Bool

    init(source: String, target: String, recursive: Bool = false, verbose: Bool = false) {
        self.source = source
        self.target = target
        self.recursive = recursive
        self.verbose = verbose
    }

    override var description: String {
        var rawCommand: [String] = ["cp"]

        if verbose { rawCommand.append("-v") }
        if recursive { rawCommand.append("-r") }

        rawCommand.append(contentsOf: [source, target])

        return rawCommand.joined(separator: " ")
    }
}
