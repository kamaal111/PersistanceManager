import CoreData

/**
 * This class manages the core data activities
 */
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@available(iOS 13.0, OSX 10.15, *)
public class PersistanceManager {
    public var container: NSPersistentContainer?

    /// Initialize local persistent container
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    public func setupNewContainer(container: NSPersistentContainer) {
        self.container = container
    }

    /// Get persistent containers view context
    public lazy var context = container?.viewContext

    /// Save core data entry
    /// - Throws: `SaveContextErrors.contextSave(errorObject: NSError)`
    ///             if the object could not get saved
    public func save() throws {
        guard let context = self.context else { throw SaveContextErrors.contextIsUnavailable }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                throw SaveContextErrors.contextSave(errorObject: nserror)
            }
        }
    }

    /// Fetches from persistent container and returns a array of managed objects
    /// - Parameters:
    ///     - objectType: The objects type to determine what the type of the managed objects are
    /// - Throws: `FetchContextErrors.contextFetch`
    ///             if the array of objects could not get fetched from the context container
    /// - Returns: An array of `managed objects`
    public func fetch<T: NSManagedObject>(_ objectType: T.Type) throws -> [T]? {
        guard let context = self.context else { return nil }
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fecthedObjects = try context.fetch(fetchRequest) as? [T]
            return fecthedObjects
        } catch {
            throw FetchContextErrors.contextFetch
        }
    }

    /// Delete managed object
    /// - Parameters:
    ///     - object: The managed object
    /// - Throws: `SaveContextErrors.couldNotSaveContext`
    ///             if the object could not get saved after deletion
    /// - Returns: void
    public func delete(_ object: NSManagedObject) throws {
        context?.delete(object)
        do {
            try save()
        } catch {
            throw SaveContextErrors.couldNotSaveContext
        }
    }
}

/// An enum of posible context save errors
public enum SaveContextErrors: Error {
    case contextSave(errorObject: NSError)
    case contextIsUnavailable
    case couldNotSaveContext
}

/// An enum of posible context fetch errors
public enum FetchContextErrors: Error {
    case contextFetch
}
