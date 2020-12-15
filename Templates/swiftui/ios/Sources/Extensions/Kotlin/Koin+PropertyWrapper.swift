//
//  Koin+PropertyWrapper.swift
//  OneBeat
//
//  Created by David Chavez on 29.11.20.
//

import shared

fileprivate class StringQualifier: Koin_coreQualifier {
    let value: String

    init(value: String) {
        self.value = value
    }
}

@propertyWrapper
struct Inject<T: AnyObject> {
    private var qualifier: String?
    private var parameter: Any?
    private let queue = DispatchQueue(label: "com.doublesymmetry.\(UUID().uuidString)", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global())

    var wrappedValue: T {
        get {
            if let qualifier = qualifier, let parameter = parameter {
                return queue.sync { KoinIOS().get(objCClass: T.self, qualifier: StringQualifier(value: qualifier), parameter: parameter) as! T }
            } else if let parameter = parameter {
                return queue.sync { KoinIOS().get(objCClass: T.self, parameter: parameter) as! T }
            } else if let qualifier = qualifier {
                return queue.sync { KoinIOS().get(objCClass: T.self, qualifier: StringQualifier(value: qualifier)) as! T }
            } else {
                return queue.sync { KoinIOS().get(objCClass: T.self, qualifier: nil) as! T }
            }
        }
    }

    init() {
        qualifier = nil
        parameter = nil
    }

    init(parameter: Any) {
        qualifier = nil
        self.parameter = parameter
    }

    init(qualifier: String) {
        self.qualifier = qualifier
        parameter = nil
    }

    init(qualifier: String?, parameter: Any?) {
        self.qualifier = qualifier
        self.parameter = parameter
    }
}
