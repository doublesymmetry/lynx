//
//  PodInstallCommand.swift
//  lynx
//
//  Created by David Chavez on 25.09.20.
//

import Command
import Foundation
import SwiftShell

class PodInstallCommand: ConcreteCommand {
    var canInstall: Bool {
        canUseCocoaPodsThroughBundler() || canUseSystemPod()
    }

    override var description: String {
        canUseCocoaPodsThroughBundler()
            ? ["bundle", "exec", "pod", "install"].joined(separator: " ")
            : ["pod", "install"].joined(separator: " ")
    }

    /// Returns true if CocoaPods is accessible through Bundler,
    /// and shoudl be used instead of the global CocoaPods.
    ///
    /// - Returns: True if Bundler can execute CocoaPods.
    fileprivate func canUseCocoaPodsThroughBundler() -> Bool {
        let testBundleCommand = run("bundle", "info", "cocoapods")
        return testBundleCommand.succeeded
    }

    /// Returns true if CocoaPods is avaiable in the environment.
    ///
    /// - Returns: True if CocoaPods is available globally in the system.
    fileprivate func canUseSystemPod() -> Bool {
        let testBundleCommand = run("which", "pod")
        return testBundleCommand.succeeded
    }
}
