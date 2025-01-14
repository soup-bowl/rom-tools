# ROM Tools

A packaged collection of various ROM manipulation tools.

Currently includes **[tochd][td]** (chdman), **[maxcso][cso]** and **[PSXPackager][psx]**. Built for **AMD64** and **ARM64** (untested)·

## Usage

```bash
docker run -it --rm -v "$(pwd):/app" ghcr.io/soup-bowl/rom-tools:latest
```

If all goes correctly, you'll get a "no tools executed" message. Run the ones you need by adding the commands to the end.

## Testing

This uses [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) to unit test the Dockerfile. You can do this by running:

```bash
docker build -t test-romtools .
container-structure-test test --config unit-test.yaml --image test-romtools
```

[td]:  https://github.com/thingsiplay/tochd
[cso]: https://github.com/unknownbrackets/maxcso
[psx]: https://github.com/RupertAvery/PSXPackager
