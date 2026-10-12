
import SwiftUI

struct HomeView: View {

    @State private var viewModel = Screen2ViewModel()

    var body: some View {

        Form {

            Section("Scheduled Events") {

                if viewModel.eventsResponse.isEmpty {
                    Text("No events loaded.")
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(
                        Array(viewModel.eventsResponse.enumerated()),
                        id: \.offset
                    ) { index, event in

                        VStack(alignment: .leading, spacing: 8) {

                            Text(
                                event["title"]
                                ?? event["name"]
                                ?? "Event \(index + 1)"
                            )
                            .font(.headline)

                            ForEach(
                                event.keys.sorted().filter {
                                    $0 != "title" && $0 != "name"
                                },
                                id: \.self
                            ) { key in

                                VStack(alignment: .leading, spacing: 3) {

                                    Text(
                                        key.replacingOccurrences(
                                            of: "_",
                                            with: " "
                                        ).capitalized
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                    Text(event[key] ?? "")
                                        .font(.subheadline)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                Button("Load Scheduled Events") {
                    viewModel.getScheduledEvents()
                }
                .disabled(viewModel.isLoading)
            }

            Section("Teams List") {

                if viewModel.teamsResponse.isEmpty {
                    Text("No teams loaded.")
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(viewModel.teamsResponse, id: \.id) { team in
                        Text(team.name)
                    }
                }

                Button("Load Teams") {
                    viewModel.getTeams()
                }
                .disabled(viewModel.isLoading)
            }

            if viewModel.isLoading {
                Section {
                    ProgressView("Loading...")
                }
            }

            if !viewModel.errorMessage.isEmpty {
                Section("Error") {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Refresh All Data") {
                    viewModel.loadHomeData()
                }
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("Home")
        .task {
            viewModel.loadHomeData()
        }
    }
}

