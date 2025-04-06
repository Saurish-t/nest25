import SwiftUI

struct TownHallView: View {
    @State private var isLiveStreamPlaying = false
    @State private var upcomingEvents = [
        Event(title: "Mayoral Debate", date: "May 15, 2023", time: "7:00 PM"),
        Event(title: "Town Council Meeting", date: "May 20, 2023", time: "6:30 PM"),
        Event(title: "Candidate Q&A Session", date: "May 25, 2023", time: "5:00 PM")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Live Stream Section
                    VStack(alignment: .leading) {
                        Text("Live Now")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.8))
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(12)
                            
                            if isLiveStreamPlaying {
                                // This would be replaced with an actual video player in a real app
                                Text("Live Stream Playing")
                                    .foregroundColor(.white)
                            } else {
                                VStack {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                    
                                    Text("Tap to Watch Live")
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation {
                                isLiveStreamPlaying.toggle()
                            }
                        }
                        
                        Text("Mayoral Candidate Town Hall")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text("Join us for a live discussion with the mayoral candidates as they address key issues facing our community.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Upcoming Events Section
                    VStack(alignment: .leading) {
                        Text("Upcoming Events")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ForEach(upcomingEvents) { event in
                            EventCardView(event: event)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Town Hall")
        }
    }
}

struct Event: Identifiable {
    var id = UUID()
    var title: String
    var date: String
    var time: String
}

struct EventCardView: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(Color("PrimaryBlue"))
                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "clock")
                    .foregroundColor(Color("PrimaryBlue"))
                Text(event.time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                // Add to calendar functionality would go here
            }) {
                Text("Add to Calendar")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color("PrimaryBlue"))
                    .cornerRadius(8)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TownHallView_Previews: PreviewProvider {
    static var previews: some View {
        TownHallView()
    }
}

