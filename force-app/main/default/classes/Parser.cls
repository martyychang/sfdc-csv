/**
 * Parser is a utility class that contains constants and properties
 * designed to assist in the parsing of Strings and other forms of data.
 */
public class Parser {
    /**
     * Comma String as defined by IETF RFC 4180.
     */
    public static final String COMMA =
            String.fromCharArray(new List<Integer> { 44 });

    /**
     * Carriage return String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String CR = '\r';
    
    /**
     * Double-quote String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String DQUOTE = '\"';
    
    /**
     * Line feed String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String LF = '\n';
    
    /**
     * Carriage return String followed by a line feed String.
     */
    public static final String CRLF = CR + LF;
    
    /**
     * Line feed String followed by a carriage return String.
     */
    public static final String LFCR = LF + CR;
  
    /**
     * Escaped double-quotes per IETF RFC 4180.
     */
    public static final String DQUOTEDQUOTE = DQUOTE + DQUOTE;
}