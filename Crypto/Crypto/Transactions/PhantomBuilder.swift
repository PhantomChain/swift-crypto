// 
// This file is part of PHANTOM Swift Crypto.
//
// (c) PhantomChain <info@phantom.org>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class PhantomBuilder {

    /// Builds a transaction for a transfer
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase that will be registered for the wallet
    ///   - recipient: the recipient of the transfer
    ///   - amount: the amount of the transfer
    ///   - vendorField: an optional message included in the transfer
    /// - Returns: a signed PhantomTransaction
    public static func buildTransfer(_ passphrase: String, secondPassphrase: String?, to recipient: String, amount: UInt64, vendorField: String?) -> PhantomTransaction {
        var transaction = createBaseTransaction(forType: .transfer)
        transaction.recipientId = recipient
        transaction.amount = amount
        transaction.vendorField = vendorField

        return signTransaction(&transaction, passphrase, secondPassphrase)
    }

    /// Builds a transaction for a second signature registration
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase that will be registered for the wallet
    /// - Returns: a signed PhantomTransaction
    public static func buildSecondSignature(_ passphrase: String, secondPassphrase: String) -> PhantomTransaction {
        var transaction = createBaseTransaction(forType: .secondSignatureRegistration)
        transaction.asset = [
            "signature": [
                "publicKey": PhantomPublicKey.from(passphrase: secondPassphrase).raw.hex
            ]
        ]
        return signTransaction(&transaction, passphrase, nil)
    }

    /// Builds a transaction for a delegate registration
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase of the wallet, if available
    ///   - username: the username of the delegate
    /// - Returns: a signed PhantomTransaction
    public static func buildDelegateRegistration(_ passphrase: String, secondPassphrase: String?, username: String) -> PhantomTransaction {
        var transaction = createBaseTransaction(forType: .delegateRegistration)
        transaction.asset = [
            "delegate": [
                "username": username,
                "publicKey": PhantomPublicKey.from(passphrase: passphrase).raw.hex
            ]
        ]
        return signTransaction(&transaction, passphrase, secondPassphrase)
    }

    /// Builds a transaction for an vote
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase of the wallet, if available
    ///   - vote: the public key of the delegate that is being voted for
    /// - Returns: a signed PhantomTransaction
    public static func buildVote(_ passphrase: String, secondPassphrase: String?, vote: String) -> PhantomTransaction {
        return createVote(passphrase, secondPassphrase: secondPassphrase, vote: vote, voteType: "+")
    }

    /// Builds a transaction for an unvote
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase of the wallet, if available
    ///   - vote: the public key of the delegate that is being unvoted
    /// - Returns: a signed PhantomTransaction
    public static func buildUnvote(_ passphrase: String, secondPassphrase: String?, vote: String) -> PhantomTransaction {
        return createVote(passphrase, secondPassphrase: secondPassphrase, vote: vote, voteType: "-")
    }

    /// Builds a transaction for a multi signature registration
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet initiating the request
    ///   - secondPassphrase: the second passphrase of the wallet, if available
    /// - Returns: a signed PhantomTransaction
    public static func buildMultiSignatureRegistration(_ passphrase: String, secondPassphrase: String?, min: UInt8, lifetime: UInt8, keysgroup: [String]) -> PhantomTransaction {
        var transaction = createBaseTransaction(forType: .multiSignatureRegistration)
        let amount = UInt64(keysgroup.count + 1)
        transaction.fee = amount * Fee.shared.get(forType: .multiSignatureRegistration)
        transaction.asset = [
            "multisignature": [
                "min": min,
                "keysgroup": keysgroup,
                "lifetime": lifetime
            ]
        ]
        return signTransaction(&transaction, passphrase, secondPassphrase)
    }

    // MARK: - AIP11 builders
    // TODO

    // MARK: - helper functions

    /// Used to build either a vote or unvote transaction
    ///
    /// - Parameters:
    ///   - passphrase: the passphrase of the wallet
    ///   - secondPassphrase: the second passphrase of the wallet, if available
    ///   - vote: the public key of the delegate that is voted for / being unvoted
    ///   - voteType: a String indicating a vote or unvote
    /// - Returns: a signed PhantomTransaction
    private static func createVote(_ passphrase: String, secondPassphrase: String?, vote: String, voteType: String) -> PhantomTransaction {
        var transaction = createBaseTransaction(forType: .vote)
        transaction.asset = [
            "votes": ["\(voteType)\(vote)"]
        ]
        transaction.recipientId = PhantomAddress.from(passphrase: passphrase)
        return signTransaction(&transaction, passphrase, secondPassphrase)
    }

    /// Signs a transaction
    ///
    /// - Parameters:
    ///   - transaction: the transaction to sign
    ///   - passphrase: the passphrase to use for signing the transaction
    ///   - secondPassphrase: the second passphrase to use for signing the transaction, if available
    /// - Returns: a signed PhantomTransaction
    private static func signTransaction(_ transaction: inout PhantomTransaction, _ passphrase: String, _ secondPassphrase: String?) -> PhantomTransaction {
        transaction.timestamp = Slot.time()
        transaction.sign(PhantomPrivateKey.from(passphrase: passphrase))

        if let secondPass = secondPassphrase {
            transaction.secondSign(PhantomPrivateKey.from(passphrase: secondPass))
        }

        transaction.id = transaction.getId()
        return transaction
    }

    /// Helper function to populate default transaction fields
    ///
    /// - Parameter txType: the type of transaction
    /// - Returns: an unsigned PhantomTransaction
    private static func createBaseTransaction(forType txType: TransactionType) -> PhantomTransaction {
        let transaction = PhantomTransaction()
        transaction.type = txType
        transaction.fee = Fee.shared.get(forType: txType)
        return transaction
    }
}
