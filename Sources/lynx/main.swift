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

let version = "0.0.1"

enum ExecutionError: Error, CustomStringConvertible {
    case invalidIdentifier

    var description: String {
        switch self {
        case .invalidIdentifier:
            return "The bundle identifier prefix is invalid. Example: com.doublesymmetry"
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
        // 0. get chosen template
        let template = KaMPKit(productName: productName, bundleId: bundleId)
        defer { try? template.cleanup() }

        do {
            // 1. do validations
            guard bundleId.split(separator: ".").count == 2 else { throw ExecutionError.invalidIdentifier }

            print("Creating project \(productName)".cyan().bold())
            // 2. make project directory
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

    $0.command("version") {
        print(version)
    }
}.run(version)
