//
//  RemoveCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class RemoveCommand: ConcreteCommand {
    let file: String
    var force: Bool = false
    var verbose: Bool = false
    var recursive: Bool = false

    init(file: String, force: Bool = false, verbose: Bool = false, recursive: Bool = false) {
        self.file = file
        self.force = force
        self.verbose = verbose
        self.recursive = recursive
    }

    override var description: String {
        var rawCommand: [String] = ["rm"]

        if force { rawCommand.append("-f") }
        if verbose { rawCommand.append("-v") }
        if recursive { rawCommand.append("-r") }

        rawCommand.append(file)
        return rawCommand.joined(separator: " ")
    }
}
