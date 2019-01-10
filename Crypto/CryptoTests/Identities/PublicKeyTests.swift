//
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import XCTest
@testable import Crypto

class PublicKeyTests: XCTestCase {

    func testPublicKeyFromPassphrase() {
        let publicKey = PhantomPublicKey.from(passphrase: "this is a top secret passphrase")
        XCTAssertEqual(publicKey.raw.hex, "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192")
    }

    func testPublicKeyFromHex() {
        let publicKey = PhantomPublicKey.from(hex: "d8839c2432bfd0a67ef10a804ba991eabba19f154a3d707917681d45822a5712")
        XCTAssertEqual(publicKey.raw.hex, "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192")
    }
}
