// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(extension)
//@attached(member)
public macro IdentifiableEnum() = #externalMacro(module: "EnumHelperMacros",
                                               type: "IdentifiableEnum")
