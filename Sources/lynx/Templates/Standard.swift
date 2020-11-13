//
//  File.swift
//  
//
//  Created by David Chavez on 13.11.20.
//

import Command
import FileUtils
import Foundation
import GitUtils
import XcodeBuildUtils

struct Standard: Template {
    let productName: String
    let bundleId: String
    let useSwiftUI: Bool
    let useCompose: Bool

    let repositoryUrl = "https://github.com/DoubleSymmetry/lynx.git"

    func validate() throws {
        guard Pod.canInstall() else { throw PodError.cocoapodsNotFound }
    }

    func vivify() throws {
        // 1. download template project from DS.
        try fetchRemoteTemplate()

        let templatesPath = "\(tempPath)/Templates"
        let baseTemplatePath = "\(templatesPath)/base"

        // 2. copy files to the correct places
        print("Copying files")
        let filesToCopy = ["gradlew", "gradlew.bat", "build.gradle.kts", "gradle.properties", "settings.gradle.kts"]
        try FileUtils.cp(source: filesToCopy.map { "\(baseTemplatePath)/\($0)" }, target: productName).execute()

        print("Copying folders")
        try [
            FileUtils.mkdir(name: "\(productName)/gradle", createIntermediateDirectories: true),
            FileUtils.cp(source: "\(baseTemplatePath)/gradle/wrapper", target: "\(productName)/gradle", recursive: true),
        ].execute()

        let directoriesToCopy = ["buildSrc", "app", "shared"]
        try FileUtils.cp(source: directoriesToCopy.map { "\(baseTemplatePath)/\($0)" }, target: productName, recursive: true).execute()

        let iosDirectory = useSwiftUI ? "swiftui/ios" : "uikit/ios"
        try FileUtils.cp(source: "\(templatesPath)/\(iosDirectory)", target: productName, recursive: true).execute()

        // 3. Replace template names and bundles
        let bundleParts = bundleId.split(separator: ".")
        guard bundleParts.count == 2 else { throw ExecutionError.invalidIdentifier }

        typealias ReplacePair = (replacee: String, replasor: String)

        print("Updating package names")
        var folderReplaceMap: [ReplacePair] = [
            ("lynx", productName.lowercased()),
        ]

        if "com.doublesymmetry" != bundleId {
            folderReplaceMap.append(("com", String(bundleParts.first!)))
            folderReplaceMap.append(("doublesymmetry", String(bundleParts.last!)))
        }

        try folderReplaceMap.forEach { folderPair in
            try FileUtils.findWhile(path: productName, type: "d", name: folderPair.replacee, transform: { file in
                let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]\(folderPair.replacee)[[:>:]]/\(folderPair.replasor)/").description
                try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
            }).execute()
        }

        print("Updating file names")
        try FileUtils.findWhile(path: productName, type: "d", name: "Lynx.xcodeproj", transform: { file in
            let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]Lynx[[:>:]]/\(productName)/").description
            try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
        }).execute()

        print("Updating app name")
        let packageName = "\(bundleId).\(productName.lowercased())"
        let stringInFileReplaceMap: [ReplacePair] = [
            ("com.doublesymmetry.lynx", packageName),
            ("Lynx", productName),
            ("LYNX_SETTINGS", "\(productName.uppercased())_SETTINGS"),
        ]

        try FileUtils.findWhile(path: productName, type: "f", transform: { file in
            try stringInFileReplaceMap.forEach {
                try FileUtils.sed(
                    script: "s/[[:<:]]\($0.replacee)[[:>:]]/\($0.replasor)/g",
                    file: file,
                    editInPlace: true
                ).execute()
            }
        }).execute()

        // 4. run pod install
        print("Installing iOS dependencies".cyan().bold())
        let iosRoot = "\(productName)/ios"

        let podInstall = [FileUtils.cd(directory: iosRoot), Pod.install()]

        // We will pod install twice because of a bug in how the shared cocoapod is setup.
        // The framework itself doesn't get generated until the first build
        // so we pod install once to generate the .xcworkspace in order to
        // then try to build the project to generate the framework.
        // We then do a pod install again to actually import that framework into the project.
        print("Running pod install")
        try podInstall.execute()

        print("Warming up shared framework" + " (this may take a few minutes)".dim())
        try [
            FileUtils.cd(directory: iosRoot),
            XcodeBuildUtils.build(sdk: "iphonesimulator", workspace: "\(productName).xcworkspace", scheme: "Lynx", destination: "'platform=iOS Simulator,name=iPhone 11 Pro'"),
        ].execute(ignoreFailure: true)

        try podInstall.execute()

        // 5. update scheme - this must happen after the pod install - for reasons.
        print("Updating scheme name")
        try FileUtils.findWhile(path: productName, type: "f", name: "*.xcscheme", transform: { file in
            let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]Lynx[[:>:]]/\(productName)/").description
            try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
        }).execute()
    }
}

