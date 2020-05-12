This shell script downloads books you have access to from Cambridge Core.

Login to Cambridge Core. Use e.g. [cookies.txt Chrome extension](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg) to create a cookies.txt file that this script will use

You will need to have [pup](https://github.com/ericchiang/pup) installed.

The script takes the URL to the book's contents page, e.g. ./get.sh https://www.cambridge.org/core/books/an-introduction-to-indian-philosophy/B9CD240194015F1D13BCDE7CA376CB86

It will download all parts of the book in the order in which they are displayed in the contents page. The output is a single HTML file. If you have Pandoc installed it will use the HTML to create an ePub.

Tested on MacOS.
