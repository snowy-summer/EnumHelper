import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct IdentifiableEnum: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
            //enum 확인
            guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
                throw EnumError.onlyApplicableToEnum
            }
            
            //enum 요소 추출
            let members = enumDecl.memberBlock.members
            let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            let elements = caseDecls.flatMap { $0.elements }
            
            let idVar = try VariableDeclSyntax("var id: String") {
                try SwitchExprSyntax("switch self") {
                    for element in elements {
                        SwitchCaseSyntax(
                            """
                            case .\(element.identifier):
                                return "\(element.identifier)"
                            """
                        )
                    }
                }
            }
            
            return [DeclSyntax(idVar)]
    }
}

extension IdentifiableEnum: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        //enum 확인
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw EnumError.onlyApplicableToEnum
        }
        
        let extensionDecl = try ExtensionDeclSyntax("extension \(type.trimmed): Identifiable") {
        }
        
        return [extensionDecl]
    }
}

@main
struct EnumHelperPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        IdentifiableEnum.self,
    ]
}

//MARK: - Error

enum EnumError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "can only be applied to an enum"
        }
    }
}
