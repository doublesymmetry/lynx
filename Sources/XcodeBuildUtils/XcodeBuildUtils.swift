//
//  XcodeBuildUtils.swift
//  XcodeBuildUtils
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

public enum XcodeBuildUtils {
    public static func build(sdk: String? = nil, workspace: String? = nil, project: String? = nil, scheme: String? = nil, destination: String? = nil) -> ConcreteCommand {
        XcodeBuildCommand(sdk: sdk, workspace: workspace, project: project, scheme: scheme, destination: destination)
    }
}
