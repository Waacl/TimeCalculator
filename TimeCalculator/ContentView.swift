import SwiftUI

enum CalcButton: String {
    case none       = ""
    case zero       = "0"
    case one        = "1"
    case two        = "2"
    case three      = "3"
    case four       = "4"
    case five       = "5"
    case six        = "6"
    case seven      = "7"
    case eight      = "8"
    case nine       = "9"
    case clear      = "AC"
    case colon      = ":"
    case subtract   = "–"
    case add        = "+"
    case divide     = "÷"
    case multiply   = "×"
    case equal      = "="
    case hour       = "H"
    case mode       = "24H"
    
    var buttonColor: Color {
        switch self {
            case .add, .subtract, .multiply, .divide, .equal:
                return .orange
            case .clear, .hour, .mode:
                return Color(.lightGray)
            default:
                return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
    
    var active: Bool {
        return false
    }
    
    var modeActive: Bool {
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
    @State var modeActive: Bool = true
    
    let buttons: [[CalcButton]] = [
        [.clear, .hour, .mode, .divide],
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
                    Text(getFormattedDisplayValue())
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                }
                .padding()

                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.calc(button: button)
                            }, label: {
                                Text(button.rawValue)
                                    .font(.system(size: 32))
                                    .bold()
                                    .frame(
                                        width: getButtonWidth(button: button),
                                        height: getButtonHeight()
                                    )
                                    .background(getBackgroundColor(button: button))
                                    .foregroundColor(getForegroundColor(button: button))
                                    .cornerRadius(getCornerRadius(button: button))
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func getForegroundColor(button: CalcButton) -> Color {
        if ((button == .mode && modeActive) || button == activeButton) {
            return .orange
        }
        
        return .white
    }
    
    func getBackgroundColor(button: CalcButton) -> Color {
        if ((button == .mode && modeActive) || button == activeButton) {
            return .white
        }
        
        return button.buttonColor
    }
    
    func getFormattedString(_ hours: inout Int, _ minutes: inout Int) -> String {
        var format = "%02d:%02d"
        
        if (modeActive) {
            hours = hours % 24
            
            if (minutes < 0) {
                minutes = 60 - (minutes * -1)
                hours = hours-1
            }
            
            if (hours < 0) {
                hours = 24 - (hours * -1)
            }
        } else {
            if (hours < 0 || minutes < 0) {
                format = "-" + format
                hours = hours * -1
                minutes = minutes * -1
            }
        }
        
        return String(format: format, hours, minutes)
    }
    
    func getFormattedDisplayValue() -> String {
        let calcValue = Int(displayValue)!
        var hours = calcValue / 60
        var minutes = calcValue % 60
        return getFormattedString(&hours, &minutes)
    }
    
    func calc(button: CalcButton) {
        switch button {
            case .colon:
                activeButton = .colon
                let number = Int(self.value)!
                self.value = String(number * 60)
                self.displayValue = self.value
            case .hour:
                let number = Int(self.value)!
                self.value = String(number * 60)
                self.displayValue = self.value
            case .add, .subtract, .multiply, .divide, .equal:
                if (button == .add) {
                    self.currentOperation = .add
                    self.runningNumber = Int(self.value) ?? 0
                } else if (button == .subtract) {
                    self.currentOperation = .subtract
                    self.runningNumber = Int(self.value) ?? 0
                } else if (button == .multiply) {
                    self.currentOperation = .multiply
                    self.runningNumber = Int(self.value) ?? 0
                } else if (button == .divide) {
                    self.currentOperation = .divide
                    self.runningNumber = Int(self.value) ?? 0
                } else if (button == .equal) {
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
                
                if (button != .equal) {
                    activeButton = button
                    self.value = "0"
                }
            case .clear:
                activeButton = .none
                self.value = "0"
                self.displayValue = self.value
            case .mode:
                modeActive = !modeActive
            default:
                let number = button.rawValue
                
                if (activeButton == .colon) {
                    var inputNum = Int(number)!
                    var currentNum = Int(self.value)!
                    var hours = currentNum / 60
                    var minutes = currentNum % 60
                    
                    minutes = Int("\(minutes)\(number)")!
                    
                    self.value = String(hours * 60 + minutes)
                } else {
                    if (self.value == "0") {
                        value = number
                    } else {
                        self.value = "\(self.value)\(number)"
                    }
                }
                
                self.displayValue = self.value
        }
    }
    
    func getButtonWidth(button: CalcButton) -> CGFloat {
        if (button == .zero) {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }

    func getButtonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func getCornerRadius(button: CalcButton) -> CGFloat {
        return getButtonWidth(button: button) / 2
    }
}

#Preview {
    ContentView()
}
