import ProjectDescription

let project = Project(name: "KaMPKit",
                      packages: [],
                      targets: [
                        Target(name: "KaMPKit",
                               platform: .iOS,
                               product: .app,
                               bundleId: "co.touchlab.kampkit${BUNDLE_SUFFIX}",
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
                                        "HOST_URL": "https://dog.ceo",
                                        "PRODUCT_DISPLAY_NAME": "KaMPKit <T>",
                                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDebug"
                                    ]), release: Configuration(settings: [
                                        "BUNDLE_SUFFIX": "",
                                        "HOST_URL": "https://dog.ceo",
                                        "PRODUCT_DISPLAY_NAME": "KaMPKit",
                                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
                                    ])
                                ))
                      ])
