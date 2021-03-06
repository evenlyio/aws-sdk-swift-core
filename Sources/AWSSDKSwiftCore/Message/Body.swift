//
//  Body.swift
//  AWSSDKSwift
//
//  Created by Yuki Takei on 2017/04/11.
//
//

import Foundation

/// Enumaration used to store request/response body in various forms
public enum Body {
    /// text
    case text(String)
    /// raw data
    case buffer(Data)
    /// stream is currenty unsupported
    case stream(InputStream)
    /// json data
    case json(Data)
    /// xml
    case xml(XML.Element)
    /// empty body
    case empty
}

extension Body {
    /// initialize Body with Any. If it is Data, create .buffer() otherwise create a String describing the value
    init(anyValue: Any) {
        switch anyValue {
        case let v as Data:
            self = .buffer(v)
        default:
            self = .text("\(anyValue)")
        }
    }

    /// return as a dictionary. Currently only works for JSON
    public func asDictionary() throws -> [String: Any]? {
        switch self {

        case .json(let data):
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        default:
            return nil
        }
    }

    /// return as a raw data buffer
    public func asData() -> Data? {
        switch self {
        case .text(let text):
            return text.data(using: .utf8)

        case .buffer(let data):
            return data

        case .json(let data):
            if data.isEmpty {
                return nil
            } else {
                return data
            }

        case .xml(let node):
            let xmlDocument = XML.Document(rootElement: node)
            return xmlDocument.xmlData

        case .stream(_):
            return nil

        case .empty:
            return nil
        }
    }
}
