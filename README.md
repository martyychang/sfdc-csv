# IETF RFC 4180-compliant CSV Reader

Because CSV is still a thing in the year 20xx

## Dev, Build and Test

Clone this repository, then deploy to your Salesforce org with `sfdx`.

```bash
sfdx force:source:convert -r force-app -d src
sfdx force:mdapi:deploy -d src -w 5
```

Then use the static `CsvReader.readIETFRFC4180CSVFile` function to
process a CSV `Blob` and return something Apex-friendly.

## Resources

* [RFC 4180][1] - Common Format and MIME Type for Comma-Separated Values (CSV) Files

[1]: https://www.rfc-editor.org/info/rfc4180
