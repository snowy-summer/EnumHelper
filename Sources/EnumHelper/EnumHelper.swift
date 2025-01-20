// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(extension, conformances: Identifiable)
@attached(member, names: named(id))
public macro IdentifiableEnum() = #externalMacro(module: "EnumHelperMacros",
                                               type: "IdentifiableEnum")
