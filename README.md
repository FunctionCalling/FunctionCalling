
## Eample

```swift
@FunctionTools
struct MyFunctionTools: ToolContainer {
    @CallableFunction
    func request(_ urlString: String) async throws -> String {
        // TODO: do something
    }
    
    @CallableFunction
    func addition(lhs: Int, rhs: Int) -> Int {
        // TODO:
    }
    
    // generated code
    static func execute(methodName: String, arguments: Any) async throws -> String {
        switch methodName {
            case "request": // method name
                // argument name and argument type
                guard let urlString = arguments as? String else {
                    fatalError("Cannot cast arguments for \(methodName).")
                }
                
                return try await request(urlString)
            case "addition":
                guard let (lhs, rhs) = arguments as? (Int, Int) else {
                    fatalError("Cannot cast arguments for \(methodName).")
                }
                
                return try await addition(lhs: lhs, rhs: rhs)
            default:
                fatalError("Cannot find method for `methodName`: \(methodName)")
        }
    }
    
    static var allTools: String {
        // type based json string 
        return """
        {
            "name": "request",
            "description": "Get the current weather in a given location",
            "input_schema": {
              "type": "object",
              "properties": {
                "location": {
                  "type": "string",
                  "description": "The city and state, e.g. San Francisco, CA"
                }
              },
              "required": ["location"]
            }
        }
        """
    }
}
```
