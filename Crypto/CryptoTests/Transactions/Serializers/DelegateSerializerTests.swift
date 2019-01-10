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

class DelegateSerializerTests: XCTestCase {

    func testSerializeDelegateRegistration() {
        let json = readJson(file: "del_reg_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

    func testSerializeDelegateRegistrationSecondSig() {
        let json = readJson(file: "del_reg_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = PhantomDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, PhantomSerializer.serialize(transaction: transaction))
    }

}
