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

                            Text("Event \(index + 1)")
                                .font(.headline)

                            ForEach(
                            Array(
                                    Mirror(reflecting: event)
                                        .children
                                        .enumerated()
                                ),
                                id: \.offset
                            ) { _, child in

                                VStack(alignment: .leading, spacing: 3) {

                                    Text(
                                        (child.label ?? "Details")
                                            .replacingOccurrences(
                                                of: "_",
                                                with: " "
                                            )
                                            .capitalized
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                    Text(String(describing: child.value))
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

                        VStack(alignment: .leading, spacing: 6) {

                            Text("ID: \(team.id)")
                                .font(.headline)

                            Text("Name: \(team.name)")

                            Text("Team Type: \(team.teamType)")

                            Text("Member Count: \(team.memberCount)")
                        }
                        .padding(.vertical, 5)
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

