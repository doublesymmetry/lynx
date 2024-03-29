import ProjectDescription

let project = Project(name: "Lynx",
                      packages: [],
                      targets: [
                        Target(name: "Lynx",
                               platform: .iOS,
                               product: .app,
                               bundleId: "com.doublesymmetry.lynx${BUNDLE_SUFFIX}",
                               infoPlist: "Info.plist",
                               sources: ["Sources/**"],
                               resources: [
                                       /* Path to resouces can be defined here */
                                       "Resources/**"
                               ],
                               actions: [],
                               dependencies: [
                                    /* Target dependencies can be defined here */
                                    .cocoapods(path: "."),
                                ],
                                settings: Settings(base: [
                                    "SWIFT_OBJC_BRIDGING_HEADER": "Sources/Bridging-Header.h"
                                    ], debug: Configuration(settings: [
                                        "BUNDLE_SUFFIX": ".debug",
                                        "HOST_URL": "https://cat-fact.herokuapp.com",
                                        "PRODUCT_DISPLAY_NAME": "Lynx <T>",
                                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDebug"
                                    ]), release: Configuration(settings: [
                                        "BUNDLE_SUFFIX": "",
                                        "HOST_URL": "https://cat-fact.herokuapp.com",
                                        "PRODUCT_DISPLAY_NAME": "Lynx",
                                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
                                    ])
                                ))
                      ])
