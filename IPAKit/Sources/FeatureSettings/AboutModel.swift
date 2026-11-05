import Combine
import Foundation
import IPADomain

@MainActor
final class AboutModel: ObservableObject {
    let ipatoolURL = URL(string: "https://github.com/majd/ipatool")
    let dlipaURL = URL(string: "https://github.com/AhmedBafkir/DLiPA")
    let lottieURL = URL(string: "https://github.com/airbnb/lottie-ios")

    var shareMessage: String { String(appLocalized: "I'm using IPA. Take a look.") }
}
