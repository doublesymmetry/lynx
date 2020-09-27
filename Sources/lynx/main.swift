//
//  main.swift
//  lynx
//
//  Created by David Chavez on 24.09.20.
//

import ColorizeSwift
import Commander
import Darwin
import FileUtils
import SwiftShell

let version = "0.0.2"

enum ExecutionError: Error, CustomStringConvertible {
    case invalidIdentifier
    case xcodeMissing
    case androidDeveloperToolsMissing

    var description: String {
        switch self {
        case .invalidIdentifier:
            return "The bundle identifier prefix is invalid. Example: com.doublesymmetry"
        case .xcodeMissing:
            return "Xcode nor Xcode Command Line Tools is installed on this machine."
        case .androidDeveloperToolsMissing:
            return "Android developer environment not setup correctly. Are things added to $PATH?"
        }
    }
}

Group {
    // eventually it would be nice to support "templates" for example a demo project with support for sqlite.
    // templates: sqlite, reaktive,
    $0.command("init",
               Argument<String>("name", description: "The name to give the project"),
               Argument<String>("bundleId", description: "The company bundle prefix to use (i.e. com.doublesymmetry)"),
               Option("template", default: "kampkit")) { productName, bundleId, templateName in
        do {
            // 1. do validations
            guard bundleId.split(separator: ".").count == 2 else { throw ExecutionError.invalidIdentifier }

            print("Setting up".cyan().bold())
            let template = KaMPKit(productName: productName, bundleId: bundleId)
            defer { try? template.cleanup() }

            print("Checking environment")
            let xcodeCheckCommand = run("which", "xcodebuild")
            if !xcodeCheckCommand.succeeded { throw ExecutionError.xcodeMissing  }

            let androidStudioCheck = run("which", "adb")
            if !androidStudioCheck.succeeded { throw ExecutionError.androidDeveloperToolsMissing  }

            print("Running template validations")
            try template.validate()

            // 2. make project directory
            print("Creating project \(productName)".cyan().bold())
            print("Creating folder \(productName)")
            try FileUtils.mkdir(name: productName).execute()

            // 3. apply template
            print("Applying template: \(templateName)".cyan().bold())
            try template.vivify()

            // 4. profit
            print("Project created.".green().bold())

            // 5. show instructions
            template.printInstructions()
        } catch {
            print("\(error)".red().bold())
            _exit(-1)
        }
    }

    $0.command("version") { print(version) }
}.run(version)
