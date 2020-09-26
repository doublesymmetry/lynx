//
//  Pod.swift
//  lynx
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation

enum PodError: Error, CustomStringConvertible {
    case cocoapodsNotFound

    public var description: String {
        switch self {
        case .cocoapodsNotFound:
            return "CocoaPods was not found either in Bundler nor in the environment"
        }
    }
}

enum Pod {
    static func canInstall() -> Bool {
        PodInstallCommand().canInstall
    }

    static func install() -> ConcreteCommand {
        PodInstallCommand()
    }
}
