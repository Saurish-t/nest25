import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarded: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to ConnecterElector",
            description: "Your platform for staying informed and engaged in the democratic process.",
            imageName: "person.3.fill"
        ),
        OnboardingPage(
            title: "Town Hall",
            description: "Watch live streams of candidate events and stay connected with your representatives.",
            imageName: "video.fill"
        ),
        OnboardingPage(
            title: "News Feed",
            description: "Get the latest news and updates about elections and candidates.",
            imageName: "newspaper.fill"
        ),
        OnboardingPage(
            title: "Voting Information",
            description: "Access important information about how and where to vote.",
            imageName: "info.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
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
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
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
                            isOnboarded = true
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

struct OnboardingPage: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageName: String
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

