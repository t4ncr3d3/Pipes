//
//  Created by Jason Larsen on 5/18/15.
//

import Foundation

//
// MARK: Sequence
//

public func map<S: SequenceType, T>(f: S.Generator.Element->T) -> (S) -> [T] {
    return { (seq: S) -> [T] in
        return seq.map(f)
    }
}

public func filter<S: SequenceType>(f: S.Generator.Element->Bool) -> (S) -> [S.Generator.Element] {
    return { (seq: S) -> [S.Generator.Element] in
        return seq.filter(f)
    }
}

// removed @noescape
public func reduce<S : SequenceType, U>(initial: U, f: (U, S.Generator.Element) -> U) -> (S) -> U {
    return { (seq: S) -> U in
        return seq.reduce(initial, combine: f)
    }
}

//
// MARK: RangeReplaceableCollectionType
//

public func extend<S: SequenceType, C: RangeReplaceableCollectionType where S.Generator.Element == C.Generator.Element>(var collection: C, newElements: S) -> C {
    collection.appendContentsOf(newElements)
    return collection
}

public func extend<S: SequenceType, C: RangeReplaceableCollectionType where S.Generator.Element == C.Generator.Element>(newElements: S) -> (C) -> C {
    return { (collection: C) -> C in
        return extend(collection, newElements: newElements)
    }
}

public func append<C: RangeReplaceableCollectionType>(var collection: C, newElement: C.Generator.Element) -> C {
    collection.append(newElement)
    return collection
}

public func append<C: RangeReplaceableCollectionType>(newElement: C.Generator.Element) -> (C) -> C {
    return { (collection: C) -> C in
        return append(collection, newElement: newElement)
    }
}

//
// MARK: RangeReplaceableCollectionType
//

public func replaceRange<R: RangeReplaceableCollectionType, C : CollectionType where C.Generator.Element == R.Generator.Element>(var collection: R, subRange: Range<R.Index>, with newElements: C) -> R {
    collection.replaceRange(subRange, with: newElements)
    return collection
}

public func replaceRange<R: RangeReplaceableCollectionType, C : CollectionType where C.Generator.Element == R.Generator.Element>(subRange: Range<R.Index>, with newElements: C) -> (R) -> R {
    return { (collection: R) -> R in
        return replaceRange(collection, subRange: subRange, with: newElements)
    }
}

public func insert<R: RangeReplaceableCollectionType>(var collection: R, newElement: R.Generator.Element, atIndex i: R.Index) -> R {
    collection.insert(newElement, atIndex: i)
    return collection
}

public func insert<R: RangeReplaceableCollectionType>(newElement: R.Generator.Element, atIndex i: R.Index) -> (R) -> R {
    return { (collection: R) -> R in
        return insert(collection, newElement: newElement, atIndex: i)
    }
}

public func splice<R: RangeReplaceableCollectionType, S : CollectionType where S.Generator.Element == R.Generator.Element>(var collection: R, newElements: S, atIndex i: R.Index) -> R {
    collection.insertContentsOf(newElements, at: i)
    return collection
}

public func splice<R: RangeReplaceableCollectionType, S : CollectionType where S.Generator.Element == R.Generator.Element>(newElements: S, atIndex i: R.Index) -> (R) -> R {
    return { (collection: R) -> R in
        return splice(collection, newElements: newElements, atIndex: i)
    }
}

public func removeAtIndex<R: RangeReplaceableCollectionType>(var collection: R, i: R.Index) -> (R, R.Generator.Element) {
    let element = collection.removeAtIndex(i)
    return (collection, element)
}

public func removeAtIndex<R: RangeReplaceableCollectionType>(i: R.Index) -> (R) -> (R, R.Generator.Element) {
    return { (collection: R) -> (R, R.Generator.Element) in
        return removeAtIndex(collection, i: i)
    }
}

public func removeRange<R: RangeReplaceableCollectionType>(var collection: R, subRange: Range<R.Index>) -> R {
    collection.removeRange(subRange)
    return collection
}

public func removeRange<R: RangeReplaceableCollectionType>(subRange: Range<R.Index>) -> (R) -> R {
    return { (collection: R) -> R in
        return removeRange(collection, subRange: subRange)
    }
}

//
// MARK: MutableCollectionType
//

public func replace<C: MutableCollectionType>(var collection: C, newElement: C.Generator.Element, atIndex i: C.Index) -> C {
    collection[i] = newElement
    return collection
}

public func replace<C: MutableCollectionType>(newElement: C.Generator.Element, atIndex i: C.Index) -> (C) -> C {
    return { (collection: C) -> C in
        return replace(collection, newElement: newElement, atIndex: i)
    }
}

//
// MARK: Dictionary Stuff
//

/// Update the value stored in the dictionary for the given key, or, if they
/// key does not exist, add a new key-value pair to the dictionary.
///
/// Returns the new dictionary, and the value that was replaced, or `nil` if a new key-value pair
/// was added.
public func updateValue<T,U>(var dictionary: [T:U], value: U, forKey key: T) -> ([T:U], oldValue: U?) {
    let result = dictionary.updateValue(value, forKey: key)
    return (dictionary, result)
}

/// Update the value stored in the dictionary for the given key, or, if they
/// key does not exist, add a new key-value pair to the dictionary.
///
/// Returns the new dictionary, and the value that was replaced, or `nil` if a new key-value pair
/// was added.
public func updateValue<T,U>(value: U, forKey key: T) -> ([T:U]) -> ([T:U], oldValue: U?) {
    return { (dictionary: [T:U]) -> ([T:U], oldValue: U?) in
        return updateValue(dictionary, value: value, forKey: key)
    }
}

/// Returns the `Index` for the given key, or `nil` if the key is not
/// present in the dictionary.
public func getValue<T,U>(dictionary: [T:U], forKey key: T) -> U? {
    return dictionary[key]
}

/// Returns the `Index` for the given key, or `nil` if the key is not
/// present in the dictionary.
public func getValue<T,U>(forKey key: T) -> ([T:U]) -> U? {
    return { (dictionary: [T:U]) -> U? in
        return dictionary[key]
    }
}

/// Puts the given `value` under `key` in `dictionary` unless `key` already exists.
public func putNewValue<T,U>(var dictionary: [T:U], value: U, forKey key: T) -> [T:U] {
    if let _ = dictionary[key] {
        return dictionary
    }
    else {
        dictionary[key] = value
        return dictionary
    }
}

/// Puts the given `value` under `key` in `dictionary` unless `key` already exists.
public func putNewValue<T,U>(value: U, forKey key: T) -> ([T:U]) -> [T:U] {
    return { (dictionary: [T:U]) -> [T:U] in
        return putNewValue(dictionary, value: value, forKey: key)
    }
}

/// Remove a given key and the associated value from the dictionary.
/// Returns the updated dictionary and value that was removed, or `nil` if the key was not present
/// in the dictionary.
public func removeValueForKey<T,U>(var dictionary: [T:U], key: T) -> ([T:U], removed: U?) {
    let result = dictionary.removeValueForKey(key)
    return (dictionary, result)
}

/// Remove a given key and the associated value from the dictionary.
/// Returns the updated dictionary and value that was removed, or `nil` if the key was not present
/// in the dictionary.
public func removeValueForKey<T,U>(key: T) -> ([T:U]) -> ([T:U], removed: U?) {
    return { (dictionary: [T:U]) -> ([T:U], removed: U?) in
        return removeValueForKey(dictionary, key: key)
    }
}