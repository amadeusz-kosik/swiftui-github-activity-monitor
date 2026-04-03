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
    let allEvents: [Bool]
    let repos: [String]
    let repoEvents: [String : [Bool]]
}


struct SquareStreakBar: View {
    var progress: [Bool]

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let spacing: CGFloat = 4
            let squareWidth: CGFloat = 15
            let squareCount: CGFloat = min(30, (totalWidth + spacing) / (squareWidth + spacing))

            HStack(spacing: spacing) {
                ForEach(0 ..< Int(squareCount), id: \.self) { index in
                    Rectangle()
                        .frame(width: squareWidth, height: squareWidth) // square
                        .foregroundColor(progress[index] ? .blue : .gray.opacity(0.3))
                        .cornerRadius(4)
                }
            }
        }
    }
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            allEvents: (0 ..< 30).map { _ in Bool.random() },
            repos: ["repo 1", "repo 2", "repo 3"],
            repoEvents: [
                "repo 1": (0 ..< 30).map { _ in Bool.random() },
                "repo 2": (0 ..< 30).map { _ in Bool.random() },
                "repo 3": (0 ..< 30).map { _ in Bool.random() }
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
                .lineLimit(1)
            SquareStreakBar(progress: entry.allEvents)
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
