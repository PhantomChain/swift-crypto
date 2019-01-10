//
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

// swiftlint:disable force_cast

import XCTest
@testable import Crypto

class TransferDeserializerTests: XCTestCase {

    func testDeserializeTransfer() {
        let json = readJson(file: "transfer_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertTrue(transaction.verify())
    }

    func testDeserializeTransferSecondSig() {
        let json = readJson(file: "transfer_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
        XCTAssertTrue(transaction.verify())
    }

    func testDeserializeTransferWithVendorField() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.vendorField, data["vendorField"] as! String)
        XCTAssertTrue(transaction.verify())
    }

    func testDeserializeTransferWithVendorFieldSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
        XCTAssertEqual(transaction.vendorField, data["vendorField"] as! String)
        XCTAssertTrue(transaction.verify())
    }

    func testDeserializeTransferWithVendorFieldHex() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.vendorFieldHex, data["vendorFieldHex"] as! String)
        XCTAssertTrue(transaction.verify())
    }

    func testDeserializeTransferWithVendorFieldHexSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
        XCTAssertEqual(transaction.vendorFieldHex, data["vendorFieldHex"] as! String)
        XCTAssertTrue(transaction.verify())
    }
}
