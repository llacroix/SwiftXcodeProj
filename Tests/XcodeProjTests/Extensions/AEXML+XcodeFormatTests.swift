
import AEXML
import XCTest
@testable import SwiftXcodeProj

extension String {
    var cleaned: String {
        replacingOccurrences(of: "   ", with: "").components(separatedBy: "\n").filter { !$0.isEmpty }.joined(separator: " ")
    }
}

class AEXML_XcodeFormatTests: XCTestCase {
    private let expectedXml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <BuildAction
           parallelizeBuildables = "YES"
           buildImplicitDependencies = "NO"
           runPostActionsOnFailure = "YES">
        </BuildAction>
        """

    func test_BuildAction_attributes_sorted_when_original_sorted() {
        validateAttributes(attributes: [
            "parallelizeBuildables": "YES",
            "runPostActionsOnFailure": "YES",
            "buildImplicitDependencies": "NO",
        ])
    }

    func test_BuildAction_attributes_sorted_when_original_unsorted() {
        validateAttributes(attributes: [
            "buildImplicitDependencies": "NO",
            "parallelizeBuildables": "YES",
            "runPostActionsOnFailure": "YES",
        ])
    }

    func validateAttributes(attributes: [String: String], line: UInt = #line) {
        let document = AEXMLDocument()
        let child = document.addChild(name: "BuildAction")
        child.attributes = attributes
        let result = document.xmlXcodeFormat
        XCTAssertEqual(expectedXml.cleaned, result.cleaned, line: line)
    }
}
