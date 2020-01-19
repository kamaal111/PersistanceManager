
import CoreData

/**
 * This singleton class manages the core data activities
 */
@available(iOS 10.0, OSX 10.12, watchOS 3.0, tvOS 10.0, *)
public class PersistanceManager {
    public var containerName: String

    public init(containerName: String) {
        self.containerName = containerName
        print("initializing persistance manager")
    }

    /// Get persistent containers view context
    public lazy var context = persistentContainer.viewContext

    /// Persistent container
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    /// Save core data entry
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("saved context succesfully")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    /**
     * Fetches from persistent container and returns a array of managed objects
     * - Parameters:
     *      - objectType: The objects type to determine what the type of the managed objects are
     * - Returns: An array of managed objects
     */
    public func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fecthedObjects = try context.fetch(fetchRequest) as? [T]
            return fecthedObjects ?? []
        } catch {
            print(error)
            return []
        }
    }

    /**
     * Delete managed object
     * - Parameters:
     *      - object: The managed object
     */
    public func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
}
