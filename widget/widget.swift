//
//  widget.swift
//  widget
//
//  Created by Arjun Singh on 16/2/21.
//

import WidgetKit
import SwiftUI

struct StatsEntry: TimelineEntry {
    let date: Date
    let blockCount: Int
}

let defaultEntry = StatsEntry(date: Date(), blockCount: 420)

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StatsEntry {
        defaultEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsEntry) -> ()) {
        let entry = defaultEntry
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StatsEntry] = []

        // Generate a timeline consisting of five entries half an hour apart, starting from the current date.
        let currentDate = Date()
        for i in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: (i * 15), to: currentDate)!
            let entry = StatsEntry(date: entryDate, blockCount: retrieveBlockLog().count)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TulaEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("TulaByte")
        .description("Displays the number of trackers that have been blocked since TulaByte was setup.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        TulaEntryView(entry: defaultEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
