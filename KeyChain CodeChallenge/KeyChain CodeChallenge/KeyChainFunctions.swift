//
//  KeyChainFunctions.swift
//  KeyChain CodeChallenge
//
//  Created by Vishnu Sasikumar on 25/01/24.
//

import Foundation
import Security

///Storing strings securely
func secureStore(string: String, forKey key: String) -> Bool {
    guard !string.isEmpty && !key.isEmpty else {
        return false
    }

    let queryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecValueData as String: string.data(using: .utf8)!,
                                          kSecAttrAccount as String: key.data(using: .utf8)!]

    guard let foundItem = retrieveItem(forKey: key) else {
        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("\n\tSecItemAdd() failed. Reason: \(SecCopyErrorMessageString(status, nil) as String? ?? "unknown")")
            return false
        }
        return true
    }

    if foundItem != string {
        let updateQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                              kSecAttrAccount as String: key.data(using: .utf8)!]
        let attributes: [String: Any] = [kSecValueData as String: string.data(using: .utf8)!]
        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)

        guard updateStatus == errSecSuccess else {
            print("\n\tSecItemUpdate() failed. Reason: \(SecCopyErrorMessageString(updateStatus, nil) as String? ?? "unknown")")
            return false
        }
        return true
    }
    return true
}


func retrieveItem(forKey key: String) -> String? {
    let queryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: key.data(using: .utf8)!,
                                          kSecReturnData as String: true]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(queryDictionary as CFDictionary, &item)

    guard status == errSecSuccess, let data = item as? Data else {
        return nil
    }
    return String(data: data, encoding: .utf8)
}
