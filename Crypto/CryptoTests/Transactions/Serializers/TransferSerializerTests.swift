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

class TransferSerializerTests: XCTestCase {

    func testSerializeTransfer() {
        let json = readJson(file: "transfer_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeTransferSecondSig() {
        let json = readJson(file: "transfer_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeTransferWithVendorField() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeTransferWithVendorFieldSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeTransferWithVendorFieldHex() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeTransferWithVendorFieldHexSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }
}
