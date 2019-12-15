//
//  FHIRSerializers.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/24/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire
import FHIR

/// Default `HTTPMethod`s for which empty response bodies are considered appropriate. `[.head]` by default.
public var defaultEmptyRequestMethods: Set<HTTPMethod> { return [.head] }
/// HTTP response codes for which empty response bodies are considered appropriate. `[204, 205]` by default.
public var defaultEmptyResponseCodes: Set<Int> { return [204, 205] }

public final class FHIRResponseSerializer<T: FHIR.Resource>: ResponseSerializer {
    
    public typealias SerializedObject = T
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    
    public init(emptyResponseCodes: Set<Int> = defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = defaultEmptyRequestMethods) {
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil else {
            throw error!
        }
        
        guard let data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            
            guard let emptyResponseType = T.self as? EmptyResponse.Type, let emptyValue = emptyResponseType.emptyValue() as? T else {
                throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "\(T.self)"))
            }
            
            return emptyValue
        }

        var json: FHIRJSON?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? FHIRJSON
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
        do {
            return try T.init(json: json!)
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
        
    }
}

extension DataRequest {
    
    @discardableResult
    public func responseFHIRResource<T: FHIR.Resource>(of type: T.Type = T.self,
                                                    queue: DispatchQueue = .main,
                                                    completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: FHIRResponseSerializer<T>(),
                        completionHandler: completionHandler)
    }
}
