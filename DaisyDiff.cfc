component displayname="DaisyDiff-CFML" hint="Modern CFML wrapper for DaisyDiff Java library" {


    /*
     * Version 0.1 - 4 Feb 2013
     * Home page: https://github.com/sgalashyn/DaisyDiff.cfc
     * Inspired by: https://github.com/hammond13/DaisyDiff.cfc
     * Library home page: http://code.google.com/p/daisydiff/
     */


    /*
     * TODO:
     * - Explore the CreateObject abilities to load custom jar,
     *   to restore the previous functionality with JavaLoader.
     */


    public any function init() hint="Component and included libraries initialization" {

        variables.TransformerFactoryImpl = CreateObject("java", "com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl");
        variables.StringReader = CreateObject("java", "java.io.StringReader");
        variables.StringWriter = CreateObject("java", "java.io.StringWriter");
        variables.Locale = CreateObject("java", "java.util.Locale");
        variables.StreamResult = CreateObject("java", "javax.xml.transform.stream.StreamResult");
        variables.OutputKeys = CreateObject("java", "javax.xml.transform.OutputKeys");
        variables.NekoHtmlParser = CreateObject("java", "org.outerj.daisy.diff.helper.NekoHtmlParser");
        variables.DomTreeBuilder = CreateObject("java", "org.outerj.daisy.diff.html.dom.DomTreeBuilder");
        variables.HTMLDiffer = CreateObject("java", "org.outerj.daisy.diff.html.HTMLDiffer");
        variables.HtmlSaxDiffOutput = CreateObject("java", "org.outerj.daisy.diff.html.HtmlSaxDiffOutput");
        variables.TextNodeComparator = CreateObject("java", "org.outerj.daisy.diff.html.TextNodeComparator");
        variables.InputSource = CreateObject("java", "org.xml.sax.InputSource");

        return this;

    }


    public string function diff(required string olderHtml, required string newerHtml) hint="Perform the diff of the two HTML string versions" {

        local.finalResult = variables.StringWriter.Init();
        local.result = variables.TransformerFactoryImpl.Init().newTransformerHandler();
        local.sr = variables.StreamResult.Init(local.finalResult);
        local.cleaner = variables.NekoHtmlParser.Init();
        local.oldSource = variables.InputSource.Init(variables.StringReader.Init(arguments.olderHtml));
        local.newSource = variables.InputSource.Init(variables.StringReader.Init(arguments.newerHtml));
        local.oldHandler = variables.DomTreeBuilder.Init();
        local.newHandler = variables.DomTreeBuilder.Init();

        result.setResult(local.sr);
        result.getTransformer().setOutputProperty(variables.OutputKeys.OMIT_XML_DECLARATION, "yes");

        local.cleaner.parse(local.oldSource, local.oldHandler);
        local.leftComparator = variables.TextNodeComparator.Init(local.oldHandler, variables.Locale.getDefault());

        local.cleaner.parse(local.newSource, local.newHandler);
        local.rightComparator = variables.TextNodeComparator.Init(local.newHandler, variables.Locale.getDefault());

        local.output = variables.HtmlSaxDiffOutput.Init(local.result, "diff");
        local.differ = variables.HTMLDiffer.Init(local.output);

        local.differ.diff(local.leftComparator, local.rightComparator);

        local.diff = local.finalResult.toString();

        // cleanup the result a bit
        local.diff = ReplaceNoCase(local.diff, '<?xml version="1.0" encoding="UTF-8"?>', '');

        return local.diff;

    }


}
