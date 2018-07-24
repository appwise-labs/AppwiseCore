//
//  Client+Insert.swift
//  Alamofire
//
//  Created by David Jennes on 24/07/2018.
//

import Alamofire
import CocoaLumberjack

public extension Client {
	/// Shortcut method for building the request, performing an insert, and saving the result.
	///
	/// - parameter request:           The router request type
	/// - parameter db:                The database to work in
	/// - parameter queue:             The queue on which the deserializer (and your completion handler) is dispatched.
	/// - parameter jsonSerializer:    The response JSON serializer
	/// - parameter type:              The `Insertable` type that will be used in the serialization
	/// - parameter contextObject:     The object to pass along to an import operation (see `ImportContext.object`)
	/// - parameter completionHandler: The code to be executed once the request has finished.
	///
	/// - returns: The data request object
	func insertRequest<T: Insertable>(
		_ request: RouterType,
		db: DB = DB.shared,
		queue: DispatchQueue? = nil,
		jsonSerializer: DataResponseSerializer<Any> = DataRequest.jsonResponseSerializer(),
		type: T.Type,
		contextObject: Any? = nil,
		completionHandler: @escaping (Alamofire.Result<T>) -> Void
	) {
		buildRequest(request) { result in
			switch result {
			case let .success(request):
				request.responseInsert(type: type, contextObject: contextObject) { response, save in
					switch response.result {
					case .success(let value):
						save { error in
							// cast the value to the main context
							do {
								if let error = error {
									throw error
								} else {
									let mainValue = try value.inContext(db.main)
									completionHandler(.success(mainValue))
								}
							} catch let error {
								DDLogInfo("Error saving result: \(error.localizedDescription)")
								completionHandler(.failure(error))
							}
						}
					case .failure(let error):
						let error = Self.extract(from: response, error: error)
						DDLogInfo(error.localizedDescription)
						completionHandler(.failure(error))
					}
				}
			case .failure(let error):
				DDLogInfo("Error creating request: \(error.localizedDescription)")
				completionHandler(.failure(error))
			}
		}
	}
}