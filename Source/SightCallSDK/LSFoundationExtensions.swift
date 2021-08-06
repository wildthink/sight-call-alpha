//
//  LSFoundationExtensions.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 3/19/21.
//

import Foundation

public extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

public extension URL {
    
    func queryValueForKey(_ key: String) -> String? {
        guard let components = NSURLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.queryItems?
            .filter { $0.name == key }
            .first?.value

//        guard let queryItems = components.queryItems else { return nil }
//        return queryItems.filter {
//            $0.name == key
//        }.first?.value
    }
}
