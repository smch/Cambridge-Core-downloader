This shell script downloads the HTML version of books you have access to from [Cambridge Core](https://www.cambridge.org/core/).

##Motivation
The Core website lets you download PDFs of some books you have access to, but there is no method to donwnload the HTML. I want the HTML because I can reflow the text and change the font size, and use it with text-to-speech programs. 

##Limitations
Some books don't have HTML versions that work with this script. If it says 'View full HTML' on the page, it will work. If it says 'Online view' it will not work. If only PDFs are available, it will not work.

##Instructions
Login to Cambridge Core. Use e.g. [cookies.txt Chrome extension](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg) to create a cookies.txt file that this script will use. The cookies.txt file needs to be in the same directory as get.sh

Make get.sh executable: `chmod +x get.sh`

You will need to have [pup](https://github.com/ericchiang/pup) installed.

The script takes the URL to the book's contents page, e.g. `./get.sh https://www.cambridge.org/core/books/cambridge-companion-to-heideggers-being-and-time/36E496653771E4774A6D43AD211930C8`

It will download all parts of the book in the order in which they are displayed in the contents page. The output is a single HTML file. If you have [Pandoc](https://pandoc.org/) installed it will use the HTML to create an ePub.

Tested on MacOS.
