# Nameing Convention Converter

PowerShell modules to convert strings.

> [!NOTE]
> This module is not signed. It is therefore important that the
> **ExecutionPolicy** is correctly set to **unrestricted**.
> Further details can be found [here](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4).

# How to use

## Using the PowerShell Gallery

```PowerShell
# Download and install as powershell module
$> Install-Module -Name GlobeCruising.Common.NameingConventionConverter
$> Get-Module -Name GlobeCruising.Common.StringConverter

# OUTPUT:
ModuleType  Version  PreRelease  Name                                         ExportedCommands
----------  -------  ----------  ----                                         ----------------
Manifest    1.0.1                GlobeCruising.Common.NameingStringConverter  {Add-Content, Clear-Cont...
```

## Use as offline module

PowerShell uses several folders in which modules are searched for. The command **`$env:PSModulePath`** lists all module folders in which modules are searched for. These paths are commonly used on a Windows system. `C:\Program Files\PowerShell\Modules`, `C:\program files\powershell\7\Modules`, `C:\Program Files\WindowsPowerShell\Modules`, `C:\Windows\system32\WindowsPowerShell\v1.0\Modules`, `C:\Users\<user>\OneDrive\Documents\PowerShell\Modules`
Download current releases [here](https://github.com/mGloerfeld/nameing-convention-converter/releases) and exctract to your preferd folder e.g. 'C:\program files\powershell\7\Modules'.

```PowerShell
# Check if module is loaded
$> Get-Module -Name GlobeCruising.Common.StringConverter

# OUTPUT:
ModuleType  Version  PreRelease  Name                                         ExportedCommands
----------  -------  ----------  ----                                         ----------------
Manifest    1.0.1                GlobeCruising.Common.NameingStringConverter  {Add-Content,Clear-Cont...
```

## Use inside scripts

Make sure module is downloaded and extracted to your preferd folder. Otherwise download current releases [here](https://github.com/mGloerfeld/nameing-convention-converter/releases) and exctract to your preferd folder e.g. 'D:\any-folder\my-scripts'.

```PowerShell
# yourScript.ps1
Import-Module -Name "D:\any-folder\my-scripts\NameingConventionConverter" -Verbose

function doSomething {

    $val = ConvetTo-CamelCase "Hello world from PowerShell";

    # $val values is helloWorldFromPowerShell
    return $val;
}

```

# Supported conventions

Below is an overview of the naming conventions used in programming languages. Out of them Pascal Case, Camel Case, Snake Case, and Kebab Case are the most popular and widely used across programming languages.

|              Nameing Convention               |    Example Format    |
| :-------------------------------------------: | :------------------: |
|           [Camel Case](#camel-case)           |      camelCase       |
|           [Cobol Case](#Cobol-case)           |      COBOL-CASE      |
|           [Train Case](#train-case)           |      Train-Case      |
|          [Pascal Case](#pascal-case)          |      PascalCase      |
|           [Kebab Case](#kebab-case)           |      kebab-case      |
|           [Snake Case](#snake-case)           |      snake_cse       |
|     [Camel Snake Case](#camel-snake-case)     |   camel_Snake_Case   |
|    [Pascal Snake Case](#pascal-snake-case)    |  Pascal_Snake_Case   |
| [Screaming Snake Case](#screaming-snake-case) | SCREAMING_SNAKE_CASE |
|            [Flat Case](#flat-case)            |       flatcase       |
|      [Upper Flat Case](#upper-flat-case)      |    UPPERFLATCASE     |

## Camel Case

Camel case is the practice of writing phrases without spaces or punctuation and with capitalized words. The format indicates the first word starting with either case, then the following words having an initial uppercase letter.

```PowerShell
$> ConvertTo-CamelCase "Heros of PowerShell"

# OUTPUT:
herosOfPowerShell
```

## Cobol Case

The Cobol case is again a combination of upper flat case and kebab case rules. The variable is named by capitalizing all the words separated by a hyphen. As the name implies, this convention is majorly used in the COBOL programming language.

```PowerShell
$> ConvertTo-CobolCase "Heros of PowerShell"

# OUTPUT:
HEROS-OF-POWERSHELL
```

## Flat Case

In the flat case, we name the variable by combining all the words and letters without leaving any space in between. All the characters in the flat case are in lowercase. This convention is very less often used as it affects readability especially when multiple words are combined.

```PowerShell
$> ConvertTo-FlatCase "Heros of PowerShell"

# OUTPUT:
herosofpowershell
```

## Kebab Case

Kebab case is also known as Dash Case, Lisp Case, and Spinal Case. It is similar to the snake case but instead of an underscore we use a hyphen over here “-”. We mostly use this naming convention to name our custom HTML elements.

```PowerShell
$> ConvertTo-KebabCase "Heros of PowerShell"

# OUTPUT:
heros-of-powershell
```

## Pascal Case

Also known as Upper Camel Case or Studly Case, this notation is formed with every first letter of a word with a capital letter. In the case of names with multiple words, all words will start with capital letters. This naming convention is mostly used to name Classes in the programming languages like C#, JavaScript, Java, and Python.

```PowerShell
$> ConvertTo-PascalCase "Heros of PowerShell"

# OUTPUT:
HerosOfPowerShell
```

## Screaming Snake Case

The screaming snake case variable is created by using all capital letters of the words separated by an underscore. It is also known as a Macro or Constant Case. Most programming languages use this format to declare constant variables.

```PowerShell
$> ConvertTo-ScreamingSnakeCase "Heros of PowerShell"

# OUTPUT:
HEROS_OF_POWERSHELL
```

## Snake Case

Snake case is the naming convention in which each space is replaced with an underscore (\_) character, and words are written in lowercase. It is a commonly used naming convention in computing, for example for variable and subroutine names, and for filenames.

```PowerShell
$> ConvertTo-SnakeCase "Heros of PowerShell"

# OUTPUT:
heros_of_powershell
```

## Train Case

The train case is also known as the HTTP header case. It is formed by capitalizing the words’ first letter and separating them with a hyphen. You will mostly see this convention is used in HTTP header requests and responses.

```PowerShell
$> ConvertTo-TrainCase "Heros of PowerShell"

# OUTPUT:
Heros-Of-Powershell
```

## Pascal Snake Case

The Pascal Snake Case is formed by combining the rules of pascal and snake cases. It is formed by capitalizing the first letter of each word and separating these words with the underscore “\_”. This convention is observed in legacy Java packages.

```PowerShell
$> ConvertTo-PascalSnakeCase "Heros of PowerShell"

# OUTPUT:
Heros_Of_PowerShell
```

## Camel Snake Case

Similar to Pascal Snake Case, this convention is formed by combining the Camel and Snake Case rules. Over here, the variable name starts in lowercase and is separated by an underscore “\_”.

```PowerShell
$> ConvertTo-CamelSnakeCase "Heros of PowerShell"

# OUTPUT:
heros_Of_PowerShell
```

## Upper Flat Case

This notation is formed by combining all the words and letters without any space in between with all the letters in upper case. Similar to the flat case this convention is hardly used as it affects readability when multiple words are involved.

```PowerShell
$> ConvertTo-UpperFlatCase "Heros of PowerShell"

# OUTPUT:
HEROSOFPOWERSHELL
```
