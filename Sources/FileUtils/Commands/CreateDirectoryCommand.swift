//
//  CreateDirectoryCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class CreateDirectoryCommand: ConcreteCommand {
    let name: String
    let mode: Int?
    let verbose: Bool
    let createIntermediateDirectories: Bool

    init(name: String, mode: Int? = nil, verbose: Bool = false, createIntermediateDirectories: Bool = false) {
        self.name = name
        self.mode = mode
        self.verbose = verbose
        self.createIntermediateDirectories = createIntermediateDirectories
    }

    override var description: String {
        var rawCommand: [String] = ["mkdir"]

        if verbose { rawCommand.append("-v") }
        if createIntermediateDirectories { rawCommand.append("-p") }
        if let mode = mode { rawCommand.append(contentsOf: ["-m", "\(mode)"]) }

        rawCommand.append(name)

        return rawCommand.joined(separator: " ")
    }
}
