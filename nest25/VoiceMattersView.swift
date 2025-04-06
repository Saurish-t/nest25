import SwiftUI

struct VoiceMattersView: View {
    @State private var showingPieChart = false
    
    let demographicsData = [
        ("Age 18-29", 50.0, "Young voters have increased turnout in recent years."),
        ("Women", 68.0, "Women consistently vote at higher rates than men."),
        ("Hispanic Voters", 54.0, "Hispanic turnout reached a record high in 2020.")
    ]
    
    let personalStories = [
        (
            title: "The Childcare Barrier to Voting",
            imageName: "single-mom-story",
            story: "In 2024, nonvoters like single moms were identified as a critical group that often misses elections due to lack of childcare. Advocacy groups have started targeting these caregivers, knowing their votes could influence local policies such as education and family support.",
            impact: "Voting could help reshape support systems for working parents.",
            articleURL: "https://19thnews.org/2024/10/caregivers-single-moms-non-voters-2024/?utm_source=chatgpt.com"
        ),
        (
            title: "The Vote He Didn't Cast",
            imageName: "damion-green-story",
            story: "In 2023, Damion Green lost his city council race in Washington by a single vote—his own. He skipped voting because he thought it would be 'narcissistic' to vote for himself. His opponent did vote and won. The loss drew national attention, highlighting how one vote really can decide an election.",
            impact: "A single vote could have changed his entire career.",
            articleURL: "https://www.businessinsider.com/political-candidate-didnt-vote-lost-election-one-ballot-thurston-washington-2023-12?utm_source=chatgpt.com"
        ),
        (
            title: "Immigrants Facing Language Barriers",
            imageName: "imigrant-voter-story",
            story: "In 2024, language barriers continued to prevent many immigrant voters from casting ballots. Without sufficient translation support or multilingual resources at polling places, these eligible citizens remain underrepresented in elections that directly affect their lives.",
            impact: "Language access could unlock political power for entire communities.",
            articleURL: "https://calmatters.org/california-divide/2024/03/immigrant-voter-rights/?utm_source=chatgpt.com"
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("My Voice Matters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Demographics of Voting")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: {
                                showingPieChart = true
                            }) {
                                Image(systemName: "chart.pie.fill")
                                    .foregroundColor(.blue)
                                    .imageScale(.large)
                            }
                        }
                        .padding(.horizontal)
                        
                        ForEach(demographicsData, id: \.0) { demographic in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(demographic.0)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(Int(demographic.1))%")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                Text(demographic.2)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    .sheet(isPresented: $showingPieChart) {
                        DemographicsPieChartView(demographicsData: demographicsData)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Personal Stories of Impact")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ForEach(personalStories.indices, id: \.self) { index in
                            let story = personalStories[index]
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Image(story.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                
                                Text(story.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                Text(story.story)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                                
                                Text(story.impact)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                
                                Link("Read Full Story →", destination: URL(string: story.articleURL)!)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Learn More")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: ImportanceOfVotingView()) {
                            HStack {
                                Text("The Importance of Voting")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        NavigationLink(destination: VoterTurnoutStatsView()) {
                            HStack {
                                Text("Voter Turnout Statistics")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        NavigationLink(destination: VotingInfoView()) {
                            HStack {
                                Text("How to Register to Vote")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DemographicsPieChartView: View {
    let demographicsData: [(String, Double, String)]
    
    private var sliceAngles: [(startAngle: Double, endAngle: Double)] {
        let total: Double = 100
        var startAngle: Double = -90
        var angles: [(Double, Double)] = []
        
        for index in demographicsData.indices {
            let percentage = demographicsData[index].1
            let angle = (percentage / total) * 360
            let endAngle = startAngle + angle
            angles.append((startAngle, endAngle))
            startAngle = endAngle
        }
        
        return angles
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Voter Turnout by Demographic")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            ZStack {
                ForEach(demographicsData.indices, id: \.self) { index in
                    PieChartSlice(
                        startAngle: Angle(degrees: sliceAngles[index].startAngle),
                        endAngle: Angle(degrees: sliceAngles[index].endAngle),
                        color: [Color.blue, Color.purple, Color.orange][index]
                    )
                }
            }
            .frame(width: 200, height: 200)
            
            VStack(spacing: 10) {
                ForEach(demographicsData.indices, id: \.self) { index in
                    HStack {
                        Circle()
                            .fill([Color.blue, Color.purple, Color.orange][index])
                            .frame(width: 20, height: 20)
                        Text("\(demographicsData[index].0): \(Int(demographicsData[index].1))%")
                            .font(.body)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct PieChartSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

// Importance of Voting View
struct ImportanceOfVotingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The Importance of Voting")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Why Your Vote Matters")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Voting is the cornerstone of democracy, a fundamental right that allows citizens to shape their government and influence policies that affect their daily lives. In the United States, the right to vote has been hard-won through centuries of struggle—think of the suffragettes who fought for women’s voting rights in 1920 or the Civil Rights activists who marched in Selma in 1965 to secure voting rights for Black Americans. Each vote cast is a tribute to those sacrifices and a step toward a more equitable future.")
                        .font(.body)
                    
                    Text("When you vote, you’re not just choosing a candidate—you’re deciding on issues that impact your community, from school funding to healthcare access to environmental protections. For example, local elections often determine school board members who decide how much funding goes to public education. In 2020, a school board election in Fairfax County, VA, was decided by fewer than 500 votes, directly affecting classroom sizes and teacher salaries.")
                        .font(.body)
                    
                    Text("Your vote also sends a message. High voter turnout signals to elected officials that the public is engaged and holding them accountable. In the 2020 election, the U.S. saw a record-breaking 66.8% turnout—the highest in over a century—leading to increased attention on issues like climate change and racial justice. Conversely, when turnout is low, politicians may prioritize the interests of the few who do vote, often sidelining underrepresented groups like young people or minorities.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("The Consequences of Not Voting")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Choosing not to vote can have ripple effects. In the 2016 U.S. presidential election, only 56% of eligible voters turned out, and the results led to significant policy shifts, including changes to healthcare, immigration, and environmental regulations. In Michigan, the election was decided by just 10,704 votes—a margin smaller than the number of people who didn’t vote in some precincts.")
                        .font(.body)
                    
                    Text("On a local level, the impact can be even more direct. In 2018, a city council election in Alexandria, VA, was decided by a single vote, determining whether a new community center would be built. Those who didn’t vote missed the chance to influence a project that could have provided resources for their neighborhood.")
                        .font(.body)
                    
                    Text("Not voting can also perpetuate systemic inequalities. When certain groups—like young people or minorities—don’t vote, their needs are often ignored. For instance, in 2020, only 50% of voters aged 18-29 turned out, compared to 76% of those over 65. As a result, policies often favor older demographics, such as increased funding for Medicare over student loan relief.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Voter Turnout Statistics View
struct VoterTurnoutStatsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Voter Turnout Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Historical Trends")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Voter turnout in the U.S. has fluctuated over time, often reflecting the political climate. In the 19th century, turnout regularly exceeded 80%, driven by high engagement in local politics. However, by the early 20th century, turnout began to decline, dipping to 49% in 1920 due to restrictive voting laws and disenfranchisement of Black and immigrant communities.")
                        .font(.body)
                    
                    Text("The Voting Rights Act of 1965 marked a turning point, outlawing discriminatory practices and boosting turnout among Black voters. By 2020, overall turnout reached 66.8%—the highest since 1900—fueled by increased mail-in voting and heightened political awareness during the COVID-19 pandemic.")
                        .font(.body)
                    
                    Text("However, turnout varies widely by state. In 2020, Minnesota led with 80% turnout, thanks to same-day registration and robust voter education programs, while West Virginia lagged at 53%, affected by voter suppression and economic challenges.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Demographic Breakdown")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Turnout differs significantly across demographics. In 2020, 76% of voters aged 65 and older cast ballots, compared to just 50% of those aged 18-29, highlighting a generational gap. Education also plays a role: 79% of college graduates voted, compared to 54% of those with a high school education or less.")
                        .font(.body)
                    
                    Text("Racial and ethnic disparities persist. White voters had a 71% turnout rate in 2020, while Black voters reached 63%, Hispanic voters 54%, and Asian voters 60%. These gaps are often due to systemic barriers like voter ID laws, limited polling access, and language challenges.")
                        .font(.body)
                    
                    Text("Gender differences are notable too. Women have outvoted men in every presidential election since 1980, with a 68% turnout rate in 2020 compared to 65% for men. This trend underscores the importance of women’s voices in shaping policy on issues like healthcare and education.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("What Drives Turnout?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Several factors influence voter turnout. Access to early voting and mail-in ballots significantly boosts participation—in 2020, 46% of voters used these methods, up from 21% in 2016. Conversely, restrictive laws like voter ID requirements can suppress turnout, particularly among low-income and minority voters.")
                        .font(.body)
                    
                    Text("Education and outreach also matter. States with robust voter education programs, like Colorado, consistently see turnout above 70%. In contrast, states with limited resources for voter outreach, like Mississippi, often fall below 60%.")
                        .font(.body)
                    
                    Text("Finally, the stakes of an election play a role. Presidential elections typically see higher turnout (66.8% in 2020) than midterms (50% in 2018), as voters perceive greater impact in national races. Local elections, despite their direct impact, often see turnout below 30%, highlighting a disconnect in civic engagement.")
                        .font(.body)
                }
                .padding(.horizontal)
                
            }
        }
    }
}


struct VoiceMattersView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceMattersView()
    }
}
