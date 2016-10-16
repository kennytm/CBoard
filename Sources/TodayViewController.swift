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
import NotificationCenter

private let widgets: [(String, NSViewController.Type)] = [
    ("Base conversion", BaseConversionController.self),
    ("UUID", UUIDController.self),
]

class TodayViewController: NSViewController, NCWidgetProviding, NSTextFieldDelegate {
    @IBOutlet var picker: NSPopUpButton!
    @IBOutlet var widget: NSView!
    private var currentWidget: NSViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        var selectedWidgetIndex = 0
        let selectedWidgetTitle = UserDefaults.standard.string(forKey: "selected")

        let menu = picker.menu!
        for (index, (title, _)) in widgets.enumerated() {
            let menuItem = NSMenuItem(title: title, action: #selector(changeView), keyEquivalent: "")
            menuItem.target = self
            menuItem.tag = index
            menu.addItem(menuItem)
            if title == selectedWidgetTitle {
                selectedWidgetIndex = index
            }
        }

        changeView(picker.item(at: selectedWidgetIndex)!)
    }

    @objc func changeView(_ sender: NSMenuItem) {
        if let widget = currentWidget {
            widget.removeFromParentViewController()
        }
        let widgetClass = widgets[sender.tag].1
        let child = widgetClass.init(nibName: nil, bundle: nil)!
        let childView = child.view
        currentWidget = child
        addChildViewController(child)
        view.replaceSubview(widget, with: childView)
        widget = childView

        UserDefaults.standard.set(sender.title, forKey: "selected")

        let constraintViews = ["childView": childView, "picker": picker]
        var constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[childView(288)]-16-|",
            options: [],
            metrics: nil,
            views: constraintViews)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[picker]-8-[childView]-|",
            options: [],
            metrics: nil,
            views: constraintViews)
        NSLayoutConstraint.activate(constraints)
    }

    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        NSLog("WTF???")
        completionHandler(.newData)
    }
}
