public with sharing class CSVReader {
	public boolean EOF {
		get
		{
			if( this.position < this.csvStringLength )
				return false;
			else
				return true;
		}
	}

	private string csvString;
	private integer csvStringLength;
	private integer position = 0;

	private static string COMMA = ',';
	private static string NL = '\r\n';
	private static string QUOTE = '"';
	private static string DOUBLE_QUOTE = '""';

	public CSVReader(string csvString )
	{
		this.csvString = csvString;
		this.csvStringLength = csvString.length();
		
		//detrmine end of line character
		if(!csvString.contains('\r\n')){
		    if(csvString.contains('\n')){
		        NL = '\n';
		    }
		    else if(csvString.contains('\r')){
		        NL = '\r';
		    }
		}
	}

	private integer ReadToLine(integer position, List<string> values)
	{
		integer startPos = position;

		string currentValue;
		integer commaPosition, newLinePosition, foundAt;

		List<string> tmpValues = new List<string>();
		while (position < csvStringLength)
		{
			commaPosition = this.csvString.indexOf( COMMA, position );
			newLinePosition = this.csvString.indexOf( NL, position );
			foundAt = Math.min( commaPosition, newLinePosition );
			if( foundAt == -1 )
					foundAt = Math.max( commaPosition, newLinePosition );


			if (foundAt == -1)
			{
				currentValue = this.csvString.substring(startPos);
				position = this.csvStringLength;
			}
			else
			{
				currentValue = this.csvString.substring(startPos, foundAt );
				position = foundAt + 1;
			}

			currentValue = currentValue.trim();

			if( !currentValue.startsWith( QUOTE ) )
			{
				tmpValues.add( currentValue );

				if( foundAt == newLinePosition )
					break;

				startPos = position;
			}
			else if( currentValue.endsWith( QUOTE ) && !currentValue.endsWith( DOUBLE_QUOTE ) )
			{
				if( currentValue.indexOf( DOUBLE_QUOTE ) == -1 )
					tmpValues.add( currentValue.substring( 1, currentValue.length() - 1 ) );
				else
					tmpValues.add( currentValue.substring( 1, currentValue.length() - 1 ).replace( DOUBLE_QUOTE, QUOTE ) );

				if( foundAt == newLinePosition )
					break;

				startPos = position;
			}
		}

		values.addAll( tmpValues );
		return position;
	}

	public List<string> ReadLine()
	{
		List<string> values = new List<string>();
		this.position = this.ReadToLine( this.position, values );
		return values;
	}

	public static List<List<string>> Parse( string csvString )
	{
		List<List<string>> linesValues = new List<List<string>>();

		CSVReader reader = new CSVReader(csvString);
		while (!reader.EOF)
		{
			List<string> actualValues = reader.ReadLine();
			linesValues.Add(actualValues);
		}

		return linesValues;
	}
}