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

class MultiSignatureDeserializerTests: XCTestCase {

    func testDeserializeMultiSignature() {
        let json = readJson(file: "ms_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 23)
        XCTAssertEqual(transaction.type, TransactionType.multiSignatureRegistration)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertTrue(transaction.verify())

        XCTAssertEqual(transaction.signatures?.count, 3)

        let asset = data["asset"] as! [String: [String: Any]]
        let transactionAsset = transaction.asset as! [String: [String: Any]]
        let assetMultiSig = asset["multisignature"]!
        let txAssetMultiSig = transactionAsset["multisignature"]!
        XCTAssertEqual(txAssetMultiSig["min"] as! UInt8, assetMultiSig["min"] as! UInt8)
        XCTAssertEqual(txAssetMultiSig["lifetime"] as! UInt8, assetMultiSig["lifetime"] as! UInt8)

        let txKeysgroup = txAssetMultiSig["keysgroup"] as! [String]
        let keysgroup = assetMultiSig["keysgroup"] as! [String]
        for idx in 0..<txKeysgroup.count {
            XCTAssertEqual(txKeysgroup[idx], keysgroup[idx])
        }
    }
}
