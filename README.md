# NYTBestseller

NYT Bestseller app that connects to the NYT API and uses Google API to fetch covers

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Support](#support)
- [Contributing](#contributing)

## Installation

Cloning the repo will be enough to get the app running. Cocoapods have been tracked to avoid a `pod install`.

```sh
cd project-name
git clone https://github.com/apeguero24/NYTBestseller.git
```

## Usage

In order to use the app, you must have Xcode 9 and Swift 4. Upon opening `NYTBestseller.xcworkspace`:

- Run on a simulator device (I used iphone 8)
- Categories will load and instantly be cached
- If opened offline for the first time, then a message will be display on the table view 
- Tapping on a category will bring you to the list of bestsellers
- Best sellers can be ranked by ranking and weeks on list (your settings will be stored) 
- Tapping on a book will display more detail about the book


## Support

Please [open an issue](https://github.com/fraction/NYTBestseller/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/fraction/NYTBestseller/compare/).
