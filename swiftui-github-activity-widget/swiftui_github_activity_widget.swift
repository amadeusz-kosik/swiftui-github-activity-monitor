//
//  swiftui_github_activity_widget.swift
//  swiftui-github-activity-widget
//
//  Created by Amadeusz Kosik on 01/04/2026.
//

import WidgetKit
import SwiftUI



struct SimpleEntry: TimelineEntry {
    let date: Date
    let allEvents: [Int]
    let repos: [String]
    let repoEvents: [[String : Int]]
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            allEvents: [2, 3, 0, 6, 9, 2, 0, 9, 1, 4 ],
            repos: ["repo 1", "repo 2", "repo 3"],
            repoEvents: [
                ["repo 1": 2, "repo 2": 0, "repo 3": 0],
                ["repo 1": 2, "repo 2": 1, "repo 3": 0],
                ["repo 1": 0, "repo 2": 0, "repo 3": 0],
                ["repo 1": 0, "repo 2": 3, "repo 3": 3],
                ["repo 1": 0, "repo 2": 6, "repo 3": 3],
                ["repo 1": 2, "repo 2": 0, "repo 3": 0],
                ["repo 1": 0, "repo 2": 0, "repo 3": 0],
                ["repo 1": 6, "repo 2": 0, "repo 3": 3],
                ["repo 1": 0, "repo 2": 0, "repo 3": 1],
                ["repo 1": 0, "repo 2": 2, "repo 3": 2]
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [placeholder(in: context)], policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


struct GitHubActivityWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Overall activity:")
            HStack(spacing: 4) { // spacing between squares
                ForEach(0 ..< 10) { index in
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(entry.allEvents[index] > 0 ? .blue : .gray.opacity(0.3))
                        .cornerRadius(4)
                }
            }
            ForEach(entry.repos, id: \.self) { repo in
                Text(repo + ":")
                HStack(spacing: 4) {
                    ForEach(0 ..< 10) { index in
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(entry.repoEvents[index][repo] ?? 0 > 0 ? .blue : .gray.opacity(0.3))
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
}

struct GitHubActivityWidget: Widget {
    let kind: String = "github_activity_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                GitHubActivityWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                GitHubActivityWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("GitHub Activity")
        .description("Your activity on GitHub and top three repositories.")
    }
}
