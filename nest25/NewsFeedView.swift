import SwiftUI

struct NewsFeedView: View {
    @State private var articles = [
        Article(
            title: "City Council Approves New Budget",
            summary: "The city council has approved a new budget for the upcoming fiscal year with increased funding for education and infrastructure.",
            source: "Local News",
            date: "April 5, 2023",
            imageSystemName: "building.columns.fill"
        ),
        Article(
            title: "Election Day Polling Locations Announced",
            summary: "The election commission has released the list of polling locations for the upcoming election. Check if your polling place has changed.",
            source: "Election Commission",
            date: "April 3, 2023",
            imageSystemName: "mappin.circle.fill"
        ),
        Article(
            title: "Candidate Smith Unveils Education Plan",
            summary: "Mayoral candidate Jane Smith has unveiled her comprehensive education plan focusing on teacher retention and school infrastructure.",
            source: "Campaign News",
            date: "April 1, 2023",
            imageSystemName: "book.fill"
        ),
        Article(
            title: "Voter Registration Deadline Approaching",
            summary: "The deadline to register to vote in the upcoming election is April 15. Make sure you're registered to have your voice heard.",
            source: "Voter Information",
            date: "March 28, 2023",
            imageSystemName: "calendar.badge.exclamationmark"
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(articles) { article in
                        ArticleCardView(article: article)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("News Feed")
        }
    }
}

struct Article: Identifiable {
    var id = UUID()
    var title: String
    var summary: String
    var source: String
    var date: String
    var imageSystemName: String
}

struct ArticleCardView: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: article.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("PrimaryBlue"))
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Text(article.source)
                            .font(.caption)
                            .foregroundColor(Color("PrimaryBlue"))
                        
                        Spacer()
                        
                        Text(article.date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text(article.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Button(action: {
                    // Read more functionality would go here
                }) {
                    Text("Read More")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryBlue"))
                }
                
                Spacer()
                
                Button(action: {
                    // Share functionality would go here
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color("PrimaryBlue"))
                }
                
                Button(action: {
                    // Bookmark functionality would go here
                }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(Color("PrimaryBlue"))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}

