//
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation
import BitcoinKit

public class PhantomMessage: Codable {

    public let publicKey: String
    public let signature: String
    public let message: String

    public init(publicKey: String, signature: String, message: String) {
        self.publicKey = publicKey
        self.signature = signature
        self.message = message
    }

    // TODO: throw proper error
    public static func sign(message: String, passphrase: String) -> PhantomMessage? {
        let keys = PhantomPrivateKey.from(passphrase: passphrase)
        let hash = Crypto.sha256(message.data(using: .utf8)!)
        do {
            return try PhantomMessage(publicKey: keys.publicKey().raw.hex,
                              signature: Crypto.sign(hash, privateKey: keys).hex,
                              message: message)
        } catch {
            return nil
        }
    }

    // TODO: throw proper error
    public func verify() -> Bool {
        do {
            return try Crypto.verifySignature(Data.init(hex: self.signature)!,
                                      message: Crypto.sha256(message.data(using: .utf8)!),
                                      publicKey: Data.init(hex: self.publicKey)!)
        } catch {
            return false
        }
    }

    public func toDict() -> [String: String] {
        return [
            "publickey": self.publicKey,
            "signature": self.signature,
            "message": self.message
        ]
    }

    // TODO: throw proper error
    public func toJson() -> String {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return ""
        }
    }
}
