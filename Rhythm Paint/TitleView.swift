import SwiftUI
struct TitleView: View {
    var onFinished: () -> Void
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isCompactHeight = size.height < 500
            
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Rhythm Paint")
                        .font(.system(size: isCompactHeight ? 42 : 56, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)
                    
                    Text("Draw sound.\nSee rhythm.")
                        .font(.system(size: isCompactHeight ? 20 : 26, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.85))
                        .padding(.top, 8)
                    
                    Text("Use your fingers to sketch melody and rhythm across the canvas.")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.8))
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    Button(action: onFinished) {
                        HStack(spacing: 12) {
                            Text("Next")
                                .fontWeight(.semibold)
                            Image(systemName: "play.fill")
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(.white)
                        .foregroundStyle(Color.black)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, isCompactHeight ? 12 : 24)
                }
                .padding(.leading, 40)
                .padding(.vertical, isCompactHeight ? 48 : 72)
                
                Spacer(minLength: 20)
                
                // Simple abstract preview of the experience
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                        )
                    
                    GeometryReader { inner in
                        let h = inner.size.height
                        let w = inner.size.width
                        let centerY = h / 2
                        
                        // Horizontal guide lines
                        ForEach(-3...3, id: \.self) { index in
                            let offset = CGFloat(index) * (h / 10)
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: centerY + offset))
                                path.addLine(to: CGPoint(x: w, y: centerY + offset))
                            }
                            .stroke(Color.white.opacity(index == 0 ? 0.35 : 0.15), lineWidth: index == 0 ? 1.5 : 1)
                        }
                        
                        // Stylized strokes
                        Path { path in
                            path.move(to: CGPoint(x: w * 0.15, y: h * 0.25))
                            path.addCurve(
                                to: CGPoint(x: w * 0.85, y: h * 0.45),
                                control1: CGPoint(x: w * 0.35, y: h * 0.05),
                                control2: CGPoint(x: w * 0.65, y: h * 0.65)
                            )
                        }
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        
                        Path { path in
                            path.move(to: CGPoint(x: w * 0.1, y: h * 0.7))
                            path.addCurve(
                                to: CGPoint(x: w * 0.9, y: h * 0.6),
                                control1: CGPoint(x: w * 0.3, y: h * 0.9),
                                control2: CGPoint(x: w * 0.65, y: h * 0.4)
                            )
                        }
                        .stroke(Color.pink.opacity(0.9), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                        
                        // Play marker
                        let markerSize: CGFloat = 16
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
                    .padding(24)
                }
                .frame(width: max(size.width * 0.35, 280), height: min(size.height * 0.8, 380))
                .padding(.trailing, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
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
            )
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    TitleView(onFinished: {})
}
