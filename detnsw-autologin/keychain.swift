//
//  keychain.swift
//  detnsw-autologin
//
//  Created by Levi Rigger on 25/7/2022.
//

import Foundation
import AuthenticationServices

func kupdate(_ data: Data, service: String, account: String) {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
        
    let updatedData = [kSecValueData: data] as CFDictionary
    SecItemUpdate(query, updatedData)
}

func ksave(_ data: Data, service: String, account: String) {
    let query = [
        kSecValueData: data,
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
        
    let saveStatus = SecItemAdd(query, nil)
 
    if saveStatus != errSecSuccess {
        print("Error: \(saveStatus)")
    }
    
    if saveStatus == errSecDuplicateItem {
        kupdate(data, service: service, account: account)
    }
}

func kread(service: String, account: String) -> Data? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecReturnData: true
    ] as CFDictionary
        
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    return result as? Data
}

func kdelete(service: String, account: String) {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
        
    SecItemDelete(query)
}
