import FunctionCalling

@FunctionCalling(service: .claude)
struct ClaudeTools {

    @CallableFunction
    /// This returns "bar" text
    ///
    /// - Returns: "bar" string
    func bar() -> String {
        ""
    }

    @CallableFunction
    static func foo(hoge: Int) -> Int {
        hoge
    }
}

@FunctionCalling(service: .chatGPT)
struct ChatGPTTools {
    @CallableFunction
    func getWeather(from location: String) -> String {
        ""
    }

    @CallableFunction
    static func getTemperature(_ location: String) -> Int {
        0
    }
}
