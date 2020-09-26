//
//  FindWhileCommand.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation
import SwiftShell

class FindWhileCommand: ConcreteCommand {
    let path: String
    let type: String?
    let name: String?
    let transform: (String) throws -> Void

    init(path: String, type: String? = nil, name: String? = nil, transform: @escaping (String) throws -> Void) {
        self.path = path
        self.type = type
        self.name = name
        self.transform = transform
    }

    override var description: String {
        var rawCommand: [String] = ["find", path]
        if let type = type { rawCommand.append(contentsOf: ["-type", type]) }
        if let name = name { rawCommand.append(contentsOf: ["-name", "'\(name)'"]) }

        return rawCommand.joined(separator: " ")
    }

    override func execute(ignoreFailure _: Bool) throws {
        let command = run(bash: description)
        let results = command.stdout.split(separator: "\n")
        try results.forEach { try transform(String($0)) }
    }
}
