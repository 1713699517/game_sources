
enum KeyboardReturnType {
    kKeyboardReturnTypeDefault,
    kKeyboardReturnTypeDone,
    kKeyboardReturnTypeSend,
    kKeyboardReturnTypeSearch,
    kKeyboardReturnTypeGo
};


enum EditBoxInputMode
{
    
    kEditBoxInputModeAny,
    
    kEditBoxInputModeEmailAddr,

    kEditBoxInputModeNumeric,

    kEditBoxInputModePhoneNumber,

    kEditBoxInputModeUrl,

    kEditBoxInputModeDecimal,

    kEditBoxInputModeSingleLine
};

enum EditBoxInputFlag
{
    kEditBoxInputFlagPassword,

    kEditBoxInputFlagSensitive,

    kEditBoxInputFlagInitialCapsWord,

    kEditBoxInputFlagInitialCapsSentence,

    kEditBoxInputFlagInitialCapsAllCharacters

};