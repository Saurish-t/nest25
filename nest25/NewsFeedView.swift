import SwiftUI
import UIKit

struct NewsFeedView: View {
    @State private var articles: [Article] = []
    
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
            .onAppear {
                fetchArticles()
            }
        }
    }
    
    private func fetchArticles() {
        guard let url = URL(string: "http://192.168.137.161:5004/articles") else { return }
        
        let requestBody: [String: Any] = [
            "article_count": 10, // Example value, replace with actual data from quiz/poll
            "topics": ["econ", "environ"] // Example topics, replace with actual data
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Log raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw response: \(rawResponse)")
            }
            
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                if let errorMessage = serverResponse.error, errorMessage != "None" {
                    print("Server error: \(errorMessage)")
                    return
                }
                
                // Decode the JSON-encoded string in the articles field
                if let articlesData = serverResponse.articles.data(using: .utf8) {
                    let decodedArticles = try JSONDecoder().decode([Article].self, from: articlesData)
                    DispatchQueue.main.async {
                        self.articles = decodedArticles
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

// Define a struct for the server response
struct ServerResponse: Decodable {
    var error: String? // Error message, if any
    var articles: String // JSON-encoded string of articles
}

struct Article: Identifiable, Decodable {
    var id: URL { url } // Use the unique URL as the identifier
    var url: URL
    var title: String
    var bias: String
    var summary: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case title
        case bias
        case summary
        case category
    }
}

struct ArticleCardView: View {
    var article: Article
    @State private var showShareSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "doc.text.fill")
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
                        Text(article.bias)
                            .font(.caption)
                            .foregroundColor(Color("PrimaryBlue"))
                        
                        Spacer()
                        
                        Text(article.category.capitalized)
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
                    UIApplication.shared.open(article.url)
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
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [article.url])
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
