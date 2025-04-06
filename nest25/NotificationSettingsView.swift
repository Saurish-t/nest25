//
//  NotificationSettingsView.swift
//  nest25
//
//  Created by Gautam Annamalai on 4/6/25.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var electionReminders = true
    @State private var registrationDeadlines = true
    @State private var townHallAlerts = false
    @State private var personalizedNewsUpdates = true
    @State private var votingLocationChanges = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Notification Preferences")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                SettingToggle(title: "Election Reminders", description: "Get notified when an election is coming up.", isOn: $electionReminders)
                SettingToggle(title: "Registration Deadlines", description: "Be alerted before voter registration closes.", isOn: $registrationDeadlines)
                SettingToggle(title: "Town Hall Alerts", description: "Get reminders before live town hall events.", isOn: $townHallAlerts)
                SettingToggle(title: "Personalized News", description: "Updates on issues and candidates you follow.", isOn: $personalizedNewsUpdates)
                SettingToggle(title: "Polling Place Updates", description: "Be informed if your voting location changes.", isOn: $votingLocationChanges)

                Text("Your preferences are saved locally and never shared.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top, 10)

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("Notifications")
    }
}

struct SettingToggle: View {
    var title: String
    var description: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}



#Preview {
    NotificationSettingsView()
}
