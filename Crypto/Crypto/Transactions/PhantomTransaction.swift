// 
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

// swiftlint:disable force_try
// swiftlint:disable force_cast

import Foundation
import BitcoinKit

public class PhantomTransaction {

    // Header
    var header: UInt8?
    var version: UInt8?
    var network: UInt8?
    var type: TransactionType?
    var timestamp: UInt32?

    // Types
    var id: String?
    var senderPublicKey: String?
    var recipientId: String?
    var vendorField: String?
    var vendorFieldHex: String?
    var amount: UInt64?
    var fee: UInt64?

    // Signatures
    var signature: String?
    var secondSignature: String?
    var signSignature: String?
    var signatures: [String]?

    var expiration: UInt32?

    var asset: [String: Any]?

    public func getId() -> String {
        return Crypto.sha256(Data(bytes: self.toBytes(skipSignature: false, skipSecondSignature: false))).hex
    }

    // TODO: proper try statement
    public func sign(_ keys: PrivateKey) -> PhantomTransaction {
        self.senderPublicKey = keys.publicKey().raw.hex
        let transaction = Crypto.sha256(Data(bytes: self.toBytes()))
        self.signature = try! Crypto.sign(transaction, privateKey: keys).hex
        return self
    }

    // TODO: proper try statement
    public func secondSign(_ keys: PrivateKey) -> PhantomTransaction {
        let transaction = Crypto.sha256(Data(bytes: self.toBytes(skipSignature: false)))
        self.signSignature = try! Crypto.sign(transaction, privateKey: keys).hex
        return self
    }

    public func verify() -> Bool {
        let hash = Crypto.sha256(Data(bytes: self.toBytes(skipSignature: true, skipSecondSignature: true)))

        do {
            return try Crypto.verifySignature(Data.init(hex: self.signature!)!,
                                          message: hash,
                                          publicKey: Data.init(hex: self.senderPublicKey!)!)
        } catch {
            return false
        }
    }

    // Needs to pass along the public key of the second signature
    public func secondVerify(publicKey: String) -> Bool {
        let hash = Crypto.sha256(Data(bytes: self.toBytes(skipSignature: false, skipSecondSignature: true)))

        do {
            return try Crypto.verifySignature(Data.init(hex: self.signSignature!)!,
                                              message: hash,
                                              publicKey: Data.init(hex: publicKey)!)
        } catch {
            return false
        }
    }

    public func toBytes(skipSignature: Bool = true, skipSecondSignature: Bool = true) -> [UInt8] {
        var bytes = [UInt8]()
        bytes.append(UInt8.init(self.type!.rawValue))
        var timestampBytes = pack(self.timestamp)
        timestampBytes.removeLast() // Timestamp is 32bits (5 bytes), but only 4 bytes serialized
        bytes.append(contentsOf: timestampBytes)
        bytes.append(contentsOf: [UInt8](Data.init(hex: self.senderPublicKey!)!))

        let skipRecipient = self.type == .secondSignatureRegistration || self.type == .multiSignatureRegistration
        if !skipRecipient && recipientId != nil {
            bytes.append(contentsOf: base58CheckDecode(recipientId!)!)
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 21))
        }

        if vendorField != nil && (vendorField?.count)! <= 64 {
            bytes.append(contentsOf: [UInt8](vendorField!.data(using: .utf8)!))
            bytes.append(contentsOf: [UInt8](repeating: 0, count: (64 - (vendorField?.count)!)))
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 64))
        }

        var transactionBytes = pack(self.amount)
        transactionBytes.removeLast()
        bytes.append(contentsOf: transactionBytes)

        var feeBytes = pack(self.fee)
        feeBytes.removeLast()
        bytes.append(contentsOf: feeBytes)

        if self.type == .secondSignatureRegistration {
            if let signature = self.asset!["signature"] as? [String: String] {
                let publickey = signature["publicKey"]
                bytes.append(contentsOf: [UInt8](Data.init(hex: publickey!)!))
            }
        } else if self.type == .delegateRegistration {
            if let delegate = self.asset!["delegate"] as? [String: String] {
                let username = delegate["username"]!
                bytes.append(contentsOf: [UInt8](username.data(using: .utf8)!))
            }
        } else if self.type == .vote {
            if let votes = self.asset!["votes"] as? [String] {
                bytes.append(contentsOf: [UInt8](votes.joined().data(using: .utf8)!))
            }
        } else if self.type == .multiSignatureRegistration {
            if let multisig = self.asset!["multisignature"] as? [String: Any] {
                let min = multisig["min"] as! UInt8
                let lifetime = multisig["lifetime"] as! UInt8
                let keys = multisig["keysgroup"] as! [String]
                bytes.append(min)
                bytes.append(lifetime)
                bytes.append(contentsOf: [UInt8](keys.joined().data(using: .utf8)!))
            }
        }

        if !skipSignature && self.signature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.signature!)!))
        }

        if !skipSecondSignature && self.secondSignature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.secondSignature!)!))
        }

        return bytes
    }

    public func toDict() -> [String: Any] {
        var transactionDict: [String: Any] = [:]
        if let amount = self.amount {
            transactionDict["amount"] = amount
        }
        if let fee = self.fee {
            transactionDict["fee"] = fee
        }
        if let asset = self.asset {
            transactionDict["asset"] = asset
        }
        if let id = self.id {
            transactionDict["id"] = id
        }
        if let network = self.network {
            transactionDict["network"] = network
        }
        if let recipientId = self.recipientId {
            transactionDict["recipientId"] = recipientId
        }
        if let secondSignature = self.secondSignature {
            transactionDict["secondSignature"] = secondSignature
        }
        if let senderPublicKey = self.senderPublicKey {
            transactionDict["senderPublicKey"] = senderPublicKey
        }
        if let signature = self.signature {
            transactionDict["signature"] = signature
        }
        if let signatures = self.signatures {
            transactionDict["signatures"] = signatures
        }
        if let signSignature = self.signSignature {
            transactionDict["signSignature"] = signSignature
        }
        if let timestamp = self.timestamp {
            transactionDict["timestamp"] = timestamp
        }
        if let type = self.type {
            transactionDict["type"] = type.rawValue
        }
        if let vendorField = self.vendorField {
            transactionDict["vendorField"] = vendorField
        }
        if let vendorFieldHex = self.vendorFieldHex {
            transactionDict["vendorFieldHex"] = vendorFieldHex
        }
        if let version = self.version {
            transactionDict["version"] = version
        }

        return transactionDict
    }

    public func toJson() -> String? {
        let txDict = self.toDict()

        do {
            // Serialize as json Data
            let jsonData = try JSONSerialization.data(withJSONObject: txDict, options: [])

            // Turn it into a String
            return String(data: jsonData, encoding: .ascii)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
