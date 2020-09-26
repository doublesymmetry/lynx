//
//  Command.swift
//  Command
//
//  Created by David Chavez on 25.09.20.
//

import Foundation
import SwiftShell

public enum CommandError: Error, CustomStringConvertible {
    case commandFailed(message: String)

    public var description: String {
        switch self {
        case let .commandFailed(message):
            return message
        }
    }
}

public protocol Command: CustomStringConvertible {
    func execute(ignoreFailure: Bool) throws
}

// this is a workaround for not being able to have an array of a protocol
// conform to the extension of an array where elements must be that protocol :(
open class ConcreteCommand: Command {
    public init() {}

    open var description: String { fatalError("commandLiteral should be overwritten in subclasses") }

    open func execute(ignoreFailure: Bool = false) throws {
        let command = run(bash: description)
        if !command.succeeded, !ignoreFailure {
            throw CommandError.commandFailed(message: command.stderror)
        }
    }
}

public extension Array where Element: Command {
    func execute(ignoreFailure: Bool = false) throws {
        let rawCommand = map { $0.description }.joined(separator: " && ")

        let joinedCommand = run(bash: rawCommand)
        if !joinedCommand.succeeded, !ignoreFailure {
            throw CommandError.commandFailed(message: joinedCommand.stderror)
        }
    }
}
