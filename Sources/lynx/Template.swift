//
//  Template.swift
//  lynx
//
//  Created by David Chavez on 24.09.20.
//

import Foundation
import GitUtils
import FileUtils

protocol Template {
    var productName: String { get }
    var bundleId: String { get }

    var repositoryUrl: String { get }

    // MARK: - Template Public API
    func validate() throws
    func vivify() throws
    func cleanup() throws
    func printInstructions()

    // MARK: - Internal Kickoff

    func fetchRemoteTemplate() throws
}

extension Template {
    func fetchRemoteTemplate() throws {
        print("Fetching template")
        try GitUtils.clone(repository: repositoryUrl, depth: 1, directory: "\(tempPath)/").execute()
    }

    func cleanup() throws {
        try FileUtils.rm(file: tempPath, force: true, recursive: true).execute()
    }

    func printInstructions() {
        print("\n")
        print("Run instructions for iOS:".lightCyan())
        print("• Open \(productName)/ios/\(productName).xcworkspace in Xcode")
        print("• Hit the Run button")
        print("- or -")
        print("• Run \"cd \(productName) && xed -b ios\"")
        print("• Hit the Run button")
        print("\n")
        print("Run instructions for Android:".lightGreen())
        print("• Open \(productName) in Android Studio")
        print("• Hit the Run button")
    }
}
