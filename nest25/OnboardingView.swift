import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarded: Bool
    @State private var currentPage = 0
    @State private var selectedTopics: [String] = []
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to ElectConnect",
            description: "Your platform for staying informed and engaged in the democratic process.",
            imageName: "person.3.fill",
            buttonText: "Next"
        ),
        OnboardingPage(
            title: "Town Hall",
            description: "Watch live streams of candidate events and stay connected with your representatives.",
            imageName: "video.fill",
            buttonText: "Next"
        ),
        OnboardingPage(
            title: "News Feed",
            description: "Get the latest news and updates about elections and candidates.",
            imageName: "newspaper.fill",
            buttonText: "Next"
        ),
        OnboardingPage(
            title: "Voting Information",
            description: "Submit your preferences with our quiz to tailor your experience.",
            imageName: "info.circle.fill",
            buttonText: "Submit Your Preferences With Our Quiz!"
        ),
        OnboardingPage(
            title: "Choose Your Interests",
            description: "Select topics you’re interested in to tailor your news and updates.",
            imageName: "star.circle.fill",
            buttonText: "Get Started!"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        if index == pages.count - 1 {
                            QuizPage(selectedTopics: $selectedTopics, isOnboarded: $isOnboarded)
                                .tag(index)
                        } else {
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Spacer()
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            isOnboarded = true
                        }
                    }
                }) {
                    Text(pages[currentPage].buttonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
                if currentPage < pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentPage = pages.count - 1
                        }
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct QuizPage: View {
    @Binding var selectedTopics: [String]
    @Binding var isOnboarded: Bool
    
    let topics = [
        ("Tech", "desktopcomputer", "Tech"),
        ("Econ", "chart.bar.fill", "Econ"),
        ("Environmental", "leaf.fill", "Environmental"),
        ("Globalization", "globe.europe.africa.fill", "Globalization"),
        ("Immigration", "figure.wave", "Immigration")
    ]
    
    var body: some View {
        VStack {
            Text("Select Your Topics")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryBlue"))
                .padding(.top, 30)
            
            Text("Choose topics you're interested in to personalize your feed.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 30)
            
            // Create a grid of topics
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(topics, id: \.0) { topic in
                    Button(action: {
                        if selectedTopics.contains(topic.2) {
                            selectedTopics.removeAll { $0 == topic.2 }
                        } else {
                            selectedTopics.append(topic.2)
                        }
                    }) {
                        HStack {
                            Image(systemName: topic.1)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("PrimaryBlue"))
                            
                            Text(topic.0)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedTopics.contains(topic.2) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("PrimaryBlue"))
                            }
                        }
                        .padding()
                        .background(selectedTopics.contains(topic.2) ? Color("PrimaryBlue").opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedTopics.contains(topic.2) ? Color("PrimaryBlue") : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            
            Spacer()

            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .padding()
    }
}

struct OnboardingPage: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageName: String
    var buttonText: String
}

struct OnboardingPageView: View {
    var page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(Color("PrimaryBlue"))
                .padding(.top, 50)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryBlue"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboarded: .constant(false))
    }
}
