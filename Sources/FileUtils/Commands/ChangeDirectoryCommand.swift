//
//  ChangeDirectoryCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class ChangeDirectoryCommand: ConcreteCommand {
    let directory: String

    init(directory: String) {
        self.directory = directory
    }

    override var description: String {
        ["cd", directory].joined(separator: " ")
    }
}
