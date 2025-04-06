import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TownHallView()
                .tabItem {
                    Label("Town Hall", systemImage: "video.fill")
                }
                .tag(0)
            
            NewsFeedView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
                .tag(1)
            
            PollingPlacesView()
                .tabItem {
                    Label("Polling", systemImage: "mappin.circle.fill")
                }
                .tag(2)
            
            VotingInfoView()
                .tabItem {
                    Label("Voting", systemImage: "info.circle.fill")
                }
                .tag(3)
            
            VoiceMattersView()
                .tabItem {
                    Label("Voice Matters", systemImage: "person.3.fill")
                }
                .tag(4)
        }
        .accentColor(Color("PrimaryBlue"))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
