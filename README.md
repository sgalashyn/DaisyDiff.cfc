## Description

Modern CFML wrapper for [DaisyDiff](http://code.google.com/p/daisydiff/) Java library.

Please see the library project page for the CSS and images for styling the output.

## Requirements

Library uses modern CFScript syntax, so it requires at least Adobe ColdFusion 9 or Railo 3.2 engine to work.

This library assumes you have a .jar file available for loading.
Please see [original library](https://github.com/hammond13/DaisyDiff.cfc) for the version which uses JavaLoader.

## Usage Example

    <cfsavecontent variable="leftHTML">
    <p></p><div>This is improved explanation. Thanks.</div>
    <div>This is improved explanation. Thanks.<br></div><p></p>
    </cfsavecontent>

    <cfsavecontent variable="rightHTML">
    <p></p><div>This is improved explanation. Thank you!</div>
    <div>This is improved <strong>explanation</strong>. Thanks.<br></div>
    <p>Good ending.</p>
    </cfsavecontent>

    <cfset local.daisyDiff = CreateObject("component", "DaisyDiff").init() />

    <cfdump var="#local.daisyDiff.diff(leftHTML,rightHTML)#">

    <link href="daisydiff.css" rel="stylesheet">

    <cfoutput>#local.daisyDiff.diff(leftHTML,rightHTML)#</cfoutput>

## License

Library is released under the [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
