# lynx

Set up a Kotlin Multiplatform app by running one command 🚀

## What is lynx? 🤷‍♀️

lynx is a command line tool that helps you generate a Kotlin Multiplatform mobile projects.

It's open source and written in Swift.

## Install lynx ⬇️

The first thing that we need to do to get started is installing the tool. To do so, you can run the following commands in your terminal:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/DoubleSymmetry/lynx/master/install.sh)
```

## Bootstrap your first project 🚀

```bash
lynx init ProjectName com.yourcomany 
```
This will create a new app project with the given name using the given bundle identifier/package name.

## CLI Options
```
Arguments:

    name - The name to give the project
    bundleId - The company bundle prefix to use (i.e. com.doublesymmetry)

Options:
    --use-swiftui [default: false] - Whether the generated iOS project should use SwiftUI
    --use-compose [default: false] - Whether the generated Android project should use Jetpack Compose
    --template [optional] - A third party template to use instead - options are: kampkit
```

## Updating lynx ✨

Same as the install instructions, the binary will be overriden.
