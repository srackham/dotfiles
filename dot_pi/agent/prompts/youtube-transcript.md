---
description: Extract a Youtube transcript and format it into numbered paragraphs.
argument-hint: "<video URL>"
---
Use the @/home/srackham/share/bin/yt-transcript.sh script to extract the transcript from this video: $1

 **Do not attempt to fix errors in the transcription e.g. spelling mistakes or grammatical errors.**

Follow these steps:

1. Use the yt-transcript.sh script to extract the transcript from the YouTube video
2. Remove timestamps and formatting
3. Analyze and reformat into paragraphs following English composition rules
4. Word-wrap at column 80
5. Separate paragraphs with blank lines
6. Copy the whole of the transcript to clipboard using either the `wl-copy` command or the `xclip` command

