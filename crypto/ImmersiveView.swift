import SwiftUI
import RealityKit
import RealityKitContent

var event: EventSubscription?
var animationPlayback: AnimationPlaybackController?

struct ImmersiveView: View {
    
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow

    @State private var ball = Entity()
    @Binding var bitcoinBalance: String
    @Binding var bitcoinValue: String
    @Binding var currency: String
    var fetchBitcoinPrice: () -> Void

    var body: some View {
        RealityView { content in
            dismissWindow(id: "StartingWindow")
            self.ball = try! await Entity(named: "bitcoin", in: realityKitContentBundle)
            ball.scale = [2, 2, 2]
            ball.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]);
            content.add(ball)
        } update: { content in
           if let model = content.entities.first {
            performSpin(on: model)
            setUpObservers(content: content, model: model)
           }
        }

        Text("Your Bitcoin Balance: \(bitcoinBalance) \(currency)")
            .font(.system(size: 80))
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .multilineTextAlignment(.center)
            .offset(y: -100)

        Text("Bitcoin Value: \(bitcoinValue) \(currency)")
            .font(.system(size: 50))
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .offset(y: -100)

        HStack {
            Button(action: {
                openWindow(id: "StartingWindow")
                dismissWindow(id: "ImmersiveSpace")
            }) {
              Label("Go Back", systemImage: "arrowshape.backward.fill")
                .padding()
                .font(.system(size: 48))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .tint(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                fetchBitcoinPrice()

            }) {
              Label("Refresh", systemImage: "arrow.clockwise")
                .padding()
                .font(.system(size: 48))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .tint(.white)
                .cornerRadius(10)
            }
        }
        .offset(y: -100)
       
    }

    func performSpin(on model: Entity) {
        guard let ball = model.children.first else { return }
        animationPlayback = ball.move(to: .init(yaw: -.pi), relativeTo: ball, duration: 2.5, timingFunction: .linear)
    }

    func setUpObservers(content: RealityViewContent, model: Entity){
        event?.cancel()

        event = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: model.children.first!) { event in
            if animationPlayback == event.playbackController {
                performSpin(on: model)
            }        
            }
    }
}

#Preview {
    let bitcoinBalance = Binding.constant("0.0")
    let bitcoinValue = Binding.constant("0.0")
    let currency = Binding.constant("USD")

    return ImmersiveView(
                    bitcoinBalance: bitcoinBalance,
                    bitcoinValue: bitcoinValue,
                    currency: currency,
                    fetchBitcoinPrice: {}
                   ).previewLayout(.sizeThatFits)
}
