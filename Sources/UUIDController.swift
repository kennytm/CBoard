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

class UUIDController: NSViewController {
    @IBOutlet var uuidTextView: NSTextView!

    private var isUppercase = false
    private var uuids = [UUID]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let ud = UserDefaults.standard
        let count = max(1, ud.integer(forKey: "uuid.count"))
        isUppercase = ud.bool(forKey: "uuid.isUppercase")
        uuids = (0 ..< count).map { _ in UUID() }

        updateLabel()
    }

    @IBAction func changeCount(_ sender: NSControl) {
        let newCount = sender.integerValue
        if uuids.count < newCount {
            uuids.append(contentsOf: (uuids.count ..< newCount).map { _ in UUID() })
        } else if uuids.count > newCount {
            uuids.removeSubrange(newCount ..< uuids.count)
        }
        updateLabel()
    }

    @IBAction func changeCase(_ sender: NSButton) {
        isUppercase = sender.state == NSOnState
        updateLabel()
    }

    @IBAction func generate(_ sender: NSButton) {
        for i in uuids.indices {
            uuids[i] = UUID()
        }
        updateLabel()
    }

    @IBAction func copy(_ sender: NSButton) {
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(createString(), forType: NSPasteboardTypeString)
    }

    private func updateLabel() {
        uuidTextView.string = createString()
    }

    private func createString() -> String {
        return uuids.map {
            let str = $0.uuidString
            return isUppercase ? str : str.lowercased()
        }.joined(separator: "\n")
    }
}
