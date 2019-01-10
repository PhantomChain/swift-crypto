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

class AddressTests: XCTestCase {

    // This also uses from(publicKey:) and from(privateKey:) internally
    func testAddressFromPassphrase() {
        let address = PhantomAddress.from(passphrase: "this is a top secret passphrase")
        XCTAssertEqual(address, "D61mfSggzbvQgTUe6JhYKH2doHaqJ3Dyib")
    }

    func testValidateAddress() {
        XCTAssertTrue(PhantomAddress.validate(address: "D61mfSggzbvQgTUe6JhYKH2doHaqJ3Dyib"))
    }
}
