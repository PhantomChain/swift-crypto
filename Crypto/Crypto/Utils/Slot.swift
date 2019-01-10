// 
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class Slot {

    public static func time() -> UInt32 {
        let epoch = self.rfc3339().date(from: PhantomNetwork.shared.get().epoch())?.timeIntervalSince1970
        let now = NSDate().timeIntervalSince1970

        return UInt32(now - epoch!)
    }

    public static func epoch() -> Int {
        return Int((self.rfc3339().date(from: PhantomNetwork.shared.get().epoch())?.timeIntervalSince1970)!)
    }

    private static func rfc3339() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}
