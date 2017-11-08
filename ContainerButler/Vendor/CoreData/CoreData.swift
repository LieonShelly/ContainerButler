//
//  CoreData.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "ContainerButler", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataSwift.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        if #available(iOS 10.0, *) {
            
            return self.persistentContainer.viewContext
        } else {
            let coordinator = self.persistentStoreCoordinator
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }
        
    }()
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContainerButler")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

// Save UserSeesionInfo

extension CoreDataManager {
    func save(userSession: UserSessionInfo) {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            guard let sessionInfo: Session = NSEntityDescription.insertNewObject(forEntityName: "Session", into: self.managedObjectContext) as? Session else {  return  }
                sessionInfo.token = userSession.token
        } else {
            for info in searchResulst {
                info.token = userSession.token
            }
        }
        saveContext()
    }
    
    func getSessionInfo() -> UserSessionInfo? {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return nil
        }
        guard let info = searchResulst.last else {
            return nil
        }
        let session = UserSessionInfo()
        session.token = info.token
        return session
    }
    
    func clearSessionInfo() {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            return
        }
        for user in searchResulst {
            managedObjectContext.delete(user)
        }
        saveContext()
    }
}

// Save UserInfo
extension CoreDataManager {
    func save(userInfo: UserInfo, phoneNum: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if !searchResulst.isEmpty {
            for info in searchResulst {
                info.userId = userInfo.userId
                info.phoneNum = phoneNum
            }
        } else {
            guard let info: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext) as? User else {  return  }
            info.userId = userInfo.userId
            info.phoneNum = phoneNum
        }
        saveContext()
    }
    
    func getUserInfo() -> UserInfo? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return nil
        }
        guard let info = searchResulst.last else {
            return nil
        }
        let userInfo = UserInfo()
        userInfo.userId = info.userId
         userInfo.phoneNum = info.phoneNum
        return userInfo
    }
    
    func clearUserInfo() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            return
        }
        for user in searchResulst {
            managedObjectContext.delete(user)
        }
        saveContext()
    }
}

extension CoreDataManager {
    func save(goods: Goods, containerId: Int) {
        guard let cachedGoods: CachGoods = NSEntityDescription.insertNewObject(forEntityName: "CachGoods", into: self.managedObjectContext) as? CachGoods else {  return }
        cachedGoods.goodsSn = goods.goodsSn
        cachedGoods.goodsName = goods.goodsName
        cachedGoods.goodsPic = goods.goodsPic
        cachedGoods.waitSupplyCount = Int16(goods.waitSupplyCount)
        cachedGoods.remainCount = Int16(goods.remainCount)
        cachedGoods.channelSn = goods.channelSn
        cachedGoods.containerId = Int16(containerId)
        cachedGoods.supplementId = Int16(goods.supplementId)
        cachedGoods.supplyCount = Int16(goods.supplyCount)
        cachedGoods.isSupplied = goods.isSupplied
        saveContext()
    }
    
    func getGoodsList(containerId: Int) -> [Goods]? {
        let fetchRequest: NSFetchRequest<CachGoods> = CachGoods.fetchRequest()
       fetchRequest.predicate = NSPredicate(format: "containerId=%d", containerId)
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return nil
        }
        var goodslist: [Goods] = [Goods]()
        for cachedGoods in searchResulst {
            let goods = Goods()
            goods.goodsSn = cachedGoods.goodsSn
            goods.goodsName = cachedGoods.goodsName
            goods.goodsPic = cachedGoods.goodsPic
            goods.waitSupplyCount = Int(cachedGoods.waitSupplyCount)
            goods.remainCount = Int(cachedGoods.remainCount)
            goods.channelSn = cachedGoods.channelSn
            goods.supplementId = Int(cachedGoods.supplementId)
            goods.supplyCount = Int(cachedGoods.supplyCount)
            goods.isSupplied = cachedGoods.isSupplied
            goodslist.append(goods)
        }
        return goodslist
    }
    func getGoods(containerId: Int, supplementId: Int) -> Goods? {
        let fetchRequest: NSFetchRequest<CachGoods> = CachGoods.fetchRequest()
        let predicate1 =  NSPredicate(format: "containerId=%@", "\(containerId)")
        let predicate2 =  NSPredicate(format: "supplementId=%@", "\(supplementId)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest), let cachedGoods = searchResulst.last else {
            return nil
        }
        let goods = Goods()
        goods.goodsSn = cachedGoods.goodsSn
        goods.goodsName = cachedGoods.goodsName
        goods.goodsPic = cachedGoods.goodsPic
        goods.waitSupplyCount = Int(cachedGoods.waitSupplyCount)
        goods.remainCount = Int(cachedGoods.remainCount)
        goods.channelSn = cachedGoods.channelSn
        goods.supplementId = Int(cachedGoods.supplementId)
        goods.supplyCount = Int(cachedGoods.supplyCount)
        goods.isSupplied = cachedGoods.isSupplied
        return goods
    }
    
    func deleteGoods(containerId: Int, supplementId: Int?) {
       let fetchRequest: NSFetchRequest<CachGoods> = CachGoods.fetchRequest()
        if let supplementId =  supplementId {
        let predicate1 =  NSPredicate(format: "containerId=%@", "\(containerId)")
        let predicate2 =  NSPredicate(format: "supplementId=%@", "\(supplementId)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
            guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
                return
            }
            searchResulst.forEach {
                managedObjectContext.delete($0)
                print("containerId:\($0.containerId), goodsName:\($0.goodsName ?? "")")
            }

        } else {
            fetchRequest.predicate = NSPredicate(format: "containerId=%d", containerId)
            guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
                return
            }
            searchResulst.forEach {managedObjectContext.delete($0)}
        }
        saveContext()
    }
}

extension CoreDataManager {
    
}
