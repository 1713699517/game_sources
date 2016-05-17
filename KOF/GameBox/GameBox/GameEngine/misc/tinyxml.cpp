/*
www.sourceforge.net/projects/tinyxml
Original code by Lee Thomason (www.grinninglizard.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any
damages arising from the use of this software.

Permission is granted to anyone to use this software for any
purpose, including commercial applications, and to alter it and
redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must
not claim that you wrote the original software. If you use this
software in a product, an acknowledgment in the product documentation
would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and
must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source
distribution.
*/

#include <ctype.h>

#ifdef TIXML_USE_STL
#include <sstream>
#include <iostream>
#endif

#include "tinyxml.h"

FILE* TiXmlFOpen( const char* filename, const char* mode );

bool CTiXmlBase::condenseWhiteSpace = true;

// Microsoft compiler security
FILE* TiXmlFOpen( const char* filename, const char* mode )
{
	#if defined(_MSC_VER) && (_MSC_VER >= 1400 )
		FILE* fp = 0;
		errno_t err = fopen_s( &fp, filename, mode );
		if ( !err && fp )
			return fp;
		return 0;
	#else
		return fopen( filename, mode );
	#endif
}

void CTiXmlBase::EncodeString( const TIXML_STRING& str, TIXML_STRING* outString )
{
	int i=0;

	while( i<(int)str.length() )
	{
		unsigned char c = (unsigned char) str[i];

		if (    c == '&' 
		     && i < ( (int)str.length() - 2 )
			 && str[i+1] == '#'
			 && str[i+2] == 'x' )
		{
			// Hexadecimal character reference.
			// Pass through unchanged.
			// &#xA9;	-- copyright symbol, for example.
			//
			// The -1 is a bug fix from Rob Laveaux. It keeps
			// an overflow from happening if there is no ';'.
			// There are actually 2 ways to exit this loop -
			// while fails (error case) and break (semicolon found).
			// However, there is no mechanism (currently) for
			// this function to return an error.
			while ( i<(int)str.length()-1 )
			{
				outString->append( str.c_str() + i, 1 );
				++i;
				if ( str[i] == ';' )
					break;
			}
		}
		else if ( c == '&' )
		{
			outString->append( entity[0].str, entity[0].strLength );
			++i;
		}
		else if ( c == '<' )
		{
			outString->append( entity[1].str, entity[1].strLength );
			++i;
		}
		else if ( c == '>' )
		{
			outString->append( entity[2].str, entity[2].strLength );
			++i;
		}
		else if ( c == '\"' )
		{
			outString->append( entity[3].str, entity[3].strLength );
			++i;
		}
		else if ( c == '\'' )
		{
			outString->append( entity[4].str, entity[4].strLength );
			++i;
		}
		else if ( c < 32 )
		{
			// Easy pass at non-alpha/numeric/symbol
			// Below 32 is symbolic.
			char buf[ 32 ];
			
			#if defined(TIXML_SNPRINTF)		
				TIXML_SNPRINTF( buf, sizeof(buf), "&#x%02X;", (unsigned) ( c & 0xff ) );
			#else
				sprintf( buf, "&#x%02X;", (unsigned) ( c & 0xff ) );
			#endif		

			//*ME:	warning C4267: convert 'size_t' to 'int'
			//*ME:	Int-Cast to make compiler happy ...
			outString->append( buf, (int)strlen( buf ) );
			++i;
		}
		else
		{
			//char realc = (char) c;
			//outString->append( &realc, 1 );
			*outString += (char) c;	// somewhat more efficient function call.
			++i;
		}
	}
}


CTiXmlNode::CTiXmlNode( NodeType _type ) : CTiXmlBase()
{
	parent = 0;
	type = _type;
	firstChild = 0;
	lastChild = 0;
	prev = 0;
	next = 0;
}


CTiXmlNode::~CTiXmlNode()
{
	CTiXmlNode* node = firstChild;
	CTiXmlNode* temp = 0;

	while ( node )
	{
		temp = node;
		node = node->next;
		delete temp;
	}	
}


void CTiXmlNode::CopyTo( CTiXmlNode* target ) const
{
	target->SetValue (value.c_str() );
	target->userData = userData; 
	target->location = location;
}


void CTiXmlNode::Clear()
{
	CTiXmlNode* node = firstChild;
	CTiXmlNode* temp = 0;

	while ( node )
	{
		temp = node;
		node = node->next;
		delete temp;
	}	

	firstChild = 0;
	lastChild = 0;
}


CTiXmlNode* CTiXmlNode::LinkEndChild( CTiXmlNode* node )
{
	assert( node->parent == 0 || node->parent == this );
	assert( node->GetDocument() == 0 || node->GetDocument() == this->GetDocument() );

	if ( node->Type() == CTiXmlNode::TINYXML_DOCUMENT )
	{
		delete node;
		if ( GetDocument() ) 
			GetDocument()->SetError( TIXML_ERROR_DOCUMENT_TOP_ONLY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return 0;
	}

	node->parent = this;

	node->prev = lastChild;
	node->next = 0;

	if ( lastChild )
		lastChild->next = node;
	else
		firstChild = node;			// it was an empty list.

	lastChild = node;
	return node;
}


CTiXmlNode* CTiXmlNode::InsertEndChild( const CTiXmlNode& addThis )
{
	if ( addThis.Type() == CTiXmlNode::TINYXML_DOCUMENT )
	{
		if ( GetDocument() ) 
			GetDocument()->SetError( TIXML_ERROR_DOCUMENT_TOP_ONLY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return 0;
	}
	CTiXmlNode* node = addThis.Clone();
	if ( !node )
		return 0;

	return LinkEndChild( node );
}


CTiXmlNode* CTiXmlNode::InsertBeforeChild( CTiXmlNode* beforeThis, const CTiXmlNode& addThis )
{	
	if ( !beforeThis || beforeThis->parent != this ) {
		return 0;
	}
	if ( addThis.Type() == CTiXmlNode::TINYXML_DOCUMENT )
	{
		if ( GetDocument() ) 
			GetDocument()->SetError( TIXML_ERROR_DOCUMENT_TOP_ONLY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return 0;
	}

	CTiXmlNode* node = addThis.Clone();
	if ( !node )
		return 0;
	node->parent = this;

	node->next = beforeThis;
	node->prev = beforeThis->prev;
	if ( beforeThis->prev )
	{
		beforeThis->prev->next = node;
	}
	else
	{
		assert( firstChild == beforeThis );
		firstChild = node;
	}
	beforeThis->prev = node;
	return node;
}


CTiXmlNode* CTiXmlNode::InsertAfterChild( CTiXmlNode* afterThis, const CTiXmlNode& addThis )
{
	if ( !afterThis || afterThis->parent != this ) {
		return 0;
	}
	if ( addThis.Type() == CTiXmlNode::TINYXML_DOCUMENT )
	{
		if ( GetDocument() ) 
			GetDocument()->SetError( TIXML_ERROR_DOCUMENT_TOP_ONLY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return 0;
	}

	CTiXmlNode* node = addThis.Clone();
	if ( !node )
		return 0;
	node->parent = this;

	node->prev = afterThis;
	node->next = afterThis->next;
	if ( afterThis->next )
	{
		afterThis->next->prev = node;
	}
	else
	{
		assert( lastChild == afterThis );
		lastChild = node;
	}
	afterThis->next = node;
	return node;
}


CTiXmlNode* CTiXmlNode::ReplaceChild( CTiXmlNode* replaceThis, const CTiXmlNode& withThis )
{
	if ( !replaceThis )
		return 0;

	if ( replaceThis->parent != this )
		return 0;

	if ( withThis.ToDocument() ) {
		// A document can never be a child.	Thanks to Noam.
		CTiXmlDocument* document = GetDocument();
		if ( document ) 
			document->SetError( TIXML_ERROR_DOCUMENT_TOP_ONLY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return 0;
	}

	CTiXmlNode* node = withThis.Clone();
	if ( !node )
		return 0;

	node->next = replaceThis->next;
	node->prev = replaceThis->prev;

	if ( replaceThis->next )
		replaceThis->next->prev = node;
	else
		lastChild = node;

	if ( replaceThis->prev )
		replaceThis->prev->next = node;
	else
		firstChild = node;

	delete replaceThis;
	node->parent = this;
	return node;
}


bool CTiXmlNode::RemoveChild( CTiXmlNode* removeThis )
{
	if ( !removeThis ) {
		return false;
	}

	if ( removeThis->parent != this )
	{	
		assert( 0 );
		return false;
	}

	if ( removeThis->next )
		removeThis->next->prev = removeThis->prev;
	else
		lastChild = removeThis->prev;

	if ( removeThis->prev )
		removeThis->prev->next = removeThis->next;
	else
		firstChild = removeThis->next;

	delete removeThis;
	return true;
}

const CTiXmlNode* CTiXmlNode::FirstChild( const char * _value ) const
{
	const CTiXmlNode* node;
	for ( node = firstChild; node; node = node->next )
	{
		if ( strcmp( node->Value(), _value ) == 0 )
			return node;
	}
	return 0;
}


const CTiXmlNode* CTiXmlNode::LastChild( const char * _value ) const
{
	const CTiXmlNode* node;
	for ( node = lastChild; node; node = node->prev )
	{
		if ( strcmp( node->Value(), _value ) == 0 )
			return node;
	}
	return 0;
}


const CTiXmlNode* CTiXmlNode::IterateChildren( const CTiXmlNode* previous ) const
{
	if ( !previous )
	{
		return FirstChild();
	}
	else
	{
		assert( previous->parent == this );
		return previous->NextSibling();
	}
}


const CTiXmlNode* CTiXmlNode::IterateChildren( const char * val, const CTiXmlNode* previous ) const
{
	if ( !previous )
	{
		return FirstChild( val );
	}
	else
	{
		assert( previous->parent == this );
		return previous->NextSibling( val );
	}
}


const CTiXmlNode* CTiXmlNode::NextSibling( const char * _value ) const 
{
	const CTiXmlNode* node;
	for ( node = next; node; node = node->next )
	{
		if ( strcmp( node->Value(), _value ) == 0 )
			return node;
	}
	return 0;
}


const CTiXmlNode* CTiXmlNode::PreviousSibling( const char * _value ) const
{
	const CTiXmlNode* node;
	for ( node = prev; node; node = node->prev )
	{
		if ( strcmp( node->Value(), _value ) == 0 )
			return node;
	}
	return 0;
}


void CTiXmlElement::RemoveAttribute( const char * name )
{
    #ifdef TIXML_USE_STL
	TIXML_STRING str( name );
	CTiXmlAttribute* node = attributeSet.Find( str );
	#else
	CTiXmlAttribute* node = attributeSet.Find( name );
	#endif
	if ( node )
	{
		attributeSet.Remove( node );
		delete node;
	}
}

const CTiXmlElement* CTiXmlNode::FirstChildElement() const
{
	const CTiXmlNode* node;

	for (	node = FirstChild();
			node;
			node = node->NextSibling() )
	{
		if ( node->ToElement() )
			return node->ToElement();
	}
	return 0;
}


const CTiXmlElement* CTiXmlNode::FirstChildElement( const char * _value ) const
{
	const CTiXmlNode* node;

	for (	node = FirstChild( _value );
			node;
			node = node->NextSibling( _value ) )
	{
		if ( node->ToElement() )
			return node->ToElement();
	}
	return 0;
}


const CTiXmlElement* CTiXmlNode::NextSiblingElement() const
{
	const CTiXmlNode* node;

	for (	node = NextSibling();
			node;
			node = node->NextSibling() )
	{
		if ( node->ToElement() )
			return node->ToElement();
	}
	return 0;
}


const CTiXmlElement* CTiXmlNode::NextSiblingElement( const char * _value ) const
{
	const CTiXmlNode* node;

	for (	node = NextSibling( _value );
			node;
			node = node->NextSibling( _value ) )
	{
		if ( node->ToElement() )
			return node->ToElement();
	}
	return 0;
}


const CTiXmlDocument* CTiXmlNode::GetDocument() const
{
	const CTiXmlNode* node;

	for( node = this; node; node = node->parent )
	{
		if ( node->ToDocument() )
			return node->ToDocument();
	}
	return 0;
}


CTiXmlElement::CTiXmlElement (const char * _value)
	: CTiXmlNode( CTiXmlNode::TINYXML_ELEMENT )
{
	firstChild = lastChild = 0;
	value = _value;
}


#ifdef TIXML_USE_STL
CTiXmlElement::CTiXmlElement( const std::string& _value ) 
	: CTiXmlNode( CTiXmlNode::TINYXML_ELEMENT )
{
	firstChild = lastChild = 0;
	value = _value;
}
#endif


CTiXmlElement::CTiXmlElement( const CTiXmlElement& copy)
	: CTiXmlNode( CTiXmlNode::TINYXML_ELEMENT )
{
	firstChild = lastChild = 0;
	copy.CopyTo( this );	
}


CTiXmlElement& CTiXmlElement::operator=( const CTiXmlElement& base )
{
	ClearThis();
	base.CopyTo( this );
	return *this;
}


CTiXmlElement::~CTiXmlElement()
{
	ClearThis();
}


void CTiXmlElement::ClearThis()
{
	Clear();
	while( attributeSet.First() )
	{
		CTiXmlAttribute* node = attributeSet.First();
		attributeSet.Remove( node );
		delete node;
	}
}


const char* CTiXmlElement::Attribute( const char* name ) const
{
	const CTiXmlAttribute* node = attributeSet.Find( name );
	if ( node )
		return node->Value();
	return 0;
}


#ifdef TIXML_USE_STL
const std::string* CTiXmlElement::Attribute( const std::string& name ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	if ( attrib )
		return &attrib->ValueStr();
	return 0;
}
#endif


const char* CTiXmlElement::Attribute( const char* name, int* i ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	const char* result = 0;

	if ( attrib ) {
		result = attrib->Value();
		if ( i ) {
			attrib->QueryIntValue( i );
		}
	}
	return result;
}


#ifdef TIXML_USE_STL
const std::string* CTiXmlElement::Attribute( const std::string& name, int* i ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	const std::string* result = 0;

	if ( attrib ) {
		result = &attrib->ValueStr();
		if ( i ) {
			attrib->QueryIntValue( i );
		}
	}
	return result;
}
#endif


const char* CTiXmlElement::Attribute( const char* name, double* d ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	const char* result = 0;

	if ( attrib ) {
		result = attrib->Value();
		if ( d ) {
			attrib->QueryDoubleValue( d );
		}
	}
	return result;
}


#ifdef TIXML_USE_STL
const std::string* CTiXmlElement::Attribute( const std::string& name, double* d ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	const std::string* result = 0;

	if ( attrib ) {
		result = &attrib->ValueStr();
		if ( d ) {
			attrib->QueryDoubleValue( d );
		}
	}
	return result;
}
#endif


int CTiXmlElement::QueryIntAttribute( const char* name, int* ival ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	if ( !attrib )
		return TIXML_NO_ATTRIBUTE;
	return attrib->QueryIntValue( ival );
}


int CTiXmlElement::QueryUnsignedAttribute( const char* name, unsigned* value ) const
{
	const CTiXmlAttribute* node = attributeSet.Find( name );
	if ( !node )
		return TIXML_NO_ATTRIBUTE;

	int ival = 0;
	int result = node->QueryIntValue( &ival );
	*value = (unsigned)ival;
	return result;
}


int CTiXmlElement::QueryBoolAttribute( const char* name, bool* bval ) const
{
	const CTiXmlAttribute* node = attributeSet.Find( name );
	if ( !node )
		return TIXML_NO_ATTRIBUTE;
	
	int result = TIXML_WRONG_TYPE;
	if (    StringEqual( node->Value(), "true", true, TIXML_ENCODING_UNKNOWN ) 
		 || StringEqual( node->Value(), "yes", true, TIXML_ENCODING_UNKNOWN ) 
		 || StringEqual( node->Value(), "1", true, TIXML_ENCODING_UNKNOWN ) ) 
	{
		*bval = true;
		result = TIXML_SUCCESS;
	}
	else if (    StringEqual( node->Value(), "false", true, TIXML_ENCODING_UNKNOWN ) 
			  || StringEqual( node->Value(), "no", true, TIXML_ENCODING_UNKNOWN ) 
			  || StringEqual( node->Value(), "0", true, TIXML_ENCODING_UNKNOWN ) ) 
	{
		*bval = false;
		result = TIXML_SUCCESS;
	}
	return result;
}



#ifdef TIXML_USE_STL
int CTiXmlElement::QueryIntAttribute( const std::string& name, int* ival ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	if ( !attrib )
		return TIXML_NO_ATTRIBUTE;
	return attrib->QueryIntValue( ival );
}
#endif


int CTiXmlElement::QueryDoubleAttribute( const char* name, double* dval ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	if ( !attrib )
		return TIXML_NO_ATTRIBUTE;
	return attrib->QueryDoubleValue( dval );
}


#ifdef TIXML_USE_STL
int CTiXmlElement::QueryDoubleAttribute( const std::string& name, double* dval ) const
{
	const CTiXmlAttribute* attrib = attributeSet.Find( name );
	if ( !attrib )
		return TIXML_NO_ATTRIBUTE;
	return attrib->QueryDoubleValue( dval );
}
#endif


void CTiXmlElement::SetAttribute( const char * name, int val )
{	
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( name );
	if ( attrib ) {
		attrib->SetIntValue( val );
	}
}


#ifdef TIXML_USE_STL
void CTiXmlElement::SetAttribute( const std::string& name, int val )
{	
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( name );
	if ( attrib ) {
		attrib->SetIntValue( val );
	}
}
#endif


void CTiXmlElement::SetDoubleAttribute( const char * name, double val )
{	
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( name );
	if ( attrib ) {
		attrib->SetDoubleValue( val );
	}
}


#ifdef TIXML_USE_STL
void CTiXmlElement::SetDoubleAttribute( const std::string& name, double val )
{	
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( name );
	if ( attrib ) {
		attrib->SetDoubleValue( val );
	}
}
#endif 


void CTiXmlElement::SetAttribute( const char * cname, const char * cvalue )
{
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( cname );
	if ( attrib ) {
		attrib->SetValue( cvalue );
	}
}


#ifdef TIXML_USE_STL
void CTiXmlElement::SetAttribute( const std::string& _name, const std::string& _value )
{
	CTiXmlAttribute* attrib = attributeSet.FindOrCreate( _name );
	if ( attrib ) {
		attrib->SetValue( _value );
	}
}
#endif


void CTiXmlElement::Print( FILE* cfile, int depth ) const
{
	int i;
	assert( cfile );
	for ( i=0; i<depth; i++ ) {
		fprintf( cfile, "    " );
	}

	fprintf( cfile, "<%s", value.c_str() );

	const CTiXmlAttribute* attrib;
	for ( attrib = attributeSet.First(); attrib; attrib = attrib->Next() )
	{
		fprintf( cfile, " " );
		attrib->Print( cfile, depth );
	}

	// There are 3 different formatting approaches:
	// 1) An element without children is printed as a <foo /> node
	// 2) An element with only a text child is printed as <foo> text </foo>
	// 3) An element with children is printed on multiple lines.
	CTiXmlNode* node;
	if ( !firstChild )
	{
		fprintf( cfile, " />" );
	}
	else if ( firstChild == lastChild && firstChild->ToText() )
	{
		fprintf( cfile, ">" );
		firstChild->Print( cfile, depth + 1 );
		fprintf( cfile, "</%s>", value.c_str() );
	}
	else
	{
		fprintf( cfile, ">" );

		for ( node = firstChild; node; node=node->NextSibling() )
		{
			if ( !node->ToText() )
			{
				fprintf( cfile, "\n" );
			}
			node->Print( cfile, depth+1 );
		}
		fprintf( cfile, "\n" );
		for( i=0; i<depth; ++i ) {
			fprintf( cfile, "    " );
		}
		fprintf( cfile, "</%s>", value.c_str() );
	}
}


void CTiXmlElement::CopyTo( CTiXmlElement* target ) const
{
	// superclass:
	CTiXmlNode::CopyTo( target );

	// Element class: 
	// Clone the attributes, then clone the children.
	const CTiXmlAttribute* attribute = 0;
	for(	attribute = attributeSet.First();
	attribute;
	attribute = attribute->Next() )
	{
		target->SetAttribute( attribute->Name(), attribute->Value() );
	}

	CTiXmlNode* node = 0;
	for ( node = firstChild; node; node = node->NextSibling() )
	{
		target->LinkEndChild( node->Clone() );
	}
}

bool CTiXmlElement::Accept( CTiXmlVisitor* visitor ) const
{
	if ( visitor->VisitEnter( *this, attributeSet.First() ) ) 
	{
		for ( const CTiXmlNode* node=FirstChild(); node; node=node->NextSibling() )
		{
			if ( !node->Accept( visitor ) )
				break;
		}
	}
	return visitor->VisitExit( *this );
}


CTiXmlNode* CTiXmlElement::Clone() const
{
	CTiXmlElement* clone = new CTiXmlElement( Value() );
	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


const char* CTiXmlElement::GetText() const
{
	const CTiXmlNode* child = this->FirstChild();
	if ( child ) {
		const CTiXmlText* childText = child->ToText();
		if ( childText ) {
			return childText->Value();
		}
	}
	return 0;
}


CTiXmlDocument::CTiXmlDocument() : CTiXmlNode( CTiXmlNode::TINYXML_DOCUMENT )
{
	tabsize = 4;
	useMicrosoftBOM = false;
	ClearError();
}

CTiXmlDocument::CTiXmlDocument( const char * documentName ) : CTiXmlNode( CTiXmlNode::TINYXML_DOCUMENT )
{
	tabsize = 4;
	useMicrosoftBOM = false;
	value = documentName;
	ClearError();
}


#ifdef TIXML_USE_STL
CTiXmlDocument::CTiXmlDocument( const std::string& documentName ) : CTiXmlNode( CTiXmlNode::TINYXML_DOCUMENT )
{
	tabsize = 4;
	useMicrosoftBOM = false;
    value = documentName;
	ClearError();
}
#endif


CTiXmlDocument::CTiXmlDocument( const CTiXmlDocument& copy ) : CTiXmlNode( CTiXmlNode::TINYXML_DOCUMENT )
{
	copy.CopyTo( this );
}


CTiXmlDocument& CTiXmlDocument::operator=( const CTiXmlDocument& copy )
{
	Clear();
	copy.CopyTo( this );
	return *this;
}


bool CTiXmlDocument::LoadFile( enumTiXmlEncoding encoding )
{
	return LoadFile( Value(), encoding );
}


bool CTiXmlDocument::SaveFile() const
{
	return SaveFile( Value() );
}

bool CTiXmlDocument::LoadFile( const char* _filename, enumTiXmlEncoding encoding )
{
	TIXML_STRING filename( _filename );
	value = filename;

	// reading in binary mode so that tinyxml can normalize the EOL
	FILE* file = TiXmlFOpen( value.c_str (), "rb" );	

	if ( file )
	{
		bool result = LoadFile( file, encoding );
		fclose( file );
		return result;
	}
	else
	{
		SetError( TIXML_ERROR_OPENING_FILE, 0, 0, TIXML_ENCODING_UNKNOWN );
		return false;
	}
}

bool CTiXmlDocument::LoadFile( FILE* file, enumTiXmlEncoding encoding )
{
	if ( !file ) 
	{
		SetError( TIXML_ERROR_OPENING_FILE, 0, 0, TIXML_ENCODING_UNKNOWN );
		return false;
	}

	// Delete the existing data:
	Clear();
	location.Clear();

	// Get the file size, so we can pre-allocate the string. HUGE speed impact.
	long length = 0;
	fseek( file, 0, SEEK_END );
	length = ftell( file );
	fseek( file, 0, SEEK_SET );

	// Strange case, but good to handle up front.
	if ( length <= 0 )
	{
		SetError( TIXML_ERROR_DOCUMENT_EMPTY, 0, 0, TIXML_ENCODING_UNKNOWN );
		return false;
	}

	// Subtle bug here. TinyXml did use fgets. But from the XML spec:
	// 2.11 End-of-Line Handling
	// <snip>
	// <quote>
	// ...the XML processor MUST behave as if it normalized all line breaks in external 
	// parsed entities (including the document entity) on input, before parsing, by translating 
	// both the two-character sequence #xD #xA and any #xD that is not followed by #xA to 
	// a single #xA character.
	// </quote>
	//
	// It is not clear fgets does that, and certainly isn't clear it works cross platform. 
	// Generally, you expect fgets to translate from the convention of the OS to the c/unix
	// convention, and not work generally.

	/*
	while( fgets( buf, sizeof(buf), file ) )
	{
		data += buf;
	}
	*/

	char* buf = new char[ length+1 ];
	buf[0] = 0;

	if ( fread( buf, length, 1, file ) != 1 ) {
		delete [] buf;
		SetError( TIXML_ERROR_OPENING_FILE, 0, 0, TIXML_ENCODING_UNKNOWN );
		return false;
	}

	// Process the buffer in place to normalize new lines. (See comment above.)
	// Copies from the 'p' to 'q' pointer, where p can advance faster if
	// a newline-carriage return is hit.
	//
	// Wikipedia:
	// Systems based on ASCII or a compatible character set use either LF  (Line feed, '\n', 0x0A, 10 in decimal) or 
	// CR (Carriage return, '\r', 0x0D, 13 in decimal) individually, or CR followed by LF (CR+LF, 0x0D 0x0A)...
	//		* LF:    Multics, Unix and Unix-like systems (GNU/Linux, AIX, Xenix, Mac OS X, FreeBSD, etc.), BeOS, Amiga, RISC OS, and others
    //		* CR+LF: DEC RT-11 and most other early non-Unix, non-IBM OSes, CP/M, MP/M, DOS, OS/2, Microsoft Windows, Symbian OS
    //		* CR:    Commodore 8-bit machines, Apple II family, Mac OS up to version 9 and OS-9

	const char* p = buf;	// the read head
	char* q = buf;			// the write head
	const char CR = 0x0d;
	const char LF = 0x0a;

	buf[length] = 0;
	while( *p ) {
		assert( p < (buf+length) );
		assert( q <= (buf+length) );
		assert( q <= p );

		if ( *p == CR ) {
			*q++ = LF;
			p++;
			if ( *p == LF ) {		// check for CR+LF (and skip LF)
				p++;
			}
		}
		else {
			*q++ = *p++;
		}
	}
	assert( q <= (buf+length) );
	*q = 0;

	Parse( buf, 0, encoding );

	delete [] buf;
	return !Error();
}


bool CTiXmlDocument::SaveFile( const char * filename ) const
{
	// The old c stuff lives on...
	FILE* fp = TiXmlFOpen( filename, "w" );
	if ( fp )
	{
		bool result = SaveFile( fp );
		fclose( fp );
		return result;
	}
	return false;
}


bool CTiXmlDocument::SaveFile( FILE* fp ) const
{
	if ( useMicrosoftBOM ) 
	{
		const unsigned char TIXML_UTF_LEAD_0 = 0xefU;
		const unsigned char TIXML_UTF_LEAD_1 = 0xbbU;
		const unsigned char TIXML_UTF_LEAD_2 = 0xbfU;

		fputc( TIXML_UTF_LEAD_0, fp );
		fputc( TIXML_UTF_LEAD_1, fp );
		fputc( TIXML_UTF_LEAD_2, fp );
	}
	Print( fp, 0 );
	return (ferror(fp) == 0);
}


void CTiXmlDocument::CopyTo( CTiXmlDocument* target ) const
{
	CTiXmlNode::CopyTo( target );

	target->error = error;
	target->errorId = errorId;
	target->errorDesc = errorDesc;
	target->tabsize = tabsize;
	target->errorLocation = errorLocation;
	target->useMicrosoftBOM = useMicrosoftBOM;

	CTiXmlNode* node = 0;
	for ( node = firstChild; node; node = node->NextSibling() )
	{
		target->LinkEndChild( node->Clone() );
	}	
}


CTiXmlNode* CTiXmlDocument::Clone() const
{
	CTiXmlDocument* clone = new CTiXmlDocument();
	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


void CTiXmlDocument::Print( FILE* cfile, int depth ) const
{
	assert( cfile );
	for ( const CTiXmlNode* node=FirstChild(); node; node=node->NextSibling() )
	{
		node->Print( cfile, depth );
		fprintf( cfile, "\n" );
	}
}


bool CTiXmlDocument::Accept( CTiXmlVisitor* visitor ) const
{
	if ( visitor->VisitEnter( *this ) )
	{
		for ( const CTiXmlNode* node=FirstChild(); node; node=node->NextSibling() )
		{
			if ( !node->Accept( visitor ) )
				break;
		}
	}
	return visitor->VisitExit( *this );
}


const CTiXmlAttribute* CTiXmlAttribute::Next() const
{
	// We are using knowledge of the sentinel. The sentinel
	// have a value or name.
	if ( next->value.empty() && next->name.empty() )
		return 0;
	return next;
}

/*
CTiXmlAttribute* CTiXmlAttribute::Next()
{
	// We are using knowledge of the sentinel. The sentinel
	// have a value or name.
	if ( next->value.empty() && next->name.empty() )
		return 0;
	return next;
}
*/

const CTiXmlAttribute* CTiXmlAttribute::Previous() const
{
	// We are using knowledge of the sentinel. The sentinel
	// have a value or name.
	if ( prev->value.empty() && prev->name.empty() )
		return 0;
	return prev;
}

/*
CTiXmlAttribute* CTiXmlAttribute::Previous()
{
	// We are using knowledge of the sentinel. The sentinel
	// have a value or name.
	if ( prev->value.empty() && prev->name.empty() )
		return 0;
	return prev;
}
*/

void CTiXmlAttribute::Print( FILE* cfile, int /*depth*/, TIXML_STRING* str ) const
{
	TIXML_STRING n, v;

	EncodeString( name, &n );
	EncodeString( value, &v );

	if (value.find ('\"') == TIXML_STRING::npos) {
		if ( cfile ) {
			fprintf (cfile, "%s=\"%s\"", n.c_str(), v.c_str() );
		}
		if ( str ) {
			(*str) += n; (*str) += "=\""; (*str) += v; (*str) += "\"";
		}
	}
	else {
		if ( cfile ) {
			fprintf (cfile, "%s='%s'", n.c_str(), v.c_str() );
		}
		if ( str ) {
			(*str) += n; (*str) += "='"; (*str) += v; (*str) += "'";
		}
	}
}


int CTiXmlAttribute::QueryIntValue( int* ival ) const
{
	if ( TIXML_SSCANF( value.c_str(), "%d", ival ) == 1 )
		return TIXML_SUCCESS;
	return TIXML_WRONG_TYPE;
}

int CTiXmlAttribute::QueryDoubleValue( double* dval ) const
{
	if ( TIXML_SSCANF( value.c_str(), "%lf", dval ) == 1 )
		return TIXML_SUCCESS;
	return TIXML_WRONG_TYPE;
}

void CTiXmlAttribute::SetIntValue( int _value )
{
	char buf [64];
	#if defined(TIXML_SNPRINTF)		
		TIXML_SNPRINTF(buf, sizeof(buf), "%d", _value);
	#else
		sprintf (buf, "%d", _value);
	#endif
	SetValue (buf);
}

void CTiXmlAttribute::SetDoubleValue( double _value )
{
	char buf [256];
	#if defined(TIXML_SNPRINTF)		
		TIXML_SNPRINTF( buf, sizeof(buf), "%g", _value);
	#else
		sprintf (buf, "%g", _value);
	#endif
	SetValue (buf);
}

int CTiXmlAttribute::IntValue() const
{
	return atoi (value.c_str ());
}

double  CTiXmlAttribute::DoubleValue() const
{
	return atof (value.c_str ());
}


CTiXmlComment::CTiXmlComment( const CTiXmlComment& copy ) : CTiXmlNode( CTiXmlNode::TINYXML_COMMENT )
{
	copy.CopyTo( this );
}


CTiXmlComment& CTiXmlComment::operator=( const CTiXmlComment& base )
{
	Clear();
	base.CopyTo( this );
	return *this;
}


void CTiXmlComment::Print( FILE* cfile, int depth ) const
{
	assert( cfile );
	for ( int i=0; i<depth; i++ )
	{
		fprintf( cfile,  "    " );
	}
	fprintf( cfile, "<!--%s-->", value.c_str() );
}


void CTiXmlComment::CopyTo( CTiXmlComment* target ) const
{
	CTiXmlNode::CopyTo( target );
}


bool CTiXmlComment::Accept( CTiXmlVisitor* visitor ) const
{
	return visitor->Visit( *this );
}


CTiXmlNode* CTiXmlComment::Clone() const
{
	CTiXmlComment* clone = new CTiXmlComment();

	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


void CTiXmlText::Print( FILE* cfile, int depth ) const
{
	assert( cfile );
	if ( cdata )
	{
		int i;
		fprintf( cfile, "\n" );
		for ( i=0; i<depth; i++ ) {
			fprintf( cfile, "    " );
		}
		fprintf( cfile, "<![CDATA[%s]]>\n", value.c_str() );	// unformatted output
	}
	else
	{
		TIXML_STRING buffer;
		EncodeString( value, &buffer );
		fprintf( cfile, "%s", buffer.c_str() );
	}
}


void CTiXmlText::CopyTo( CTiXmlText* target ) const
{
	CTiXmlNode::CopyTo( target );
	target->cdata = cdata;
}


bool CTiXmlText::Accept( CTiXmlVisitor* visitor ) const
{
	return visitor->Visit( *this );
}


CTiXmlNode* CTiXmlText::Clone() const
{	
	CTiXmlText* clone = 0;
	clone = new CTiXmlText( "" );

	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


CTiXmlDeclaration::CTiXmlDeclaration( const char * _version,
									const char * _encoding,
									const char * _standalone )
	: CTiXmlNode( CTiXmlNode::TINYXML_DECLARATION )
{
	version = _version;
	encoding = _encoding;
	standalone = _standalone;
}


#ifdef TIXML_USE_STL
CTiXmlDeclaration::CTiXmlDeclaration(	const std::string& _version,
									const std::string& _encoding,
									const std::string& _standalone )
	: CTiXmlNode( CTiXmlNode::TINYXML_DECLARATION )
{
	version = _version;
	encoding = _encoding;
	standalone = _standalone;
}
#endif


CTiXmlDeclaration::CTiXmlDeclaration( const CTiXmlDeclaration& copy )
	: CTiXmlNode( CTiXmlNode::TINYXML_DECLARATION )
{
	copy.CopyTo( this );	
}


CTiXmlDeclaration& CTiXmlDeclaration::operator=( const CTiXmlDeclaration& copy )
{
	Clear();
	copy.CopyTo( this );
	return *this;
}


void CTiXmlDeclaration::Print( FILE* cfile, int /*depth*/, TIXML_STRING* str ) const
{
	if ( cfile ) fprintf( cfile, "<?xml " );
	if ( str )	 (*str) += "<?xml ";

	if ( !version.empty() ) {
		if ( cfile ) fprintf (cfile, "version=\"%s\" ", version.c_str ());
		if ( str ) { (*str) += "version=\""; (*str) += version; (*str) += "\" "; }
	}
	if ( !encoding.empty() ) {
		if ( cfile ) fprintf (cfile, "encoding=\"%s\" ", encoding.c_str ());
		if ( str ) { (*str) += "encoding=\""; (*str) += encoding; (*str) += "\" "; }
	}
	if ( !standalone.empty() ) {
		if ( cfile ) fprintf (cfile, "standalone=\"%s\" ", standalone.c_str ());
		if ( str ) { (*str) += "standalone=\""; (*str) += standalone; (*str) += "\" "; }
	}
	if ( cfile ) fprintf( cfile, "?>" );
	if ( str )	 (*str) += "?>";
}


void CTiXmlDeclaration::CopyTo( CTiXmlDeclaration* target ) const
{
	CTiXmlNode::CopyTo( target );

	target->version = version;
	target->encoding = encoding;
	target->standalone = standalone;
}


bool CTiXmlDeclaration::Accept( CTiXmlVisitor* visitor ) const
{
	return visitor->Visit( *this );
}


CTiXmlNode* CTiXmlDeclaration::Clone() const
{	
	CTiXmlDeclaration* clone = new CTiXmlDeclaration();

	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


void CTiXmlUnknown::Print( FILE* cfile, int depth ) const
{
	for ( int i=0; i<depth; i++ )
		fprintf( cfile, "    " );
	fprintf( cfile, "<%s>", value.c_str() );
}


void CTiXmlUnknown::CopyTo( CTiXmlUnknown* target ) const
{
	CTiXmlNode::CopyTo( target );
}


bool CTiXmlUnknown::Accept( CTiXmlVisitor* visitor ) const
{
	return visitor->Visit( *this );
}


CTiXmlNode* CTiXmlUnknown::Clone() const
{
	CTiXmlUnknown* clone = new CTiXmlUnknown();

	if ( !clone )
		return 0;

	CopyTo( clone );
	return clone;
}


CTiXmlAttributeSet::CTiXmlAttributeSet()
{
	sentinel.next = &sentinel;
	sentinel.prev = &sentinel;
}


CTiXmlAttributeSet::~CTiXmlAttributeSet()
{
	assert( sentinel.next == &sentinel );
	assert( sentinel.prev == &sentinel );
}


void CTiXmlAttributeSet::Add( CTiXmlAttribute* addMe )
{
    #ifdef TIXML_USE_STL
	assert( !Find( TIXML_STRING( addMe->Name() ) ) );	// Shouldn't be multiply adding to the set.
	#else
	assert( !Find( addMe->Name() ) );	// Shouldn't be multiply adding to the set.
	#endif

	addMe->next = &sentinel;
	addMe->prev = sentinel.prev;

	sentinel.prev->next = addMe;
	sentinel.prev      = addMe;
}

void CTiXmlAttributeSet::Remove( CTiXmlAttribute* removeMe )
{
	CTiXmlAttribute* node;

	for( node = sentinel.next; node != &sentinel; node = node->next )
	{
		if ( node == removeMe )
		{
			node->prev->next = node->next;
			node->next->prev = node->prev;
			node->next = 0;
			node->prev = 0;
			return;
		}
	}
	assert( 0 );		// we tried to remove a non-linked attribute.
}


#ifdef TIXML_USE_STL
CTiXmlAttribute* CTiXmlAttributeSet::Find( const std::string& name ) const
{
	for( CTiXmlAttribute* node = sentinel.next; node != &sentinel; node = node->next )
	{
		if ( node->name == name )
			return node;
	}
	return 0;
}

CTiXmlAttribute* CTiXmlAttributeSet::FindOrCreate( const std::string& _name )
{
	CTiXmlAttribute* attrib = Find( _name );
	if ( !attrib ) {
		attrib = new CTiXmlAttribute();
		Add( attrib );
		attrib->SetName( _name );
	}
	return attrib;
}
#endif


CTiXmlAttribute* CTiXmlAttributeSet::Find( const char* name ) const
{
	for( CTiXmlAttribute* node = sentinel.next; node != &sentinel; node = node->next )
	{
		if ( strcmp( node->name.c_str(), name ) == 0 )
			return node;
	}
	return 0;
}


CTiXmlAttribute* CTiXmlAttributeSet::FindOrCreate( const char* _name )
{
	CTiXmlAttribute* attrib = Find( _name );
	if ( !attrib ) {
		attrib = new CTiXmlAttribute();
		Add( attrib );
		attrib->SetName( _name );
	}
	return attrib;
}


#ifdef TIXML_USE_STL	
std::istream& operator>> (std::istream & in, CTiXmlNode & base)
{
	TIXML_STRING tag;
	tag.reserve( 8 * 1000 );
	base.StreamIn( &in, &tag );

	base.Parse( tag.c_str(), 0, TIXML_DEFAULT_ENCODING );
	return in;
}
#endif


#ifdef TIXML_USE_STL	
std::ostream& operator<< (std::ostream & out, const CTiXmlNode & base)
{
	CTiXmlPrinter printer;
	printer.SetStreamPrinting();
	base.Accept( &printer );
	out << printer.Str();

	return out;
}


std::string& operator<< (std::string& out, const CTiXmlNode& base )
{
	CTiXmlPrinter printer;
	printer.SetStreamPrinting();
	base.Accept( &printer );
	out.append( printer.Str() );

	return out;
}
#endif


CTiXmlHandle CTiXmlHandle::FirstChild() const
{
	if ( node )
	{
		CTiXmlNode* child = node->FirstChild();
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::FirstChild( const char * value ) const
{
	if ( node )
	{
		CTiXmlNode* child = node->FirstChild( value );
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::FirstChildElement() const
{
	if ( node )
	{
		CTiXmlElement* child = node->FirstChildElement();
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::FirstChildElement( const char * value ) const
{
	if ( node )
	{
		CTiXmlElement* child = node->FirstChildElement( value );
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::Child( int count ) const
{
	if ( node )
	{
		int i;
		CTiXmlNode* child = node->FirstChild();
		for (	i=0;
				child && i<count;
				child = child->NextSibling(), ++i )
		{
			// nothing
		}
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::Child( const char* value, int count ) const
{
	if ( node )
	{
		int i;
		CTiXmlNode* child = node->FirstChild( value );
		for (	i=0;
				child && i<count;
				child = child->NextSibling( value ), ++i )
		{
			// nothing
		}
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::ChildElement( int count ) const
{
	if ( node )
	{
		int i;
		CTiXmlElement* child = node->FirstChildElement();
		for (	i=0;
				child && i<count;
				child = child->NextSiblingElement(), ++i )
		{
			// nothing
		}
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


CTiXmlHandle CTiXmlHandle::ChildElement( const char* value, int count ) const
{
	if ( node )
	{
		int i;
		CTiXmlElement* child = node->FirstChildElement( value );
		for (	i=0;
				child && i<count;
				child = child->NextSiblingElement( value ), ++i )
		{
			// nothing
		}
		if ( child )
			return CTiXmlHandle( child );
	}
	return CTiXmlHandle( 0 );
}


bool CTiXmlPrinter::VisitEnter( const CTiXmlDocument& )
{
	return true;
}

bool CTiXmlPrinter::VisitExit( const CTiXmlDocument& )
{
	return true;
}

bool CTiXmlPrinter::VisitEnter( const CTiXmlElement& element, const CTiXmlAttribute* firstAttribute )
{
	DoIndent();
	buffer += "<";
	buffer += element.Value();

	for( const CTiXmlAttribute* attrib = firstAttribute; attrib; attrib = attrib->Next() )
	{
		buffer += " ";
		attrib->Print( 0, 0, &buffer );
	}

	if ( !element.FirstChild() ) 
	{
		buffer += " />";
		DoLineBreak();
	}
	else 
	{
		buffer += ">";
		if (    element.FirstChild()->ToText()
			  && element.LastChild() == element.FirstChild()
			  && element.FirstChild()->ToText()->CDATA() == false )
		{
			simpleTextPrint = true;
			// no DoLineBreak()!
		}
		else
		{
			DoLineBreak();
		}
	}
	++depth;	
	return true;
}


bool CTiXmlPrinter::VisitExit( const CTiXmlElement& element )
{
	--depth;
	if ( !element.FirstChild() ) 
	{
		// nothing.
	}
	else 
	{
		if ( simpleTextPrint )
		{
			simpleTextPrint = false;
		}
		else
		{
			DoIndent();
		}
		buffer += "</";
		buffer += element.Value();
		buffer += ">";
		DoLineBreak();
	}
	return true;
}


bool CTiXmlPrinter::Visit( const CTiXmlText& text )
{
	if ( text.CDATA() )
	{
		DoIndent();
		buffer += "<![CDATA[";
		buffer += text.Value();
		buffer += "]]>";
		DoLineBreak();
	}
	else if ( simpleTextPrint )
	{
		TIXML_STRING str;
		CTiXmlBase::EncodeString( text.ValueTStr(), &str );
		buffer += str;
	}
	else
	{
		DoIndent();
		TIXML_STRING str;
		CTiXmlBase::EncodeString( text.ValueTStr(), &str );
		buffer += str;
		DoLineBreak();
	}
	return true;
}


bool CTiXmlPrinter::Visit( const CTiXmlDeclaration& declaration )
{
	DoIndent();
	declaration.Print( 0, 0, &buffer );
	DoLineBreak();
	return true;
}


bool CTiXmlPrinter::Visit( const CTiXmlComment& comment )
{
	DoIndent();
	buffer += "<!--";
	buffer += comment.Value();
	buffer += "-->";
	DoLineBreak();
	return true;
}


bool CTiXmlPrinter::Visit( const CTiXmlUnknown& unknown )
{
	DoIndent();
	buffer += "<";
	buffer += unknown.Value();
	buffer += ">";
	DoLineBreak();
	return true;
}

