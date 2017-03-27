//
//  NSTextStorage+Indentation.swift
//  TipTyper
//
//  Created by Bruno Philipe on 26/3/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import AppKit

protocol ModifiableIndentation
{
	func increaseIndentForSelectedRanges(_ ranges: [NSRange])
	func decreaseIndentForSelectedRanges(_ ranges: [NSRange])
}

extension NSTextStorage: ModifiableIndentation
{
	func increaseIndentForSelectedRanges(_ ranges: [NSRange])
	{
		let string = self.string as NSString
		var insertedCharacters = 0

		for range in ranges
		{
			let enclosingRange = string.lineRange(for: NSMakeRange(range.location, range.length))
			self.replaceCharacters(in: NSMakeRange(enclosingRange.location + insertedCharacters, 0), with: "\t")

			insertedCharacters += 1
		}
	}

	func decreaseIndentForSelectedRanges(_ ranges: [NSRange])
	{
		let string = self.string as NSString
		var removedChracters = 0

		for range in ranges
		{
			let enclosingRange = string.lineRange(for: range)

			if string.character(at: enclosingRange.location).isTab()
			{
				self.replaceCharacters(in: NSMakeRange(enclosingRange.location - removedChracters, 1), with: "")

				removedChracters += 1
			}
		}
	}

	func findLineStartFromLocation(_ location: Int) -> NSInteger
	{
		if location <= 0
		{
			return 0
		}

		let string = self.string as NSString
		return string.lineRange(for: NSMakeRange(min(location, string.length - 1), 0)).location
	}
}

extension unichar
{
	func isTab() -> Bool
	{
		return self == 0x9
	}
}