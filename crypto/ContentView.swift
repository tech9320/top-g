import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Binding var bitcoinBalance: String
    @Binding var bitcoinValue: String
    @Binding var enteredBitcoinAmount: String
    @Binding var currency: String
    var fetchBitcoinPrice: () -> Void
    var calculateYourBitcoinBalance: () -> Void

    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        
        HStack {
            
            VStack {
                Image(.logo)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .padding(.bottom, 20)
                
                Text("CryptoBalance Pal - Your Virtual Crypto Companion")

                Text("Welcome to CryptoBalance Pal, your one-stop solution for tracking your Bitcoin holdings in an immersive experience. Seamlessly manage your cryptocurrency portfolio with a user-friendly interface designed for the Apple Vision Pro.")
                    .padding(.horizontal, 80)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .onAppear() {
                dismissWindow(id: "ImmersiveSpace")
                fetchBitcoinPrice()
            }
            
            
            VStack {
                
                Text("Current Bitcoin Value:")
                Text("\(self.bitcoinValue) \(self.currency)")
                    
                TextField("Enter Your Bitcoin Amount", text: $enteredBitcoinAmount)
                    .keyboardType(.decimalPad)
                    .frame(width: 250)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)
                    .onChange(of: enteredBitcoinAmount) {
                        calculateYourBitcoinBalance()
                    }
                
           
                Text("Your Holdings: \(bitcoinBalance) \(currency)")
                    .padding(.top, 20)
                
                Menu {
                    Button {
                        self.currency = "EUR"
                        fetchBitcoinPrice()
                    } label: {
                        Text("EUR")
                        Text("€")
                    }
                    Button {
                        self.currency = "GBP"
                        fetchBitcoinPrice()
                    } label: {
                        Text("GBP")
                        Text("£")
                    }
                    Button {
                        self.currency = "USD"
                        fetchBitcoinPrice()
                    } label: {
                        Text("USD")
                        Text("$")
                    }
                } label: {
                     Text("Change Currency")
                     Image(systemName: "arrow.down.circle")
                }
                
                Button("Proceed") {
                    calculateYourBitcoinBalance()
                    openWindow(id: "ImmersiveSpace")
                }

            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            
        }
        

    }
}

#Preview(windowStyle: .automatic) {
    let bitcoinBalance = Binding.constant("0.0")
    let bitcoinValue = Binding.constant("0.0")
    let enteredBitcoinAmount = Binding.constant("")
    let currency = Binding.constant("USD")

    return ContentView(bitcoinBalance: bitcoinBalance,
                       bitcoinValue: bitcoinValue,
                       enteredBitcoinAmount: enteredBitcoinAmount,
                       currency: currency,
                       fetchBitcoinPrice: {},
                       calculateYourBitcoinBalance: {})
}
