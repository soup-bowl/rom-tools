# ROM Tools

**NOT USABLE YET**

A packaged collection of various ROM manipulation tools.

Currently includes **[tochd][td]**, **[maxcso][cso]**.

## Usage

```
docker run -it --rm -v "$(pwd):/app" ghcr.io/soup-bowl/rom-tools:latest
```

If all goes correctly, you'll get a "no tools executed" message. Run the ones you need by adding the commands to the end.

[td]:  https://github.com/thingsiplay/tochd
[cso]: https://github.com/unknownbrackets/maxcso
