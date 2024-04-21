import SwiftUI

@main
struct cryptoApp: App {
    
    @State private var bitcoinBalance = "0.0"
    @State private var bitcoinValue = "0.0"
    @State private var enteredBitcoinAmount = ""
    @State private var currency = "USD"

    
    func fetchBitcoinPrice(){
        print("Fetching Bitcoin Price")
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let bpi = json["bpi"] as! [String: Any]
                let curr = bpi[currency] as! [String: Any]
                let rate = curr["rate"] as! String
                bitcoinValue = rate
                calculateYourBitcoinBalance()
            }
        }
        task.resume()

    }
    
    func calculateYourBitcoinBalance(){
        if let bitcoinRate = Double(bitcoinValue.replacingOccurrences(of: ",", with: "")) {
            var bitcoinBalanceDouble: Double
            if let bitcoinAmount = Double(enteredBitcoinAmount) {
                bitcoinBalanceDouble = bitcoinAmount * bitcoinRate
            }  else {
                bitcoinBalanceDouble = 0.0
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = ","
            numberFormatter.decimalSeparator = "."
            bitcoinBalance = numberFormatter.string(from: NSNumber(value: bitcoinBalanceDouble))!
        }
    }
        
    var body: some Scene {
        WindowGroup("StartingWindow",id: "StartingWindow") {
            ContentView(
                bitcoinBalance: $bitcoinBalance,
                bitcoinValue: $bitcoinValue,
                enteredBitcoinAmount: $enteredBitcoinAmount,
                currency: $currency,
                fetchBitcoinPrice: fetchBitcoinPrice,
                calculateYourBitcoinBalance: calculateYourBitcoinBalance
            ).frame(minWidth: 1000, minHeight: 800)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "ImmersiveSpace") {
            ImmersiveView(
                bitcoinBalance: $bitcoinBalance,
                bitcoinValue: $bitcoinValue,
                currency: $currency,
                fetchBitcoinPrice: fetchBitcoinPrice
            )
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 0.8, depth: 0.3, in: .meters)
    }
}
