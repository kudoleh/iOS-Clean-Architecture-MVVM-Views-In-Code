
# Template iOS App using Clean Architecture and MVVM with Views in Code

iOS Project implemented with Clean Layered Architecture and MVVM. (Can be used as Template project by replacing item name “Repository”). **More information in medium post**: <a href="https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3">Medium Post about Clean Architecture + MVVM</a>


![Alt text](README_FILES/CleanArchitecture+MVVM.png?raw=true "Clean Architecture Layers")

## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
* **Presentation Layer (MVVM)** = ViewModels + Views

### Dependency Direction
![Alt text](README_FILES/CleanArchitectureDependencies.png?raw=true "Modules Dependencies")

**Note:** **Domain Layer** should not include anything from other layers(e.g Presentation — UIKit or SwiftUI or Data Layer — Mapping Codable)

## Architecture concepts used here
* Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
* Advanced iOS App Architecture https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture
* [MVVM](ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList) 
* Observable
* Dependency Injection
* Flow Coordinator
* Data Transfer Object (DTO)
* Response Data Caching
* ViewController Lifecycle Behavior
* SwiftUI and UIKit Views in code
* Use of UITableViewDiffableDataSource
* Shimmering Loading
* Error handling
* CI Pipeline ([Travis CI + Fastlane](.travis.yml))
 
## Includes
* Unit Tests with Quick and Nimble, and View Unit tests with iOSSnapshotTestCase
* Unit Tests for Use Cases(Domain Layer), ViewModels(Presentation Layer), NetworkService(Infrastructure Layer)
* UI test with XCUITests
* Size Classes and UIStackView in Detail view
* Dark Mode
* SwiftUI example, demostration that presentation layer does not change, only UI (at least Xcode 11 required)
* Pagination

## Networking
If you would like to use Networking from this example project as repo I made it availabe [here](https://github.com/kudoleh/SENetworking)

## Requirements
* Xcode Version 11.2.1+  Min iOS version 13  Swift 5.0+  

# How to use app
Tap on repository cell to expand cell and see its details.


https://user-images.githubusercontent.com/6785311/236620282-5cebc95e-cc02-421c-a981-23b6a02d3f1d.mp4










