//: Playground - noun: a place where people can play

import UIKit

let number = 100

let numberFormatter = NSNumberFormatter()
numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
numberFormatter.locale = NSLocale(localeIdentifier: "ar")
if let wordNumber = numberFormatter.stringFromNumber((number))
{
    print(wordNumber)
}

//NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
//wordNumber = [numberFormatter stringFromNumber:numberValue];
