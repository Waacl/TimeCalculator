import SwiftUI

enum CalcButton: String {
    case none = ""
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case clear = "AC"
    case colon = ":"
    case subtract = "–"
    case add = "+"
    case divide = "÷"
    case multiply = "×"
    case equal = "="
    case hour = "H"
    case minute = "M"
    
    var buttonColor: Color {
    switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .minute, .hour:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
    
    var active: Bool {
        return false
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State var value = "0"
    @State var displayValue = "0"
    @State var runningNumber = 0
    @State var currentOperation: Operation = .none
    @State var activeButton: CalcButton = .none
    
    let buttons: [[CalcButton]] = [
        [.clear, .hour, .minute, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .colon, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Text(displayValue)
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                }
                .padding()

                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.calc(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .bold()
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item == activeButton ? .white : item.buttonColor)
                                    .foregroundColor(item == activeButton ? .orange : .white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func calc(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .equal {
                activeButton = .none
                
                let runningValue = self.runningNumber
                let currentValue = Int(self.value) ?? 0
                
                switch self.currentOperation {
                    case .add: 
                        self.value = "\(runningValue + currentValue)"
                    case .subtract:
                        self.value = "\(runningValue - currentValue)"
                    case .multiply: 
                        self.value = "\(runningValue * currentValue)"
                    case .divide: 
                        self.value = "\(runningValue / currentValue)"
                    case .none:
                        break
                }
            }

            self.displayValue = self.value
            
            if button != .equal {
                activeButton = button
                self.value = "0"
            }
        case .clear:
            activeButton = .none
            self.value = "0"
            self.displayValue = self.value
        case .colon:
            break
        default:
            let number = button.rawValue
            
            if self.value == "0" {
                value = number
            } else {
                self.value = "\(self.value)\(number)"
            }
            
            self.displayValue = self.value
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
            return (UIScreen.main.bounds.width - (5*12)) / 4
        }

        func buttonHeight() -> CGFloat {
            return (UIScreen.main.bounds.width - (5*12)) / 4
        }
}

#Preview {
    ContentView()
}
