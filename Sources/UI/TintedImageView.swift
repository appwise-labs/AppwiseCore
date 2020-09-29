//
//  TintedImageView.swift
//  AppwiseCore
//
//  Created by David Jennes on 15/11/2016.
//  Copyright © 2019 Appwise. All rights reserved.
//

import IBAnimatable

open class TintedImageView: AnimatableImageView {
	override open func awakeFromNib() {
		super.awakeFromNib()

		// swiftlint:disable swiftgen_colors
		let tint = tintColor
		tintColor = #colorLiteral(red: 0.1, green: 0.2, blue: 0.3, alpha: 1)
		tintColor = tint
	}
}
