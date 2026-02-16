<!-- A test comment -->
___
name: Test: Count words and lines in $select
___
Tell me the total number of words and lines in the following text:
$select

<!-- A test comment -->
___
name: Test: Count words and lines in $yanked
<!-- A test comment -->
___
Tell me the total number of words and lines in the following text:
$yanked

___
name: Test: Two inputs
___
The meaning of "${input:Enter word 1}" and the meaning of "${input:Enter word 2}".

___
name: Test: Antonym (custom prompt)
___
Antonyms for "${input:Enter word}"

___
name: Test: Improve $clipboard
___
Improve expression, grammar and spelling in the following text:

$clipboard

___
name: Test: Submit $text
___
$text

___
name: Test: Submit clipboard
___
$register_+

___
name: Test: Yanked Register "
___
Explain the meaning of the following text:

$register

___
name: Test: Yanked Register 0
___
Explain the meaning of the following text:

$register_0

___
name: Test: Change code
<!-- example comment -->
paste: replace
extract: ```$filetype\n(.-)```
___
<!-- Regarding the following code, ${input:Describe the desired changes}, only output the result as a Markdown fenced code block: -->
Regarding the following code, ${input:Describe the desired changes}, only output the code, do not output explanations, do not put the code inside a Markdown block:

```$filetype
$select
```

