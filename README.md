# Kronic for Node.js

[ ![Codeship Status for radekstepan/kronic-node](https://www.codeship.io/projects/f8465380-6f12-0130-c859-22000a1d8b6d/status?branch=master)](https://www.codeship.io/projects/1946)

A dirt simple library for parsing and formatting human readable dates (Today, Yesterday, Last Monday). A port of [https://github.com/xaviershay/kronic](https://github.com/xaviershay/kronic) to make it into a Node.js module.

## Usage

```bash
$ npm install kronic-node
```

```coffeescript
Kronic = require 'kronic-node'

# Parse string into Date.
Kronic.parse 'Today'
# Human format from Date.
Kronic.format new Date()
```

## Tests

```bash
$ npm test
```

The tests have been rewritten to use [Mocha](http://visionmedia.github.com/mocha/) and [Should](https://github.com/visionmedia/should.js/tree/).