/*

 CBoard -- macOS notification center widget to perform quick programming-related tasks
 Copyright (C) 2016 Appholly Technology Co., Ltd.

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU
 General Public License as published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.

 You should have received a copy of the GNU General Public License along with this program. If not,
 see <http://www.gnu.org/licenses/>.

 */

import Cocoa

private let radixReplacementRegex = [
    2: "[^01]",
    8: "[^0-7]",
    10: "[^0-9]",
    16: "[^0-9a-fA-F]",
]

class BaseConversionController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var hexTextField: NSTextField!
    @IBOutlet var decTextField: NSTextField!
    @IBOutlet var octTextField: NSTextField!
    @IBOutlet var binTextField: NSTextField!

    @IBOutlet var bitnessSlider: NSSlider!
    @IBOutlet var bitnessLabel: NSTextField!

    private var bitCount: UInt64 = 32
    private var number: UInt64 = 0

    override func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as! NSTextField
        let radix = textField.tag
        let regex = radixReplacementRegex[radix]!
        let string = textField.stringValue.replacingOccurrences(of: regex, with: "", options: .regularExpression)
        if let parsed = UInt64(string, radix: radix) {
            number = parsed
            updateTextFields(except: textField)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBitness(bitnessSlider)
    }

    private func updateTextFields(except textField: NSTextField?) {
        if hexTextField !== textField {
            hexTextField.stringValue = "0x\(String(number, radix: 16))"
        }
        if decTextField !== textField {
            decTextField.stringValue = "\(number)"
        }
        if octTextField !== textField {
            octTextField.stringValue = "0o\(String(number, radix: 8))"
        }
        if binTextField !== textField {
            binTextField.stringValue = "0b\(String(number, radix: 2))"
        }
    }

    @IBAction func updateBitness(_ sender: NSSlider) {
        let logBitCount = UInt64(sender.integerValue)
        bitCount = 1 << logBitCount
        bitnessLabel.stringValue = "\(bitCount)-bit"
    }

    @IBAction func computeTwosComplement(_: NSButton) {
        let bitMask = bitCount < 64 ? 1 << bitCount &- 1 : ~0
        number = (~number &+ 1) & bitMask
        updateTextFields(except: nil)
    }

    @IBAction func flipEndian(_: NSButton) {
        number = number.byteSwapped >> (64 - bitCount)
        updateTextFields(except: nil)
    }
}
