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

class NetworkTests: XCTestCase {

    func testGetNetwork() {
        let network = PhantomNetwork.shared.get()
        XCTAssertEqual(network.version(), 30)
    }

    func testSetNetwork() {
        PhantomNetwork.shared.set(network: Mainnet())
        let network = PhantomNetwork.shared.get()
        XCTAssertEqual(network.version(), 23)

        PhantomNetwork.shared.set(network: Devnet()) // Reset
    }
}
