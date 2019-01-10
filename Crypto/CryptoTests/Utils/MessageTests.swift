//
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

//swiftlint:disable force_try

import XCTest
@testable import Crypto

class MessageTests: XCTestCase {

    func testMessageSign() {
        let sig = PhantomMessage.sign(message: "Hello World", passphrase: "this is a top secret passphrase")

        XCTAssertEqual(sig?.publicKey, "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192")
        XCTAssertEqual(sig?.signature, "304402200fb4adddd1f1d652b544ea6ab62828a0a65b712ed447e2538db0caebfa68929e02205ecb2e1c63b29879c2ecf1255db506d671c8b3fa6017f67cfd1bf07e6edd1cc8")
        XCTAssertEqual(sig?.message, "Hello World")
    }

    func testMessageVerify() {
        let message = PhantomMessage(publicKey: "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192",
                                 signature: "304402200fb4adddd1f1d652b544ea6ab62828a0a65b712ed447e2538db0caebfa68929e02205ecb2e1c63b29879c2ecf1255db506d671c8b3fa6017f67cfd1bf07e6edd1cc8",
                                 message: "Hello World")
        XCTAssertTrue(message.verify())
    }

    func testMessageToDict() {
        let message = PhantomMessage(publicKey: "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192",
                                 signature: "304402200fb4adddd1f1d652b544ea6ab62828a0a65b712ed447e2538db0caebfa68929e02205ecb2e1c63b29879c2ecf1255db506d671c8b3fa6017f67cfd1bf07e6edd1cc8",
                                 message: "Hello World")
        let dict = message.toDict()
        XCTAssertEqual(dict["publickey"], "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192")
        XCTAssertEqual(dict["signature"], "304402200fb4adddd1f1d652b544ea6ab62828a0a65b712ed447e2538db0caebfa68929e02205ecb2e1c63b29879c2ecf1255db506d671c8b3fa6017f67cfd1bf07e6edd1cc8")
        XCTAssertEqual(dict["message"], "Hello World")
    }

    func testMessageToJson() {
        let message = PhantomMessage(publicKey: "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192",
                                 signature: "304402200fb4adddd1f1d652b544ea6ab62828a0a65b712ed447e2538db0caebfa68929e02205ecb2e1c63b29879c2ecf1255db506d671c8b3fa6017f67cfd1bf07e6edd1cc8",
                                 message: "Hello World")
        let json = message.toJson()
        let jsonDecoder = JSONDecoder()
        let messageDecoded = try! jsonDecoder.decode(PhantomMessage.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(message.publicKey, messageDecoded.publicKey)
    }
}
