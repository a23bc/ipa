import FeatureCore
import IPADesignSystem
import SwiftUI

public struct LibraryScreen: View {
    @EnvironmentObject private var library: LibraryModel
    @EnvironmentObject private var downloads: DownloadCenter
    @EnvironmentObject private var session: SessionModel

    public init() {}

    public var body: some View {
        @Bind var library = library
        @Bind var downloads = downloads
        AdaptiveList {
            LibraryHeroSection()
            InProgressSection()
            ForEach(library.groups) { LibraryAccountSection(group: $0) }
        }
        .libraryEmptyState(when: library.isShowingEmptyState)
        .toolbar { ToolbarItem(placement: .leading) { AccountMenu() } }
        .searchable(text: $library.text, prompt: Text("Name or Bundle ID"))
        .confirmationDialog(
            library.deletionTitle, isPresented: $library.isConfirmingDeletion,
            titleVisibility: .visible, presenting: library.deletion
        ) { _ in
            Button("Delete", role: .destructive) { Task { await library.confirmDeletion() } }
        } message: { _ in
            Text(verbatim: library.deletionMessage)
        }
        .errorAlert($downloads.error)
        .refreshable { await library.load() }
        .task(id: session.generation) { await library.load() }
        .navigationTitle("Downloads")
    }
}

private struct LibraryHeroSection: View {
    @EnvironmentObject private var library: LibraryModel
    @Environment(\.appTint) private var appTint
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if library.hasRecords {
            Section {
            } header: {
                VStack(spacing: .spaceS) {
                    Chip(library.heroChip, color: appTint, shape: .capsule)
                    Text(verbatim: library.heroTitle)
                        .font(.amountHero)
                        .foregroundStyle(Color.primary)
                        .amountLine()
                    Text(verbatim: library.heroCaption)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .textCase(nil)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .spaceL)
                .accessibilityElement(children: .combine)
                .animation(reduceMotion ? nil : .smoothSpring, value: library.totalBytes)
            } footer: {
                if library.isFilteredOut {
                    Text(verbatim: library.filteredOutText)
                }
            }
        }
    }
}

private struct InProgressSection: View {
    @EnvironmentObject private var library: LibraryModel

    var body: some View {
        let tasks = library.tasks
        if !tasks.isEmpty {
            Section {
                ForEach(tasks) { DownloadTaskRow(task: $0) }
            } header: {
                Text("In Progress").sectionTitle()
            } footer: {
                Text(verbatim: library.inProgressFooter)
            }
        }
    }
}

private struct LibraryAccountSection: View {
    @EnvironmentObject private var library: LibraryModel
    let group: LibraryGroup

    var body: some View {
        Section {
            ForEach(group.records) { DownloadRecordRow(record: $0) }
        } header: {
            Text(verbatim: group.title).sectionTitle()
        } footer: {
            Text(verbatim: library.footer(for: group))
        }
    }
}

private struct LibraryEmptyState: View {
    @EnvironmentObject private var library: LibraryModel
    @EnvironmentObject private var navigation: IPANavigation

    var body: some View {
        EmptyStateView(
            title: "No downloads yet",
            description:
                "Find a free app in Search and download it. Each package shows up here, under the account that got it.",
            actionTitle: "Search Apps"
        ) {
            navigation.selectedSection = .search
        } example: {
            ForEach(library.examples) { example in
                ExampleRow(
                    example.record.name, detail: example.record.detailLine,
                    value: example.record.dateText, symbol: example.symbol,
                    color: example.color.color)
            }
        }
    }
}

extension View {
    @ViewBuilder fileprivate func libraryEmptyState(when isEmpty: Bool) -> some View {
        if isEmpty {
            LibraryEmptyState()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.groupedBackground)
        } else {
            self
        }
    }
}
