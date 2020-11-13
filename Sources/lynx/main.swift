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

let version = "1.0.0"
let tempPath = ".temp"

enum ExecutionError: Error, CustomStringConvertible {
    case invalidIdentifier
    case xcodeMissing
    case javaMissing
    case invalidTemplate

    var description: String {
        switch self {
        case .invalidIdentifier:
            return "The bundle identifier prefix is invalid. Example: com.doublesymmetry"
        case .xcodeMissing:
            return "Xcode nor Xcode Command Line Tools is installed on this machine."
        case .javaMissing:
            return "Java is not setup correctly."
        case .invalidTemplate:
            return "A template that does not exists was used. Available options are: \(availableTemplates)"
        }
    }
}

let availableTemplates = TemplateOption.allCases.map { $0.rawValue }.joined(separator: ", ")
enum TemplateOption: String, CaseIterable {
    case kampkit
}

Group {
    // eventually it would be nice to support "templates" for example a demo project with support for sqlite.
    // templates: sqlite, reaktive,
    $0.command("init",
               Argument<String>("name", description: "The name to give the project"),
               Argument<String>("bundleId", description: "The company bundle prefix to use (i.e. com.doublesymmetry)"),
               Flag("use-swiftui", default: false, description: "Whether the generated iOS project should use SwiftUI"),
               Flag("use-compose", default: false, description: "Whether the generated Android project should use Jetpack Compose"),
               Option<String?>("template", default: nil, description: "A third party template to use - options are: \(availableTemplates)")
    ) { productName, bundleId, useSwiftUI, useCompose, templateName in
        do {
            // 1. do validations
            guard bundleId.split(separator: ".").count == 2 else { throw ExecutionError.invalidIdentifier }

            if templateName != nil && (useSwiftUI || useCompose) {
                print("Third-party templates do not support the --use-swiftui or --use-compose flags. ignoring...".yellow().bold())
            }

            var template: Template = Standard(productName: productName, bundleId: bundleId, useSwiftUI: useSwiftUI, useCompose: useCompose)
            if let templateName = templateName {
                guard let templateOption = TemplateOption.init(rawValue: templateName) else {
                    throw ExecutionError.invalidTemplate
                }

                switch templateOption {
                case .kampkit:
                    template = KaMPKit(productName: productName, bundleId: bundleId)
                }
            }

            print("Setting up".cyan().bold())
            defer { try? template.cleanup() }

            print("Checking environment")
            let xcodeCheckCommand = run("which", "xcodebuild")
            if !xcodeCheckCommand.succeeded { throw ExecutionError.xcodeMissing  }

            let javaCheck = run("which", "java")
            if !javaCheck.succeeded { throw ExecutionError.javaMissing  }

            print("Running template validations")
            try template.validate()

            // 2. make project directory
            print("Creating project \(productName)".cyan().bold())
            print("Creating folder \(productName)")
            try FileUtils.mkdir(name: productName).execute()

            // 3. apply template
            print("Generating project...".cyan().bold())
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
