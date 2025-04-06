import SwiftUI

struct VotingInfoView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @AppStorage("userEmail") private var userEmail: String = ""
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color("PrimaryBlue"))
                        
                        Text(userEmail)
                            .font(.headline)
                        
                        Button(action: {
                            showingLogoutAlert = true
                        }) {
                            Text("Log Out")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Voting Information Section
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
                            title: "Find Your Polling Place",
                            description: "Locate your designated polling location based on your registered address.",
                            iconName: "mappin.and.ellipse"
                        )
                        .padding(.horizontal)
                        
                        InfoCardView(
                            title: "Voting Requirements",
                            description: "Understand what identification and materials you need to bring with you on election day.",
                            iconName: "checklist"
                        )
                        .padding(.horizontal)
                        
                        InfoCardView(
                            title: "Absentee Voting",
                            description: "Learn how to request and submit an absentee ballot if you cannot vote in person.",
                            iconName: "envelope.fill"
                        )
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Settings Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        SettingsRowView(title: "Notification Preferences", iconName: "bell.fill")
                            .padding(.horizontal)
                        
                        SettingsRowView(title: "Privacy Settings", iconName: "lock.fill")
                            .padding(.horizontal)
                        
                        SettingsRowView(title: "Help & Support", iconName: "questionmark.circle.fill")
                            .padding(.horizontal)
                        
                        SettingsRowView(title: "About ConnecterElector", iconName: "info.circle.fill")
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Voting & Profile")
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

struct InfoCardView: View {
    var title: String
    var description: String
    var iconName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("PrimaryBlue"))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    // Action to view more information
                }) {
                    Text("Learn More")
                        .font(.caption)
                        .foregroundColor(Color("PrimaryBlue"))
                        .padding(.top, 5)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SettingsRowView: View {
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            // Navigate to respective setting screen
        }) {
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
}

struct VotingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VotingInfoView()
    }
}

