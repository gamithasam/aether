public struct Text: View {
    let content: String
    
    public init(_ content: String) {
        self.content = content
    }
    
    public func render() -> String {
        "<span>\(content)</span>"
    }
}