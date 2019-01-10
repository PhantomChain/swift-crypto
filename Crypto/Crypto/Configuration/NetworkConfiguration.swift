// 
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class PhantomNetwork {

    public static let shared = PhantomNetwork(network: Devnet())

    var network: ProtocolNetwork

    private init(network: ProtocolNetwork) {
        self.network = network
    }

    public func get() -> ProtocolNetwork {
        return network
    }

    public func set(network: ProtocolNetwork) {
        self.network = network
    }
}
