# Kronic for Node.js

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