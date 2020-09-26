//
//  GitCloneCommand.swift
//  GitUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class GitCloneCommand: ConcreteCommand {
    let repository: String
    let depth: UInt?
    let verbose: Bool
    let directory: String?

    init(repository: String, depth: UInt? = nil, verbose: Bool = false, directory: String? = nil) {
        self.repository = repository
        self.depth = depth
        self.verbose = verbose
        self.directory = directory
    }

    override var description: String {
        var rawCommand: [String] = ["git", "clone"]

        if verbose { rawCommand.append("-v") }
        if let depth = depth { rawCommand.append(contentsOf: ["--depth", "\(depth)"]) }

        rawCommand.append(repository)

        if let directory = directory { rawCommand.append(directory) }

        return rawCommand.joined(separator: " ")
    }
}
