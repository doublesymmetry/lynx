//
//  KaMPKit.swift
//  lynx
//
//  Created by David Chavez on 24.09.20.
//

import Command
import FileUtils
import Foundation
import GitUtils
import XcodeBuildUtils

struct KaMPKit: Template {
    let productName: String
    let bundleId: String

    let repositoryUrl = "https://github.com/touchlab/KaMPKit.git"

    func validate() throws {
        guard Pod.canInstall() else { throw PodError.cocoapodsNotFound }
    }

    func vivify() throws {
        // 1. download KMP template project from DS.
        try fetchRemoteTemplate()

        let templatePath = "\(tempPath)"

        // 2. copy files to the correct places
        print("Copying files")
        let filesToCopy = ["gradlew", "gradlew.bat", "build.gradle.kts", "gradle.properties", "settings.gradle.kts"]
        try FileUtils.cp(source: filesToCopy.map { "\(templatePath)/\($0)" }, target: productName).execute()

        print("Copying folders")
        try [
            FileUtils.mkdir(name: "\(productName)/gradle", createIntermediateDirectories: true),
            FileUtils.cp(source: "\(templatePath)/gradle/wrapper", target: "\(productName)/gradle", recursive: true),
        ].execute()

        let directoriesToCopy = ["buildSrc", "app", "ios", "shared"]
        try FileUtils.cp(source: directoriesToCopy.map { "\(templatePath)/\($0)" }, target: productName, recursive: true).execute()

        // 3. Replace template names and bundles
        let bundleParts = bundleId.split(separator: ".")
        guard bundleParts.count == 2 else { throw ExecutionError.invalidIdentifier }

        typealias ReplacePair = (replacee: String, replasor: String)

        print("Updating package names")
        let folderReplaceMap: [ReplacePair] = [
            ("co", String(bundleParts.first!)),
            ("touchlab", String(bundleParts.last!)),
            ("kampkit", productName.lowercased()),
            ("KaMPKitiOS", productName),
        ]

        try folderReplaceMap.forEach { folderPair in
            try FileUtils.findWhile(path: productName, type: "d", name: folderPair.replacee, transform: { file in
                let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]\(folderPair.replacee)[[:>:]]/\(folderPair.replasor)/").description
                try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
            }).execute()
        }

        print("Updating file names")
        try FileUtils.findWhile(path: productName, type: "d", name: "KaMPKitiOS.xcodeproj", transform: { file in
            let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]KaMPKitiOS[[:>:]]/\(productName)/").description
            try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
        }).execute()

        print("Updating app name")
        let packageName = "\(bundleId).\(productName.lowercased())"
        let stringInFileReplaceMap: [ReplacePair] = [
            ("co.touchlab.kampkit", packageName),
            ("KaMPKitiOS", productName),
            ("KaMPKitDb", "\(productName)Db"),
            ("KampkitDb", "\(productName.lowercased().capitalized)Db"),
            ("kampkitdb", productName.lowercased()),
            ("KaMPKit", productName),
            ("KampKit", productName),
            ("KAMPKIT_SETTINGS", "\(productName.uppercased())_SETTINGS"),
            ("KaMP Kit", productName),
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

        print("Removing unnecessary files")
        let filesToRemove = ["KaMPKitiOSTests", "KaMPKitiOSUITests", "KaMPKitiOS.xcworkspace"]
        try filesToRemove.forEach {
            try FileUtils.rm(file: "\(productName)/ios/\($0)", force: true, verbose: false, recursive: true).execute()
        }

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
            XcodeBuildUtils.build(sdk: "iphonesimulator", workspace: "\(productName).xcworkspace", scheme: "KaMPKit", destination: "'platform=iOS Simulator,name=iPhone 11 Pro'"),
        ].execute(ignoreFailure: true)

        try podInstall.execute()

        // 5. update scheme - this must happen after the pod install - for reasons.
        print("Updating scheme name")
        try FileUtils.findWhile(path: productName, type: "f", name: "*.xcscheme", transform: { file in
            let rawSedCommand = FileUtils.sed(script: "s/[[:<:]]KaMPKit[[:>:]]/\(productName)/").description
            try FileUtils.mv(source: file, target: "$(echo '\(file)' | \(rawSedCommand))", force: true).execute()
        }).execute()
    }
}
