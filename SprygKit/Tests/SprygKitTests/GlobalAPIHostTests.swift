import Foundation
import Testing
import SprygKit

struct GlobalAPIHostTests {
    @Test func debugBuildsCanPointAtAnotherHost() {
        let url = SprygEnvironment.globalAPI(override: "https://staging-global.api.spryg.io", allowOverride: true)
        #expect(url.absoluteString == "https://staging-global.api.spryg.io")
    }

    @Test func releaseBuildsIgnoreTheOverride() {
        let url = SprygEnvironment.globalAPI(override: "https://staging-global.api.spryg.io", allowOverride: false)
        #expect(url.absoluteString == "https://global.api.spryg.io")
    }

    @Test(arguments: [nil, "", "not a url", "http://insecure.example.com", "ftp://global.api.spryg.io"])
    func aMissingOrUnusableOverrideFallsBackToProduction(override: String?) {
        let url = SprygEnvironment.globalAPI(override: override, allowOverride: true)
        #expect(url.absoluteString == "https://global.api.spryg.io")
    }
}
