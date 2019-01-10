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

public class WIF {

    public static func from(passphrase: String) -> String {
        var bytes = [UInt8]()
        bytes.append(PhantomNetwork.shared.get().wif())
        bytes.append(contentsOf: Crypto.sha256(passphrase.data(using: .utf8)!))
        bytes.append(0x01)

        return base58CheckEncode(bytes)
    }
}
