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

public class PhantomPublicKey {

    public static func from(passphrase: String) -> PublicKey {
        return PhantomPrivateKey.from(passphrase: passphrase).publicKey()
    }

    public static func from(hex: String) -> PublicKey {
        return PhantomPrivateKey.from(hex: hex).publicKey()
    }
}
