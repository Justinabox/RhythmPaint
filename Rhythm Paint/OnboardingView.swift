import SwiftUI

struct OnboardingView: View {
    var onFinished: () -> Void
    
    @State private var currentPage: Int = 0
    
    private struct Page: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let detail: String
        let symbolName: String
    }
    
    private let pages: [Page] = [
        Page(
            title: "Sketch your sound",
            subtitle: "Draw lines to create notes",
            detail: "Drag your fingers across the canvas. Every stroke becomes a musical phrase that glides past the play bar.",
            symbolName: "scribble.variable"
        ),
        Page(
            title: "Height controls pitch",
            subtitle: "Higher lines, higher notes",
            detail: "Lines near the top sound bright and high. Lines near the bottom sound deep and low.",
            symbolName: "waveform.path.ecg"
        )
    ]
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isCompactHeight = size.height < 500
            
            ZStack {
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.14, green: 0.08, blue: 0.3),
                        Color(red: 0.03, green: 0.17, blue: 0.35)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: isCompactHeight ? 16 : 24) {
                    HStack {
                        Text("Quick tour")
                            .font(.system(size: isCompactHeight ? 16 : 18, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.7))
                        
                        Spacer()
                        
                        Button(action: onFinished) {
                            Text("Skip")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, isCompactHeight ? 16 : 24)
                    
                    Spacer(minLength: 0)
                    
                    TabView(selection: $currentPage) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                            pageView(for: page, size: size, isCompactHeight: isCompactHeight)
                                .tag(index)
                                .padding(.horizontal, 32)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: min(size.height * 0.75, 420))
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Capsule()
                                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.25))
                                    .frame(width: index == currentPage ? 20 : 8, height: 4)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, isCompactHeight ? 16 : 24)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func pageView(for page: Page, size: CGSize, isCompactHeight: Bool) -> some View {
        HStack(spacing: isCompactHeight ? 20 : 32) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: page.symbolName)
                    .font(.system(size: isCompactHeight ? 42 : 52, weight: .regular, design: .rounded))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.white, Color.accentColor)
                    .padding(.bottom, 4)
                
                Text(page.title)
                    .font(.system(size: isCompactHeight ? 30 : 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                
                Text(page.subtitle)
                    .font(.system(size: isCompactHeight ? 18 : 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.85))
                
                Text(page.detail)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .padding(.top, 8)
                
                Spacer()
                
                HStack {
                    Button(action: advance) {
                        HStack(spacing: 10) {
                            Text(currentPage == pages.count - 1 ? "Start painting" : "Next")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            
                            Image(systemName: currentPage == pages.count - 1 ? "checkmark" : "chevron.right")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundStyle(Color.black)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)
                }
            }.padding(.bottom, 20)
            
            Spacer(minLength: 16)
            
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                    )
                
                GeometryReader { inner in
                    let h = inner.size.height
                    let w = inner.size.width
                    let centerY = h / 2
                    
                    ForEach(-3...3, id: \.self) { index in
                        let offset = CGFloat(index) * (h / 10)
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: centerY + offset))
                            path.addLine(to: CGPoint(x: w, y: centerY + offset))
                        }
                        .stroke(Color.white.opacity(index == 0 ? 0.35 : 0.15), lineWidth: index == 0 ? 1.5 : 1)
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: w * 0.15, y: h * 0.25))
                        path.addCurve(
                            to: CGPoint(x: w * 0.85, y: h * 0.45),
                            control1: CGPoint(x: w * 0.35, y: h * 0.05),
                            control2: CGPoint(x: w * 0.65, y: h * 0.65)
                        )
                    }
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    
                    Path { path in
                        path.move(to: CGPoint(x: w * 0.1, y: h * 0.7))
                        path.addCurve(
                            to: CGPoint(x: w * 0.9, y: h * 0.6),
                            control1: CGPoint(x: w * 0.3, y: h * 0.9),
                            control2: CGPoint(x: w * 0.65, y: h * 0.4)
                        )
                    }
                    .stroke(Color.pink.opacity(0.9), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    
                    let markerSize: CGFloat = 14
                    let markerRect = CGRect(
                        x: w * 0.18 - markerSize / 2,
                        y: centerY - markerSize / 2,
                        width: markerSize,
                        height: markerSize
                    )
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: markerRect.width, height: markerRect.height)
                        .position(x: markerRect.midX, y: markerRect.midY)
                        .shadow(color: Color.accentColor.opacity(0.6), radius: 8, x: 0, y: 0)
                }
                .padding(20)
            }
            .frame(width: max(size.width * 0.32, 260), height: min(size.height * 0.7, 340))
        }
    }
    
    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentPage += 1
            }
        } else {
            onFinished()
        }
    }
}

#Preview {
    OnboardingView(onFinished: {})
}


