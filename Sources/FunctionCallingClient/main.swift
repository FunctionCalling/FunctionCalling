import FunctionCalling

@FunctionCalling(service: .claude)
struct Foo {

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
