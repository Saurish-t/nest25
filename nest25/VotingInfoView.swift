import SwiftUI

struct VotingInfoView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @AppStorage("userEmail") private var userEmail: String = ""
    @State private var showNotifications = false
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Voting Information")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        InfoCardView(
                            title: "How to Register",
                            description: "Learn about the voter registration process and ensure you're eligible to vote in the upcoming election.",
                            iconName: "person.text.rectangle.fill"
                        )
                        .padding(.horizontal)

                        InfoCardView(
                            title: "Voting Requirements",
                            description: "Understand what identification and materials you need to bring with you on election day.",
                            iconName: "checklist"
                        )
                        .padding(.horizontal)
                    }

                    Divider()
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        Button {
                            showNotifications = true
                        } label: {
                            SettingsRowView(title: "Notification Preferences", iconName: "bell.fill")
                        }
                        .background(
                            NavigationLink(destination: NotificationSettingsView()
                                            .navigationBarTitle("Notifications", displayMode: .inline),
                                           isActive: $showNotifications) {
                                EmptyView()
                            }
                            .hidden()
                        )
                            .padding(.horizontal)

                        SettingsRowView(title: "Privacy Settings", iconName: "lock.fill")
                            .padding(.horizontal)

                        SettingsRowView(title: "Help & Support", iconName: "questionmark.circle.fill")
                            .padding(.horizontal)

                        SettingsRowView(title: "About ElectConnect", iconName: "info.circle.fill")
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Voting & Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Text(userEmail)
                        Button(role: .destructive) {
                            showingLogoutAlert = true
                        } label: {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                }
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        withAnimation {
                            isLoggedIn = false
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct SettingsRowView: View {
    var title: String
    var iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color("PrimaryBlue"))
                .frame(width: 30, height: 30)

            Text(title)
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct InfoCardView: View {
    var title: String
    var description: String
    var iconName: String

    @State private var isPresentingMoreInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("PrimaryBlue"))
            }

            Button(action: {
                isPresentingMoreInfo = true
            }) {
                Text("Learn More")
                    .font(.caption)
                    .foregroundColor(Color("PrimaryBlue"))
                    .padding(.top, 5)
            }
            .sheet(isPresented: $isPresentingMoreInfo) {
                MoreInfoView(title: title, contentSections: detailedSections(for: title))
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    func detailedSections(for title: String) -> [InfoSection] {
        switch title {
        case "How to Register":
            return [
                InfoSection(
                    heading: "Online Registration",
                    body: [
                        "Register online through the Virginia Department of Elections.",
                        "You'll need a valid Virginia driver’s license or state-issued ID."
                    ],
                    link: URL(string: "https://vote.elections.virginia.gov/VoterInformation"),
                    iconName: "desktopcomputer"
                ),
                InfoSection(
                    heading: "Register by Mail",
                    body: [
                        "Print and complete the application form, then mail it to your local registrar.",
                        "It must be postmarked by the registration deadline."
                    ],
                    link: URL(string: "https://www.elections.virginia.gov/registration/how-to-register/"),
                    iconName: "envelope.fill"
                ),
                InfoSection(
                    heading: "Register In Person",
                    body: [
                        "Visit your local registrar’s office, DMV, or other designated agencies.",
                        "Make sure to bring valid identification."
                    ],
                    link: nil,
                    iconName: "person.crop.circle.badge.checkmark"
                ),
                InfoSection(
                    heading: "Deadline",
                    body: [
                        "Registration must be completed 22 days before the election.",
                        "Some late registration may be possible during early voting."
                    ],
                    link: nil,
                    iconName: "calendar"
                )
            ]

        case "Voting Requirements":
            return [
                InfoSection(
                    heading: "Eligibility",
                    body: [
                        "You must be a U.S. citizen, a resident of Virginia, and at least 18 years old by election day.",
                        "You must not be under a disqualifying felony conviction (unless rights restored)."
                    ],
                    link: nil,
                    iconName: "checkmark.shield"
                ),
                InfoSection(
                    heading: "Accepted ID",
                    body: [
                        "Bring a valid ID such as a driver’s license, U.S. passport, or student ID.",
                        "No ID? You can sign an ID Confirmation Statement at the polls."
                    ],
                    link: URL(string: "https://www.elections.virginia.gov/registration/voter-id/"),
                    iconName: "person.text.rectangle"
                ),
                InfoSection(
                    heading: "Need Help?",
                    body: [
                        "Check your registration status or find official resources at the Virginia Elections site."
                    ],
                    link: URL(string: "https://www.elections.virginia.gov/"),
                    iconName: "questionmark.circle"
                )
            ]

        default:
            return [
                InfoSection(
                    heading: "Coming Soon",
                    body: ["More details will be available soon."],
                    link: nil,
                    iconName: "clock"
                )
            ]
        }
    }


}

struct MoreInfoView: View {
    var title: String
    var contentSections: [InfoSection]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                ForEach(contentSections) { section in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Text(section.heading)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Image(systemName: section.iconName ?? "info.circle.fill")
                                .foregroundColor(Color("PrimaryBlue"))
                                .imageScale(.large)
                        }

                        ForEach(section.body, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .foregroundColor(.primary)
                        }

                        if let url = section.link {
                            Link("Learn more", destination: url)
                                .font(.subheadline)
                                .foregroundColor(Color("PrimaryBlue"))
                                .padding(.top, 5)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                }

                Spacer()
            }
            .padding()
        }
    }
}


struct InfoSection: Identifiable {
    let id = UUID()
    let heading: String
    let body: [String]
    let link: URL?
    let iconName: String?
}

struct VotingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VotingInfoView()
    }
}
