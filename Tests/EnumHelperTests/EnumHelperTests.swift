import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
//#if canImport(EnumHelperMacros)
import EnumHelperMacros

let testMacros: [String: Macro.Type] = [
    "IdentifiableEnum": IdentifiableEnum.self,
]
//#endif

final class EnumHelperTests: XCTestCase {
    func test_IdentifiableEnumMacro_withEnum() throws {
        assertMacroExpansion(
            """
            @IdentifiableEnum
            enum DiarySheetType {
                case add
                case edit
            }
            """,
        expandedSource:
            """
            enum DiarySheetType {
                case add
                case edit
            }
            
            extension DiarySheetType: Identifiable {
                var id: String {
                    switch self {
                    case .add:
                        return "add"
                    case .edit:
                        return "edit"
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_IdentifiableEnumMacro_withStruct() throws {
        assertMacroExpansion(
            """
            @IdentifiableEnum
            struct DiarySheetType{
            }
            """,
            expandedSource:
            """
            struct DiarySheetType{
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "can only be applied to an enum", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
