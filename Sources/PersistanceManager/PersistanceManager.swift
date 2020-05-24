import CoreData

/**
 * This class manages the core data activities
 */
#if os(iOS)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@available(iOS 13.0, OSX 10.15, *)
public class PersistanceManager {
    public var container: NSPersistentContainer?
    public var cloudContainer: NSPersistentCloudKitContainer?

    /// Initialize local persistent container
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    /// Initialize cloud persistent container
    public init(cloudContainer: NSPersistentCloudKitContainer) {
        self.cloudContainer = cloudContainer
    }

    /// Get persistent containers view context
    public lazy var context = container?.viewContext

    /// - ToDo: Update documentation
    /// Save core data entry
    public func save() throws {
        guard let context = context else { throw SaveContextErrors.contextIsUnavailable }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                throw SaveContextErrors.contextSave(errorObject: nserror)
            }
        }
    }

    /// - ToDo: Update documentation
    /**
     * Fetches from persistent container and returns a array of managed objects
     * - Parameters:
     *      - objectType: The objects type to determine what the type of the managed objects are
     * - Returns: An array of managed objects
     */
    public func fetch<T: NSManagedObject>(_ objectType: T.Type) throws -> [T]? {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fecthedObjects = try context?.fetch(fetchRequest) as? [T]
            return fecthedObjects
        } catch {
            throw FetchContextErrors.contextFetch
        }
    }

    /// - ToDo: Update documentation
    /**
     * Delete managed object
     * - Parameters:
     *      - object: The managed object
     */
    public func delete(_ object: NSManagedObject) throws {
        context?.delete(object)
        do {
            try save()
        } catch {
            throw SaveContextErrors.couldNotSaveContext
        }
    }
}
#endif

/// - ToDo: Add documentation
public enum SaveContextErrors: Error {
    case contextSave(errorObject: NSError)
    case contextIsUnavailable
    case couldNotSaveContext
}

/// - ToDo: Add documentation
public enum FetchContextErrors: Error {
    case contextFetch
}
