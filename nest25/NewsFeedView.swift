import SwiftUI
import UIKit

struct NewsFeedView: View {
    @State private var articles = [
        Article(
            title: "City Council Approves New Budget",
            summary: "The city council has approved a new budget for the upcoming fiscal year with increased funding for education and infrastructure.",
            source: "Local News",
            date: "April 5, 2023",
            imageSystemName: "building.columns.fill",
            politicalFavorability: 0.5,
            articleURL: URL(string: "https://example.com/article1")!,
            category: "Local News",
            categoryIcon: "house.fill"
        ),
        Article(
            title: "Election Day Polling Locations Announced",
            summary: "The election commission has released the list of polling locations for the upcoming election. Check if your polling place has changed.",
            source: "Election Commission",
            date: "April 3, 2023",
            imageSystemName: "mappin.circle.fill",
            politicalFavorability: 0.7,
            articleURL: URL(string: "https://example.com/article2")!,
            category: "Election",
            categoryIcon: "calendar.circle.fill"
        ),
        Article(
            title: "Candidate Smith Unveils Education Plan",
            summary: "Mayoral candidate Jane Smith has unveiled her comprehensive education plan focusing on teacher retention and school infrastructure.",
            source: "Campaign News",
            date: "April 1, 2023",
            imageSystemName: "book.fill",
            politicalFavorability: 0.3,
            articleURL: URL(string: "https://example.com/article3")!,
            category: "Campaign",
            categoryIcon: "star.circle.fill"
        ),
        Article(
            title: "Voter Registration Deadline Approaching",
            summary: "The deadline to register to vote in the upcoming election is April 15. Make sure you're registered to have your voice heard.",
            source: "Voter Information",
            date: "March 28, 2023",
            imageSystemName: "calendar.badge.exclamationmark",
            politicalFavorability: 0.5,
            articleURL: URL(string: "https://example.com/article4")!,
            category: "Voting",
            categoryIcon: "person.3.fill"
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
    var politicalFavorability: Double
    var articleURL: URL?
    var category: String
    var categoryIcon: String
}

struct ArticleCardView: View {
    var article: Article
    @State private var showShareSheet = false
    
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
                    // Open URL for the article
                    if let url = article.articleURL {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Read More")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryBlue"))
                }
                
                Spacer()
                
                Button(action: {
                    self.showShareSheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color("PrimaryBlue"))
                }
            }
            
            // Political favorability indicator and white line inside the gradient, placed between buttons
            VStack {
                HStack {
                    Spacer()
                    
                    ZStack {
                        // Elongated "worm" shape for the political favorability indicator
                        RoundedRectangle(cornerRadius: 13)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 100, height: 20)
                            .offset(x: CGFloat((article.politicalFavorability - 3.3) * 40))
                            .offset(y: CGFloat((article.politicalFavorability - 1.3) * 40))
                        
                        // White line to indicate the position of political favorability
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 2, height: 18)
                            .offset(x: CGFloat((article.politicalFavorability - 3.3) * 40))
                            .offset(y: CGFloat((article.politicalFavorability - 1.3) * 40))
                    }
                     // Adjust to position the "worm" just below the article
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [article.articleURL!]) // Force unwrapping is fine since URL is guaranteed
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
