//
//  GitUtils.swift
//  GitUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

public enum GitUtils {
    public static func clone(repository: String, depth: UInt? = nil, verbose: Bool = false, directory: String? = nil) -> ConcreteCommand {
        GitCloneCommand(repository: repository, depth: depth, verbose: verbose, directory: directory)
    }
}
