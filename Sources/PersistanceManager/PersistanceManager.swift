//
//  PersistanceManager.swift
//
//
//  Created by Kamaal Farah on 19/01/2020.
//

import CoreData

// - MARK: Initializer and variables

/**
 * An class with CoreData helper functions
 */
@available(iOS 10.0, macOS 10.12, *)
public class PersistanceManager {
    public var container: NSPersistentContainer?

    /// Initialize local persistent container
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    /// Get persistent containers view context
    public lazy var context = container?.viewContext
}

// - MARK: API

public extension PersistanceManager {
    /// Replace current persistent container with another persistent container
    /// - Parameter container: The container that will be used
    func setupNewContainer(container: NSPersistentContainer) {
        self.container = container
    }

    /// Save core data entry
    /// - Throws: `PersistanceManager.PersistanceManagerErrors.contextIsUnavailable`
    ///             if the object could not get saved
    func save() throws {
        guard let context = self.context else {
            throw PersistanceManager.PersistanceManagerErrors.contextIsUnavailable
        }
        if context.hasChanges {
            try context.save()
        }
    }

    /// Fetches from persistent container and returns a array of managed objects
    /// - Parameters:
    ///     - objectType: The objects type to determine what the type of the managed objects are
    /// - Returns: An result of an array of `managed objects` or an error
    ///
    /// For example:
    ///  ```swift
    ///  let result = fetch(OwnManagedObject.self)
    ///  switch result {
    ///  case .failure(let error): // handle error
    ///  case .success(let objects): // handle objects
    ///  }
    ///  ```
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> Result<[T]?, Error> {
        guard let context = self.context else {
            return .failure(PersistanceManager.PersistanceManagerErrors.contextIsUnavailable)
        }
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fecthedObjects = try context.fetch(fetchRequest) as? [T]
            return .success(fecthedObjects)
        } catch {
            return .failure(error)
        }
    }

    /// Delete managed object
    /// - Parameters:
    ///     - object: The managed object
    /// - Throws: an `Error` if the object could not get saved after deletion
    func delete(_ object: NSManagedObject) throws {
        guard let context = self.context else {
            throw PersistanceManager.PersistanceManagerErrors.contextIsUnavailable
        }
        context.delete(object)
        try save()
    }
}

// - MARK: Errors

public extension PersistanceManager {
    /// An enum of posible errors
    enum PersistanceManagerErrors: Error {
        case contextIsUnavailable
    }
}

public extension PersistanceManager.PersistanceManagerErrors {
    var errorDescription: String? {
        switch self {
        case .contextIsUnavailable:
            return "Context could not be found"
        }
    }
}
