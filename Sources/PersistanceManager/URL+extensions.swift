//
//  URL+extensions.swift
//  
//
//  Created by Kamaal Farah on 23/10/2020.
//

import Foundation

public extension URL {
    /// A util to find persistent container url of a app group
    /// - Parameters:
    ///   - appGroup: App group identifier
    ///   - databaseName: A self given name to access the container
    /// - Returns: URL of the given app group identifier
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
