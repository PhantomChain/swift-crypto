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

public class PhantomAddress {

    public static func from(passphrase: String, network: UInt8? = nil) -> String {
        return from(privateKey: PhantomPrivateKey.from(passphrase: passphrase), network: network)
    }

    public static func from(privateKey: PrivateKey, network: UInt8? = nil) -> String {
        return from(publicKey: privateKey.publicKey().raw.hex, network: network)
    }

    public static func from(publicKey: String, network: UInt8? = nil) -> String {
        let networkVersion = network != nil ? network! : PhantomNetwork.shared.get().version()
        let ripemd160 = Crypto.ripemd160(Data.init(hex: publicKey)!)
        var seed = [UInt8]()
        seed.append(networkVersion)
        seed.append(contentsOf: ripemd160)

        return base58CheckEncode(seed)
    }

    public static func validate(address: String) -> Bool {
        let decoded = base58CheckDecode(address)
        if let decoded = decoded {
            return PhantomNetwork.shared.get().version() == decoded.first
        }
        return false
    }
}
