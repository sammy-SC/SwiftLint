import SwiftLintFramework
import XCTest

private func funcWithParameters(_ parameters: String, violates: Bool = false) -> String {
    let marker = violates ? "↓" : ""

    return "func \(marker)abc(\(parameters)) {}\n"
}

private func violatingFuncWithParameters(_ parameters: String) -> String {
    return funcWithParameters(parameters, violates: true)
}

class FunctionParameterCountRuleTests: XCTestCase {

    func testWithDefaultConfiguration() {
        verifyRule(FunctionParameterCountRule.description)
    }

    func testFunctionParameterCount() {
        let baseDescription = FunctionParameterCountRule.description
        let nonTriggeringExamples = [
            funcWithParameters(repeatElement("x: Int, ", count: 3).joined() + "x: Int")
        ]

        let triggeringExamples = [
            funcWithParameters(repeatElement("x: Int, ", count: 5).joined() + "x: Int")
        ]

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
            .with(triggeringExamples: triggeringExamples)

        verifyRule(description)
    }

    func testDefaultFunctionParameterCount() {
        let baseDescription = FunctionParameterCountRule.description
        let nonTriggeringExamples = [
            funcWithParameters(repeatElement("x: Int, ", count: 3).joined() + "x: Int")
        ]

        let defaultParams = repeatElement("x: Int = 0, ", count: 2).joined() + "x: Int = 0"
        let triggeringExamples = [
            funcWithParameters(repeatElement("x: Int, ", count: 3).joined() + defaultParams)
        ]

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
            .with(triggeringExamples: triggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_default_parameters": false])
    }

    private func violations(_ string: String) -> [StyleViolation] {
        let config = makeConfig(nil, FunctionParameterCountRule.description.identifier)!

        return SwiftLintFrameworkTests.violations(string, config: config)
    }
}
