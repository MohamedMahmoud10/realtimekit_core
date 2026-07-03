//
//  CallDetailsBuilder.swift
//  dyte_core_ios
//
//  Created by Saksham Gupta on 10/03/23.
//

import Foundation

class CallDetailsBuilder {
    private var callDetails: [String: Any?] = [:]

    func addMethodName(name: String) -> CallDetailsBuilder {
        callDetails["name"] = name
        return self
    }

    func addArguments(args: [String: Any?]) -> CallDetailsBuilder {
        callDetails["args"] = args
        return self
    }

    func flush() -> CallDetailsBuilder {
        callDetails.removeAll()
        return self
    }

    func build() -> [String: Any?] {
        if !callDetails.keys.contains("args") {
            callDetails["args"] = nil
        }
        return callDetails
    }
}
