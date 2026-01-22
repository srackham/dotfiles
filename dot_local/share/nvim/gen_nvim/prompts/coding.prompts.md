___
name: Coding: Explain Code
___
Explain the following code:

```$filetype
$text
```

___
name: Coding: Review code
___
Review the following code and make concise suggestions:

```$filetype
$text
```

___
name: Coding: Improve code
___
Improve the following code, list the improvements and output the resulting code as a Markdown fenced code block:

```$filetype
$text

````
___
name: Coding: Change code
replace: true
extract: `$filetype\n(.-)`
___
Regarding the following code, ${input:Describe the desired changes}, only output the result as a Markdown fenced code block:

```$filetype
$text
````

___
name: Coding: Generate Lua function documentation
___
Generate LuaCATS documentation headers for Lua functions in the following code:

```$filetype
$text
```

