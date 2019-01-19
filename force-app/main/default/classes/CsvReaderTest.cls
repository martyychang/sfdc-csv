@isTest
private class CsvReaderTest {
    
    /**
     * Test some use cases for reading IETF RFC 4180-compliant CSV values.
     */
    @isTest
    public static void readIETFRFC4180CsvValueTest() {
        String data = null;  // Placeholder for data to use in testing.
        
        System.debug(data = Parser.CRLF);
        new CsvReader.CsvValue('', false, Parser.CRLF)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = '""' + Parser.CRLF);
        new CsvReader.CsvValue('', true, Parser.CRLF)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = '"",asdf' + Parser.CRLF);
        new CsvReader.CsvValue('', true, Parser.COMMA)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = ',asdf' + Parser.CRLF);
        new CsvReader.CsvValue('', false, Parser.COMMA)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = '"' + Parser.CRLF + '",blah' + Parser.CRLF);
        new CsvReader.CsvValue(Parser.CRLF, true, Parser.COMMA)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = '"""marty""","""chang"""' + Parser.CRLF);
        new CsvReader.CsvValue('"marty"', true, Parser.COMMA)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = '"com""pli""cate' + Parser.CRLF + 'd"'
                + Parser.CRLF);
        new CsvReader.CsvValue('com"pli"cate' + Parser.CRLF + 'd', true, Parser.CRLF)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
        
        System.debug(data = 'asdf' + Parser.CRLF);
        new CsvReader.CsvValue('asdf', false, Parser.CRLF)
                .assertEquals(CsvReader.readIETFRFC4180CsvValue(data));
    }
    
    /**
     * Tests one case of parsing a CSV file that contains the following data:
     *
     * abc,"def","g""h""i"
     * "j
     * kl","m
     * n""o""",
     */
    @isTest
    public static void readIETFRFC4180CSVFile() {
      String data = 'abc,"def","g""h""i"' + Parser.CRLF + '"j' + Parser.CRLF
             + 'kl","m' + Parser.CRLF + 'n""o""",';
      
      List<List<String>> fileValues =
             CsvReader.readIETFRFC4180CSVFile(Blob.valueOf(data));
    }
}
