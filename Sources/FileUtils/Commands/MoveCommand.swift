//
//  MoveCommand.swift
//  FileUtils
//
//  Created by David Chavez on 26.09.20.
//

import Command
import Foundation

class MoveCommand: ConcreteCommand {
    let source: String
    let target: String
    let force: Bool

    init(source: String, target: String, force: Bool = false) {
        self.source = source
        self.target = target
        self.force = force
    }

    override var description: String {
        var rawCommand: [String] = ["mv"]

        if force { rawCommand.append("-f") }

        rawCommand.append(contentsOf: [source, target])
        return rawCommand.joined(separator: " ")
    }
}
