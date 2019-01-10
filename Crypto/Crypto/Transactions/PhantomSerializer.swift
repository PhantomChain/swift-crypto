// 
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

//swiftlint:disable force_cast

import Foundation

public class PhantomSerializer {

    public static func serialize(transaction: PhantomTransaction) -> String {
        var bytes = [UInt8]()
        bytes.append(0xff)
        bytes.append(transaction.version! > 0 ? transaction.version! : 0x01)
        bytes.append(transaction.network! > 0 ? transaction.network! : PhantomNetwork.shared.get().version())
        bytes.append(UInt8.init(transaction.type!.rawValue))
        var transactionBytes = pack(transaction.timestamp)
        transactionBytes.removeLast() // Timestamp is 32bits (5 bytes), but only 4 bytes serialized
        bytes.append(contentsOf: transactionBytes)
        bytes.append(contentsOf: [UInt8](Data.init(hex: transaction.senderPublicKey!)!))
        var feeBytes = pack(transaction.fee)
        feeBytes.removeLast()
        bytes.append(contentsOf: feeBytes)

        serializeVendorField(transaction: transaction, &bytes)
        serializeType(transaction: transaction, &bytes)
        serializeSignatures(transaction: transaction, &bytes)

        return bytes.map { String(format: "%02x", $0) }.joined()
    }

    private static func serializeVendorField(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        if let vendorField = transaction.vendorField {
            let length = vendorField.count
            bytes.append(contentsOf: pack(UInt8(length)))
            bytes.append(contentsOf: [UInt8](vendorField.data(using: .utf8)!))
        } else if let vendorFieldHex = transaction.vendorFieldHex {
            let length = vendorFieldHex.count / 2
            bytes.append(contentsOf: pack(UInt8(length)))
            bytes.append(contentsOf: [UInt8](Data.init(hex: vendorFieldHex)!))
        } else {
            bytes.append(0x00)
        }
    }

    private static func serializeType(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        switch transaction.type! {
        case .delegateRegistration:
            serializeDelegateRegistration(transaction: transaction, &bytes)
        case .delegateResignation:
            serializeDelegateResignation(transaction: transaction, &bytes)
        case .ipfs:
            serializeIpfs(transaction: transaction, &bytes)
        case .multiPayment:
            serializeMultiPayment(transaction: transaction, &bytes)
        case .multiSignatureRegistration:
            serializeMultiSignatureRegistration(transaction: transaction, &bytes)
        case .secondSignatureRegistration:
            serializeSecondSignatureRegistration(transaction: transaction, &bytes)
        case .timelockTransfer:
            serializeTimelockTransfer(transaction: transaction, &bytes)
        case .transfer:
            serializeTransfer(transaction: transaction, &bytes)
        case .vote:
            serializeVote(transaction: transaction, &bytes)
        }
    }

    private static func serializeSignatures(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        if let signature = transaction.signature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: signature)!))
        }

        if let secondSignature = transaction.secondSignature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: secondSignature)!))
        } else if let signSignature = transaction.signSignature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: signSignature)!))
        }

        if let signatures = transaction.signatures {
            if signatures.count > 0 {
                bytes.append(0xff)
                bytes.append(contentsOf: [UInt8](Data.init(hex: transaction.signatures!.joined())!))
            }
        }
    }

    // MARK: - Type serializers

    private static func serializeTransfer(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        var transactionBytes = pack(transaction.amount)
        transactionBytes.removeLast()
        bytes.append(contentsOf: transactionBytes)

        var expirationBytes = pack(transaction.expiration)
        expirationBytes.removeLast()
        bytes.append(contentsOf: expirationBytes)

        let recipientId = base58CheckDecode(transaction.recipientId!)
        bytes.append(contentsOf: recipientId!)
    }

    private static func serializeDelegateRegistration(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        let delegate = transaction.asset!["delegate"] as! [String: String]
        let username = delegate["username"]!
        bytes.append(contentsOf: pack(UInt8(username.count)))
        bytes.append(contentsOf: [UInt8](username.data(using: .utf8)!))
    }

    private static func serializeSecondSignatureRegistration(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        let signature = transaction.asset!["signature"] as! [String: String]
        bytes.append(contentsOf: [UInt8](Data.init(hex: signature["publicKey"]!)!))
    }

    private static func serializeVote(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        let votes = transaction.asset!["votes"] as! [String]

        var voteBytes = [String]()

        for vote in votes {
            let prefix = vote.prefix(1) == "+" ? "01" : "00"
            let votePK = String(vote.suffix(vote.count - 1))
            voteBytes.append(String(format: "%@%@", prefix, votePK))
        }

        bytes.append(contentsOf: pack(UInt8(votes.count)))
        bytes.append(contentsOf: [UInt8](Data.init(hex: voteBytes.joined())!))
    }

    private static func serializeMultiSignatureRegistration(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        let multisigAsset = transaction.asset!["multisignature"] as! [String: Any]
        let keysgroup = multisigAsset["keysgroup"] as! [String]

        var keyBytes = [String]()
        for var key in keysgroup {
            if key.hasPrefix("+") {
                key.removeFirst()
            }
            keyBytes.append(key)
        }

        let min = multisigAsset["min"] as! UInt8
        let lifetime = multisigAsset["lifetime"] as! UInt8

        bytes.append(contentsOf: pack(min))
        bytes.append(contentsOf: pack(UInt8(keyBytes.count)))
        bytes.append(contentsOf: pack(lifetime))

        bytes.append(contentsOf: [UInt8](Data.init(hex: keyBytes.joined())!))
    }

    private static func serializeIpfs(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        let ipfs = transaction.asset!["ipfs"] as! [String: String]
        let dag = ipfs["dag"]!
        bytes.append(contentsOf: pack(UInt8(dag.count)))
        bytes.append(contentsOf: [UInt8](Data.init(hex: dag)!))
    }

    private static func serializeMultiPayment(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }

    private static func serializeTimelockTransfer(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }

    private static func serializeDelegateResignation(transaction: PhantomTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }
}
