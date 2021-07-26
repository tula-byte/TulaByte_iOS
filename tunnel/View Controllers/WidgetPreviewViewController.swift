//
//  WidgetPreviewViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 31/3/21.
//

import UIKit
import SwiftUI

struct StatsEntry {
    let date: Date
    let blockCount: Int
}

let defaultEntry = StatsEntry(date: Date(), blockCount: 420)

class WidgetPreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftUIView = UIHostingController(rootView: TulaEntryView(entry: defaultEntry).frame(width: 169, height: 169, alignment: .bottomTrailing))
        addChild(swiftUIView)
        view.addSubview(swiftUIView.view)
        view.clipsToBounds = true
        swiftUIView.view.center = view.center
        swiftUIView.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
