//
//  XcodeBuildCommand.swift
//  XcodeBuildUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

class XcodeBuildCommand: ConcreteCommand {
    let sdk: String? // improvement: make this an enum
    let workspace: String?
    let project: String?
    let scheme: String?
    let destination: String?

    init(sdk: String? = nil, workspace: String? = nil, project: String? = nil, scheme: String? = nil, destination: String? = nil) {
        self.sdk = sdk
        self.workspace = workspace
        self.project = project
        self.scheme = scheme
        self.destination = destination
    }

    override var description: String {
        var rawCommand: [String] = ["xcodebuild"]

        if let workspace = workspace { rawCommand.append(contentsOf: ["-workspace", workspace]) }
        if let project = project { rawCommand.append(contentsOf: ["-project", project]) }
        if let scheme = scheme { rawCommand.append(contentsOf: ["-scheme", scheme]) }
        if let destination = destination { rawCommand.append(contentsOf: ["-destination", destination]) }

        return rawCommand.joined(separator: " ")
    }
}
