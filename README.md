# FunctionCalling macro

A Swift macro that allows you to call your function from Function Calling.

## Usage

This macro consists of a combination of `@FunctionCalling` and `@CallableFunction`. Decorate any function within a struct or class marked with `@FunctionCalling` using `@CallableFunction`.

```swift
@FunctionCalling(service: .claude)
struct MyFunctionTools: ToolContainer {
    @CallableFunction
    /// Get the current stock price for a given ticker symbol
    ///
    /// - Parameter: The stock ticker symbol, e.g. AAPL for Apple Inc.
    func getStockPrice(ticker: String) async throws -> String {
        // code to return stock price of passed ticker
    }
}
```

That’s it! The macro will generate code like the following:

```swift
extension MyFunctionTools: ToolContainer {
    func execute(methodName: String, parameters: [String: Any]) async -> String {
        do {
            switch methodName {
            case "getStockPrice":
                let ticker = parameters["ticker"] as! String
                return try await getStockPrice(
                    ticker: ticker
                ).description
            default:
                throw FunctionCallingError.unknownFunctionCalled
            }
        } catch let error {
            return error.localizedDescription
        }
    }

    var allTools: String {
    """
    [{"name": "getStockPrice","description": "Get the current stock price for a given ticker symbol.","input_schema": {"type": "object","properties": {"ticker": {"type": "string","description": "The stock ticker symbol, e.g. AAPL for Apple Inc."}},"required": ["ticker"]}}]
    """
    }
}
```

By using the `execute` function, you can easily call external functions from responses returned by APIs like [Anthropic Claude](https://www.anthropic.com/claude).
Additionally, by using the JSON string returned by `allTools`, you can easily use Function Calling with third-party libraries that call LLM services.

## Known Issue

Only the following types are supported for the arguments and return values of functions annotated with `@CallableFunction`:

- `String`
- `Character`
- `Int`
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `UInt`
- `UInt8`
- `UInt16`
- `UInt32`
- `UInt64`
- `Double`
- `Float`
- `Bool`
- `Array of above`

## Supporting Services

Currently, the generated `allTools` is available for the follwing services. 

-  [Anthropic Claude](https://www.anthropic.com/claude)
- [ChatGPT](http://chatgpt.com)
- [Llama](http://llama-api.com)

If there are other services you would like to see supported, please create an issue or submit a pull request.

## Installation

To use the `FunctionCalling` macro in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/fumito-ito/FunctionCalling", from: "0.0.1"),
```

Include "FunctionCalling" as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "FunctionCalling", package: "FunctionCalling"),
]),
```

Finally, add `import FunctionCalling` to your source code.

## Why ?

Function Calling is a mechanism for presenting callable external functions to services like Anthropic Claude. For example, in Anthropic Claude, you add the following JSON to an API call:

```json
"tools": [
  {
    "name": "get_stock_price",
    "description": "Get the current stock price for a given ticker symbol.",
    "input_schema": {
      "type": "object",
      "properties": {
        "ticker": {
          "type": "string",
          "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
        }
      },
      "required": ["ticker"]
    }
  }
]
```

This enables Anthropic Claude to call this function. For example, it might instruct a function call with the following response:

```json
[
  {
    "type": "tool_use",
    "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "name": "get_stock_price",
    "input": { "ticker": "^GSPC" }
  }
]
```

However, converting functions written in Swift into a JSON string usable for Function Calling is not easy and often requires tedious manual work.
This macro makes a vast number of functions written in Swift available for Function Calling with just two annotations.

## LICENSE

[The MIT License](https://opensource.org/license/mit)
