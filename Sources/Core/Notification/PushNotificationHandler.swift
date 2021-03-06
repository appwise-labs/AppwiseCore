//
// AppwiseCore
// Copyright © 2021 Appwise
//

public protocol PushNotificationType {
	static var typeIdentifiers: [String] { get }

	init?(type: String, data: [AnyHashable: Any])

	func handle()
	var canShow: Bool { get }
	func open()
}

public extension PushNotificationType {
	func handle() {
	}

	var canShow: Bool {
		true
	}

	func open() {
	}
}

public enum PushNotification {
}
