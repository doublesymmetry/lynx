//
//  FileUtils.swift
//  FileUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

public enum FileUtils {
    public static func mkdir(name: String..., mode: Int? = nil, verbose: Bool = false, createIntermediateDirectories: Bool = false) -> ConcreteCommand {
        CreateDirectoryCommand(name: name.joined(separator: " "), mode: mode, verbose: verbose, createIntermediateDirectories: createIntermediateDirectories)
    }

    public static func mkdir(name: [String], mode: Int? = nil, verbose: Bool = false, createIntermediateDirectories: Bool = false) -> ConcreteCommand {
        CreateDirectoryCommand(name: name.joined(separator: " "), mode: mode, verbose: verbose, createIntermediateDirectories: createIntermediateDirectories)
    }

    public static func cp(source: String..., target: String, verbose: Bool = false, recursive: Bool = false) -> ConcreteCommand {
        CopyCommand(source: source.joined(separator: " "), target: target, recursive: recursive, verbose: verbose)
    }

    public static func cp(source: [String], target: String, verbose: Bool = false, recursive: Bool = false) -> ConcreteCommand {
        CopyCommand(source: source.joined(separator: " "), target: target, recursive: recursive, verbose: verbose)
    }

    public static func rm(file: String..., force: Bool = false, verbose: Bool = false, recursive: Bool = false) -> ConcreteCommand {
        RemoveCommand(file: file.joined(separator: " "), force: force, verbose: verbose, recursive: recursive)
    }

    public static func rm(file: [String], force: Bool = false, verbose: Bool = false, recursive: Bool = false) -> ConcreteCommand {
        RemoveCommand(file: file.joined(separator: " "), force: force, verbose: verbose, recursive: recursive)
    }

    public static func cd(directory: String) -> ConcreteCommand {
        ChangeDirectoryCommand(directory: directory)
    }

    public static func findWhile(path: String..., type: String? = nil, name: String? = nil, transform: @escaping (String) throws -> Void) -> ConcreteCommand {
        FindWhileCommand(path: path.joined(separator: " "), type: type, name: name, transform: transform)
    }

    public static func findWhile(path: [String], type: String? = nil, name: String? = nil, transform: @escaping (String) throws -> Void) -> ConcreteCommand {
        FindWhileCommand(path: path.joined(separator: " "), type: type, name: name, transform: transform)
    }

    public static func sed(script: String) -> ConcreteCommand {
        SedCommand(script: script)
    }

    public static func sed(script: String, file: String..., editInPlace: Bool = false) -> ConcreteCommand {
        SedCommand(script: script, file: file.joined(separator: " "), editInPlace: editInPlace)
    }

    public static func sed(script: String, file: [String], editInPlace: Bool = false) -> ConcreteCommand {
        SedCommand(script: script, file: file.joined(separator: " "), editInPlace: editInPlace)
    }

    public static func mv(source: String..., target: String, force: Bool = false) -> ConcreteCommand {
        MoveCommand(source: source.joined(separator: " "), target: target, force: force)
    }

    public static func mv(source: [String], target: String, force: Bool = false) -> ConcreteCommand {
        MoveCommand(source: source.joined(separator: " "), target: target, force: force)
    }
}
