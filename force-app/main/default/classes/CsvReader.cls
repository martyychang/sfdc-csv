/**
 * CsvReader contains static methods used for reading a CSV file and returning
 * the contained values in a nested List of Strings.
 */
public class CsvReader {
    /**
     * Returns a List containing Lists of Strings that represents
     * the values contained in an IETF RFC 4180-compliant CSV file.
     *
     * Each element in the outer list represents a row in the CSV file.
     * Each element in the inner list is the value in the field specified
     * by the row-column combination.
     *
     * @param  file the CSV file to read
     * @return      the List<List<String>> containing values read from the
     *              CSV file
     */
    public static List<List<String>> readIETFRFC4180CSVFile(Blob file) {
        String fileString = file.toString();
        
        if (!fileString.endsWith(Parser.CRLF)) {
          fileString = fileString + Parser.CRLF;
        }
        
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CsvValue csvValue = new CsvValue();
        
        Boolean eod = false;  // Whether end of CSV data is reached
        while (!eod) {
          System.debug(fileString);
          
            csvValue = readIETFRFC4180CsvValue(fileString);
            
            rowValues.add(csvValue.value);
            
            if (csvValue.delimiter == Parser.CRLF) {
              fileValues.add(rowValues);
              
              System.debug(rowValues);
              
              if (fileValues.size() > 0) {
                System.assertEquals(fileValues.get(0).size(),
                      rowValues.size());
              }
              
              rowValues = new List<String>();
            }
            
            if (csvValue.biteSize() == fileString.length()) {
              eod = true;
            }
            else {
              fileString = fileString.substring(csvValue.biteSize());
            }
        }
        
        return fileValues;
    }
    
    /**
     * Returns the first String value read from a String representation of
     * data contained in an IETF RFC 4180-compliant CSV file.
     *
     * The data is assumed to be terminated with a CRLF.
     *
     * @param  data the textual CSV data in one long string
     * @return      the first CSV value read from <code>data</code>.
     *              null is returned if no value is discerned.
     */
    public static CsvValue readIETFRFC4180CsvValue(String data) {
        System.assert(data.endsWith(Parser.CRLF));
        
        CsvValue csvValue = new CsvValue();
        
        if (data.startsWith(Parser.DQUOTE)) {
          csvValue.enclosed = true;
          
            Integer searchIndex = 1;      // starting index to search
            Integer dquoteIndex = -1;     // index of DQUOTE
            Integer dquotesIndex = -1;    // index of DQUOTEDQUOTE
                            
            Boolean closerFound = false;
            
            while (!closerFound) {
                dquoteIndex = data.indexOf(Parser.DQUOTE, searchIndex);
                
                dquotesIndex = data.indexOf(Parser.DQUOTEDQUOTE,
                        searchIndex);
                
                System.assert(dquoteIndex != -1);
                
                if (dquoteIndex == dquotesIndex) {
                    searchIndex = dquotesIndex
                            + Parser.DQUOTEDQUOTE.length();
                }
                else {
                    closerFound = true;
                }
            }
            
            csvValue.value = data.substring(
                    Parser.DQUOTE.length(), dquoteIndex)
                            .replaceAll(Parser.DQUOTEDQUOTE, Parser.DQUOTE);
            
            Integer commaIndex = data.indexOf(Parser.COMMA, dquoteIndex);
            Integer crlfIndex = data.indexOf(Parser.CRLF, dquoteIndex);
            
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.delimiter = Parser.COMMA;
            }
            else {
                csvValue.delimiter = Parser.CRLF;
            }
        }
        else {
          csvValue.enclosed = false;
          
            Integer commaIndex = data.indexOf(Parser.COMMA);
            Integer crlfIndex = data.indexOf(Parser.CRLF);
            
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.value = data.substring(0, commaIndex);
                csvValue.delimiter = Parser.COMMA;
            }
            else {
                csvValue.value = data.substring(0, crlfIndex);
                csvValue.delimiter = Parser.CRLF;
            }
        }
        
        System.debug('Returning: ' + csvValue);
        
        return csvValue;
    }
    
    /**
     * CsvValue is a class structure containing information about a CSV
     * value that was read from a CSV file, including such information as
     * whether the value was encapsulated in double-quotes.
     */
    public class CsvValue {
        /**
         * The field value that was read from the CSV file.
         */
        public String value;
        
        /**
         * Whether the value was surrounded by double-quotes.
         */
        public Boolean enclosed;
        
        /**
         * The comma or CRLF delimiter that identified the end of the CSV value.
         */
        public String delimiter;
        
        /**
         * Default constructor, setting all members to null.
         */
        public CsvValue() {
            this(null, null, null);
        }
        
        /**
         * Constructor.
         *
         * @param value     the field value
         * @param enclosed  whether the value was surrounded by double-quotes
         * @param delimiter the delimiter that identified the end
         *                  of the CSV value
         */
        public CsvValue(String value, Boolean enclosed, String delimiter) {
            this.value = value;
            this.enclosed = enclosed;
            this.delimiter = delimiter;
        }
        
        /**
         * Returns the number of characters to remove from the data
         * String which produced the CsvValue in order to reach the next
         * value in the data String.
         */
        public Integer biteSize() {
          Integer biteSize = value
                 .replaceAll(Parser.DQUOTE, Parser.DQUOTEDQUOTE).length()
                         + delimiter.length();
          
          if (enclosed) {
            biteSize += Parser.DQUOTE.length() * 2;
          }
          
          System.debug('biteSize: ' + biteSize);
          
          return biteSize;
        }
        
        /**
         * Returns whether a CsvValue has the same <code>value</code> and
         * <code>enclosed</code> as another CsvValue.
         */
        public Boolean equals(CsvValue compCsvValue) {
            return this.value.equals(compCsvValue.value)
                    && this.enclosed == compCsvValue.enclosed
                            && this.delimiter == compCsvValue.delimiter;
        }
        
        /**
         * Asserts that two <code>CsvValue</code> instances have the same
         * <code>value</code> and <code>enclosed</code>.
         */
        public void assertEquals(CsvValue compCsvValue) {
            System.assertEquals(value, compCsvValue.value);
            System.assertEquals(enclosed, compCsvValue.enclosed);
            System.assertEquals(delimiter, compCsvValue.delimiter);
        }
    }
}