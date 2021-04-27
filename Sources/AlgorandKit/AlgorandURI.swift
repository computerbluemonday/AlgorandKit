//
//  AlgorandURI.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import Foundation

/// Encapsulates the logic for creating a URL based on the Algorand URI spec,
/// defined at https://developer.algorand.org/docs/reference/payment_prompts/
///
/// AlgorandURI is immutable by design, and enforces logic for parameter validation
/// at compile-time through its type definitions.
///
public struct AlgorandURI {

  let uriScheme = "algorand"

  /// Wrapper around the transaction's receiver.
  struct Receiver {
    ///
    /// Receiver's Algorand address.
    ///
    /// AlgorandURI treats addresses opaquely, and by design does not validate them.
    /// Addresses are encoded and passed through to the host wallet for validation.
    let address: String
   
    ///
    /// Optional label for this address (e.g. name of receiver)
    let label: String?
  }
  
  /// Receiver for the transaction represented by this AlgorandURI
  let receiver: Receiver
  
  /// Wrapper around the transaction's asset.
  ///
  /// Explicitly define the case for Algos (in units of microAlgos) for convenience
  /// and to help avoid accidental misuse.
  ///
  /// See assetAmount parameter for more information on asset units.
  enum AssetAmount {
    case algo(microAlgos: UInt)
    case ASA(assetID: UInt, amount: UInt)
  }

  /// The asset and corresponding amount of asset for the transaction represented
  /// by this AlgorandURI.
  ///
  /// If an amount is provided, it MUST be specified in basic unit of the asset.
  /// For example, if it’s Algos (Algorand native unit), the amount should be specified
  /// in microAlgos.
  ///
  /// e.g. for 100 Algos, the amount needs to be 100000000, for 54.1354 Algos the
  /// amount needs to be 54135400.
  let assetAmount: AssetAmount?
  
  /// Wrapper around the transaction note.
  ///
  /// readonly (xnote): A URL-encoded notes field value that must not be modifiable by the
  ///                   user when displayed to users.
  /// editable (note): A URL-encoded default notes field value that the the user interface
  ///                  may optionally make editable by the user.
  enum Note {
    case readonly(xnote: String)
    case editable(note: String)
  }

  /// Optional transaction note for this AlgorandURI, which may be specified to be either
  /// readonly or editable by the user.
  let note: Note?

  /// URL for this AlgorandURI
  ///
  /// After initialization, url() may be called to generate a runnable URL (NSURL) which,
  /// when requested, should be dispatched to the app registered to handle the "algorand:"
  /// URI scheme.
  public func url() -> URL? {
    var components = URLComponents()
    components.scheme = uriScheme
    components.host = receiver.address
    components.path = ""
    
    var queryItems: [URLQueryItem] = []
    if let label = receiver.label {
      queryItems.append(URLQueryItem(name: "label", value: label))
    }
    switch assetAmount {
    case .some(.algo(let microAlgos)):
      queryItems.append(URLQueryItem(name: "amount", value: String(microAlgos)))
    case .some(.ASA(let assetID, let amount)):
      queryItems.append(URLQueryItem(name: "asset", value: String(assetID)))
      queryItems.append(URLQueryItem(name: "amount", value: String(amount)))
    case .none:
      break
    }
    switch note {
    case .some(.readonly(let xnote)):
      queryItems.append(URLQueryItem(name: "xnote", value: xnote))
    case .some(.editable(let note)):
      queryItems.append(URLQueryItem(name: "note", value: note))
    case .none:
      break
    }
    if (queryItems.count > 0) {
      components.queryItems = queryItems
    }

    return components.url
  }
}
