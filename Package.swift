// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "FunctionCalling",
    platforms: [.macOS(.v13), .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FunctionCalling",
            targets: ["FunctionCalling"]
        ),
        .executable(
            name: "FunctionCallingClient",
            targets: ["FunctionCallingClient"]
        )
    ],
    dependencies: [
        // Depend on the Swift 5.9 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.1.1"),
        .package(url: "https://github.com/groue/GRMustache.swift", from: "4.2.0"),
        .package(url: "https://github.com/fumito-ito/DocumentationComment.git", exact: "0.0.6")
    ],
    targets: [
        .macro(
            name: "FunctionCallingMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                "SyntaxParser",
                "SyntaxRenderer",
                "CommonModules"
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "FunctionCalling", dependencies: [
            "FunctionCallingMacros",
            "CommonModules"
        ]),

        .target(name: "SyntaxRenderer", dependencies: [
            "CommonModules",
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "Mustache", package: "GRMustache.swift")
        ]),

        .target(name: "SyntaxParser", dependencies: [
            "CommonModules",
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "DocumetationComment", package: "DocumentationComment")
        ]),

        .target(name: "CommonModules"),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "FunctionCallingClient", dependencies: ["FunctionCalling"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "FunctionCallingTests",
            dependencies: [
                "FunctionCallingMacros",
                "SyntaxParser",
                "SyntaxRenderer",
                "CommonModules",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),

        .testTarget(
            name: "SyntaxParserTests",
            dependencies: [
                "SyntaxParser",
                "CommonModules",
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),

        .testTarget(
            name: "SyntaxRendererTests",
            dependencies: [
                "SyntaxRenderer",
                "CommonModules",
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        )
    ]
)
