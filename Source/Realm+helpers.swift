//
//  Realm+fieldsValidation.swift
//  Tracker
//
//  Created by Anton Belousov on 10.04.2018.
//  Copyright © 2018 kp. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Validation

@objc public protocol ValidatableObject {
    init(fields: [String: Any]) throws
    func updateWith(fields: [String: Any]) throws
}

extension Realm {
    
    // TODO: try rename
    /*
     @discardableResult
     func сreate<T: Object & ValidatableObject>(_ type: T.Type, update: Bool = false, value: [String: Any] = [:]) throws -> T {
     }
    */
    @discardableResult
    public func сreateWithValidation<T: Object & ValidatableObject>(_ type: T.Type, update: Bool = false, value: [String: Any] = [:]) throws -> T {
        
        // First, we check that the object can be created, e.g. fields validation
        let newTmpObject = try (type as ValidatableObject.Type).init(fields: value) as! T
        
        if !update {
            add(newTmpObject)
            return newTmpObject
        }
        
        let typeName = type.className()
        guard let pkPropertyName = schema[typeName]?.primaryKeyProperty?.name else {
            fatalError("use `update` only for objects with primary key")
        }
        
        guard let pk = newTmpObject.value(forKey: pkPropertyName) else {
            fatalError("you should provide primary key in `value`")
        }
        
        if let existingObject = object(ofType: T.self, forPrimaryKey: pk) {
            try existingObject.updateWith(fields: value)
            return existingObject
        }
        
        add(newTmpObject)
        return newTmpObject
    }
}

// MARK: - Sugar
extension Results {
    public func objectWithPrimaryKey(_ pk: Any) -> Element? {
        if let type = Element.self as? Object.Type,
            let primaryKeyName = type.primaryKey() {
            return filter("%K == %@", primaryKeyName, pk).first
        }
        return nil
    }
}

extension Realm {
    public static func write(block: (Realm) throws -> (), onFail: (Swift.Error) -> () = {_ in}) {
        do {
            let realm = try Realm()
            try realm.write {
                try block(realm)
            }
        } catch {
            onFail(error)
        }
    }
   
    public func object<Element: Object, KeyType>(ofType type: Element.Type, forPrimaryKeys keys: Set<KeyType>) -> [Element] {
        return keys.compactMap{ object(ofType: type, forPrimaryKey: $0) }
    }
    
    public func object<Element: Object, KeyType>(ofType type: Element.Type, forPrimaryKeys keys: [KeyType]) -> [Element] {
        return keys.compactMap{ object(ofType: type, forPrimaryKey: $0) }
    }
}
