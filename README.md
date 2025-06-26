#  CanSubscribe

[![](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-blue)](https://github.com/southkin/CanSubscribe)
[![](https://img.shields.io/badge/spm-supported-orange)](https://swift.org/package-manager/)
[![](https://img.shields.io/badge/license-MIT-lightgrey)](LICENSE)

## Usage
```swift
@CanSubscribe var myValue:<Type>
```
and
```swift
let cancellable = $myValue.sink {
    print($0)
}
myValue = <#value#>
print(myValue)
```
## Sample
```swift
var cancellables: Set<AnyCancellable> = []
struct MyStruct {
    let str:String
    let int:Int
}
@CanSubscribe var myString:String? = "a"
@CanSubscribe var myInt:Int = 1
@CanSubscribe var myStruct:MyStruct? = .init(str:"q", int:9)

print("str : \(myString!)")
print("int : \(myInt)")
print("struct : \(myStruct!)")

myString = "z"
myInt = 999
myStruct = .init(str:"x", int:888)

print("str : \(myString!)")
print("int : \(myInt)")
print("struct : \(myStruct!)")

$myString.sink {print("str-sink : \($0!)")}.store(in: &cancellables)
$myInt.sink {print("int-sink : \($0)")}.store(in: &cancellables)
$myStruct.sink {print("struct-sink : \($0!)")}.store(in: &cancellables)

myString = "b"
myInt = 2
myStruct = .init(str:"w", int:8)
myString = "c"
myInt = 3
myStruct = .init(str:"e", int:7)

print("str : \(myString!)")
print("int : \(myInt)")
print("struct : \(myStruct!)")
```

### log
```bash
str : a
int : 1
struct : MyStruct(str: "q", int: 9)
str : z
int : 999
struct : MyStruct(str: "x", int: 888)
str-sink : z
int-sink : 999
struct-sink : MyStruct(str: "x", int: 888)
str-sink : b
int-sink : 2
struct-sink : MyStruct(str: "w", int: 8)
str-sink : c
int-sink : 3
struct-sink : MyStruct(str: "e", int: 7)
str : c
int : 3
struct : MyStruct(str: "e", int: 7)
```
