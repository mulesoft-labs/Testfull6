/*
Copyright (c) 2008 salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/*  
	This class implements a small portion of the wc3 xml dom model.  
	Generally useful for simple XML return objects. Note: stores namespaces 
	in the attributes map for now. No node typing done at this time  
	
	can parse into DOM trees the XML return objects from Google, Amazon and others.
	large parse trees will consume suprising amounts of memory
 */
public class XMLDom {
	// Constructor 
	public XMLDom(string str) { parseFromString(str); }	
	public XMLDom(          ) { }
	public void parseFromString(string str) {   
		XmlStreamReader reader = new XmlStreamReader(str);
		reader.setCoalescing(true);
		parseXmlReader (root , reader);	
	} 
	 
	// debugging assistance
	public void dumpAll() { root.dumpAll(); } 
	public void dumpList(Element[] l) { for(Element e:l) e.dump(); }
	
	// given a parent node and a stream reader, populates the tree below here (recursive)
	void parseXmlReader( Element parent, XmlStreamReader reader ) {
		try {
		while(reader.hasNext()) {
		
			if (reader.getEventType() == XmlTag.START_ELEMENT) {
				
				string nodeName = reader.getLocalName();
				string pre = reader.getPrefix();
				if ( pre != null && pre != ''  ) {
					//system.debug( reader.getPrefix() ); 
					nodeName = reader.getPrefix() + ':' + nodeName;
				}
				Element child = new Element( nodeName  );
				
				// add all attributes from this element
				for (integer i=0; i<reader.getAttributeCount(); i++) { 
					child.attributes.put(	reader.getAttributeLocalName(i), reader.getAttributeValueAt(i) );
				}
				// add namespace info to each node/element ( for now storing on attributes map)
				for (integer j=0; j<reader.getNamespaceCount(); j++) { 
					string prefix = 'xmlns'; 
					if (reader.getnamespaceprefix(j)!=null)
						 prefix = reader.getnamespaceprefix(j);	
					child.attributes.put( prefix , reader.getnamespaceuriat(j) );
				} 
				
				parent.appendChild(child); // add the new element to current parent
				reader.next();
				
				parseXmlReader(child, reader) ; // recurse
				
			} else if (reader.getEventType() == XmlTag.END_ELEMENT) {	
				reader.next();
				return;	
				
			} else if (reader.getEventType() == XmlTag.CHARACTERS) {
				if ( ! reader.isWhitespace()) { 
					parent.nodeValue += reader.getText();  // add text to current element
				}
				reader.next();
				
			}
			else { 
				reader.next(); 
			} 	
		}
		} catch(Exception e) { // ParseError if we get a truncated response, allow it
			system.debug(e);
		}
	}	
	
	// access nodes in the tree using these getters
	public List<Element> getElementsByTagName(string nam) {
		return root.getElementsByTagName(nam); 
	}

	public Element 		 getElementByTagName(string nam) {
		List<Element> r = root.getElementsByTagName(nam);
		if (r.size() == 0) return null; 
		return r[0];
	}

	// utility dom functions
	public Element ownerDocument() { return root; }

	// everything in the dom is found as childNodes under this root element
	public Element root = new Element('#document');
	public integer debug =0;
		// dump out the element tree
	public String toXmlString() { return root.toXmlString(); }
	
/* 
 *  Element  class definition
 
	This following class implements a small portion of the wc3 xml dom model.  
	Generally useful for simple XML return objects. 
	
	for a properties and methods complete list see: 
	http://www.w3schools.com/dom/dom_node.asp
	
	For simplicity, Nodes are the same as Elements in this class.
	Nodes have text directly in them, rather than a seperate text node child
	The following describes the implemented portion, some w3c properties are now methods.	
	
	Property 	Description 	
	 
	nodeName 	Returns the name of a node, depending on its type 
	nodeValue 	Sets or returns the value of a node, depending on its type 
	childNodes 	Returns a NodeList of child nodes for a node
	parentNode 	Returns the parent node of a node 
	attributes  	Returns a NamedNodeMap of attributes for the element, also contains name space entries
	
	getElementByTagName() Returns list of elements matching tag name (document and element)
	firstChild() 	Returns the first child of a node 
	removeChild() 	Removes a child node 
	appendChild() 	Adds a new child node to the end of the list of children of a node 
	getAttribute() 	Returns the value of an attribute 
	hasChildNodes() 	Returns whether the element has any child nodes 
	isEqualNode() 	Checks if two nodes are equal 
	textContent() 	returns the textual content of a node 
	cloneNode() 	Clones a node 
	hasAttributes() 	Returns whether the element has any attributes 
	isSameNode() 	Checks if two nodes are the same node 
	ownerDocument() 	Returns the root element (document object) for a node 
	
	
	*** NOT Implemented at this time *** 
	
	lastChild() 	Returns the last child of a node 
	nodeType 	Returns the type of a node , all nodes are the same type currently
	baseURI 	Returns the absolute base URI of a node 
	localName 	Returns the local part of the name of a node 
	namespaceURI 	Returns the namespace URI of a node 
	nextSibling 	Returns the node immediately following a node 
	insertBefore() 	Inserts a new child node before an existing child node 
	replaceChild() 	Replaces a child node 

 */
 public class Element {
	//	Element(Element p, string n) {		parentNode = p;			nodeName = n;		} 
	public Element(string n) {	nodeName = n; } 
	public Element() {	}
	
	public string getAttribute(string name) { 
		return attributes.get(name); 
	}
	public void appendChild(Element e) {
		e.ParentNode = this; 
		this.childNodes.add(e);		
	}
	public void removeChild(Element e) {
		Element p = e.parentNode;
		List<Element> kids = new List<Element> {};
		for( Element ee: e.parentNode.childNodes) {
			if (ee != e) 
				kids.add(ee); 
		}
		p.childNodes = kids;
	}
	// traverse below this node, returning all matching nodes by name
	public List<Element> getElementsByTagName(string nam) {	
		List<Element> ret = new List<Element>{};
		if (nam == this.nodeName) ret.add(this);
		for (Element c: this.childNodes) { 
			ret.addAll( c.getElementsByTagName(nam) ); // decend tree
		}
		return ret;
	}
	// like above, but just returns the first one that matches	
	public Element 		 getElementByTagName(string nam) {
		List<Element> r = 	getElementsByTagName(nam);
		if (r.size() == 0) return null; 
		return r[0];
	}
	// first one that matches, just return the nodeValue
	public string getValue(string nam) {
		Element e = getElementByTagName(nam); 
		return (e==null?null:e.nodeValue); 
	}

	// some debugging help	
	public void dump() { dump('');}
	public void dump(string pre) { // just current node
		system.debug( pre + ' ' +this.nodeName + '->' + this.nodeValue + ' ' + this.attributes );  
	}
	public void dumpAll() { dumpAll('');	}
	public void dumpAll(string pre) { // node and all children
		system.debug( pre + this.nodeName + '->' + this.nodeValue + ' ' + this.attributes );  
		for (Element c: this.childNodes) { 
			c.dumpAll(pre+'   '); 
		}
	}
	public string toXmlString() {
		string ret = '<' + this.nodeName + ' ';
		for (  string a : attributes.keySet() ) {
			ret += a + '=\'' + attributes.get(a) + '\' ' ;
		}
		ret += '>';
		if (nodeValue == '' ) ret += '\n';
		for (Element c: this.childNodes) {  
			ret += c.toXmlString() ;//+ '\n'; 
		}	
		if (nodeValue != '' ) 
			ret += nodeValue;
		//else ret += '\n';
		return ret + '</' + this.nodeName + '>\n'; 
	}
	/* 
	 * experimental path based patern matching, sort of like xpath, 
	 * but simpler, just matches a path() string with the pattern supplied
	 */
	 // * /bookstore/book/.*
	 // /.*book/.*
	 // /.*/book$
	public List<Element> getElementsByPath(string path) {	
		List<Element> ret = new List<Element>{};
		// system.debug( path + ' ' + this.path());
		if ( Pattern.matches(path, this.path()) ) ret.add(this);
		for (Element c: this.childNodes) ret.addAll( c.getElementsByPath(path) );
		return ret;
	}	 
	public string path() { 
		Element t = this;
		string ret = t.nodeName; 
		while (t.parentNode != null && t.parentNode.nodeName != '#document') { 
			t = t.parentNode;
			ret = t.nodeName + '/'+ret;
		}
		return '/'+ret;
	}
	
	// utility methods
	public Element firstChild() { 
		if ( this.childNodes.size() == 0 ) return null; 
		return this.childNodes[0]; 
	}
	public string textContent() { return this.nodeValue; } 
	public boolean hasChildNodes() { return childNodes.size()>0; }
	public boolean isEqualNode(Element comp) { return this.nodeName == comp.nodeName; } 
	public Element cloneNode() { return this.clone(); } 
	public boolean hasAttributes() { return ! attributes.isEmpty(); } 
	public boolean isSameNode(Element comp) { return this === comp; }		
	public Element ownerDocument() { 
		Element ret = this; 
		while( ret.parentNode != null) { ret = ret.parentNode; } 			
		return ret; 
	} 
	
	// properties
	public Element parentNode = null; // only root has a null parent 
	public string nodeName = ''; 
	public string nodeValue = ''; 
	public List<Element> childNodes = new List<Element>();
	public map<String,String> attributes = new map<String,String>();
	
 
 }
 	public static testmethod void test0() { xmldom d;  
 		// truncated xml
 		d = new xmldom('<books><book author="Manoj" date="1999" >My Book</book><book author="Ron" >Your '); 
        system.assert( d.root != null);
        List<xmldom.Element> keys  = d.getElementsByTagName('bad');
        system.assert( d.toXmlString() != null );
        XMLdom.Element p = d.root;
        p.removeChild(p.firstChild());
        p = d.getElementByTagName('bad');
 		system.assert( p == null );
 	} 
  	
  	public static testmethod void test1() { 
        xmldom d;        
        d = new xmldom('<book  author="Manoj" >My Book</book>');
        d.dumpAll(); 
        XMLdom.Element e = d.getElementsByTagName('book')[0];
        system.assert( e.getAttribute('author') =='Manoj' ); 
        
        d = new xmldom(); d.parseFromString('<book  author="Manoj" >My Book</book>');
        d.dumpAll(); 
         
        d = new xmldom('<books><book>My Book</book></books>');
        d.dumpAll(); 
        //system.debug( d.getElements() ); 
        system.debug ( d.getElementsByTagName('book')[0].nodeValue );
        system.assert ( d.getElementsByTagName('book')[0].nodeValue == 'My Book' );
        
        d = new xmldom('<books><book author="Manoj" date="1999" >My Book</book><book author="Ron" >Your Book</book></books>'); 
        d.dumpAll();
        system.debug ( d.getElementsByTagName('book') );
        for(XMLdom.Element ee:d.getElementsByTagName('book')) { system.debug( 'Author is ' + ee.getAttribute('author')); }
        
        string testErrorResponse = 
         '<?xml version="1.0" encoding="UTF-8"?>'+ 
         '<Error><Code>NoSuchKey</Code><Message>The specified key does not exist.</Message><Key>test-key</Key><RequestId>49DDFSFDFSDfBD</RequestId>'+
         '<HostId>PB4hNZsosdfz</HostId></Error>';
    
        d = new xmldom(testErrorResponse); 
        d.root.dumpAll();
        
        // uses namespaces
         string testACLResponse = 
     '<?xml version="1.0" encoding="UTF-8"?>'+ 
     '<AccessControlPolicy xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>owner_id</ID><DisplayName>vdddddds</DisplayName></Owner>'+
     '<AccessControlList><Grant><Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser" foo="bar" ><ID>owner_id</ID>'+
     '<DisplayName>vne</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>';
        d = new xmldom(testACLResponse); 
        d.dumpAll(); 
        system.debug ('has child '+ d.root.hasChildNodes()) ; 
        
        system.assert(  d.root.isEqualNode(d.root) ,' is equal node');
        system.assert( d.root.textContent() == '' );
         
        d.getElementsByTagName('Grantee')[0].dump(); 
        
        system.assert( d.getElementsByTagName('Grantee')[0].hasAttributes() );
        
            
        
    }
    

    public static testmethod void test3() { 
         string testNotification = 
         '<?xml version="1.0" encoding="UTF-8"?>' +
            '<bookstore><book><title lang="eng">Harry Potter</title><price>29.99</price>' +
            '</book><book><title lang="eng">Learning XML</title><price>39.95</price></book></bookstore>';

        xmldom d;
        d = new xmldom(testNotification);  
        list<xmldom.element> tmp ; 

        tmp =  d.root.getElementsByTagName('book');  // matching by name
        system.assertEquals( 2, tmp.size() ); 
        d.dumpList( tmp );
        system.debug( d.root.toXmlString() ) ;
        XMLdom.Element a = d.ownerDocument();
        XMLdom.Element f = a.firstChild();
        XMLdom.Element c = f.ownerDocument(); 
        system.assert( a.isSameNode( c ) );
        XMLdom.Element b = a.cloneNode();
        system.assert( ! a.isSameNode(f) ); 
        
        a = new XMLdom.Element(); 
        system.assertEquals( a.firstChild(), null, ' must be null' );
        
        system.assertEquals( a.getElementByTagName('bad'), null);       
     }

    public static testmethod void test4() { 
    
        String feed =   '<?xml version="1.0" encoding="UTF-8"?>' +
            '<bookstore><book><title lang="eng">Harry Potter</title><entry>v</entry><price>29.99</price>' +
            '</book><book><title lang="eng">Learning XML</title><price>39.95</price></book></bookstore>';

        xmldom d = new xmldom(feed);  
        list<xmldom.element> tmp ;  
        d.dumpAll();
        XMLdom.Element e2 = d.ownerDocument().getElementByTagName('book');
        e2.dumpAll();   
        system.assertEquals('book', e2.nodeName );         
        system.assertEquals( e2.getValue('title'), 'Harry Potter');
        
        
        XMLdom.Element[] el = d.ownerDocument().getElementsByTagName('link');
        for(XMLdom.Element ee:el) { 
            system.debug( ee.path() );
            ee.dump(); 
        }
        
        e2 = d.ownerDocument().getElementByTagName('entry');
        System.assertEquals('v', e2.nodeValue);
        
        e2 = d.ownerDocument().getElementsByPath('/bookstore/book/title')[0];
        e2.dump();
        
        /* 
         * experimental path based patern matching, sort of like xpath, 
         * but simpler, just matches a path() string with 
         * the pattern supplied
         */
        // children of entry
        el= d.ownerDocument().getElementsByPath('/bookstore/book/.*');
        d.dumpList(el);
        system.assertEquals( 5, el.size() );
        
        // just the entry node
        el= d.ownerDocument().getElementsByPath('/bookstore/book');
        system.assertEquals( 2, el.size() );
        
        // entry and children
        el= d.ownerDocument().getElementsByPath('/.*/entry.*');
        system.assertEquals( 1, el.size() );
        
    }        

    /* google data elements have a prefix that is parsed differently, make sure we can 
     * deliver that intact 
     */
    public static testmethod void testWithPrefix() { 
        
        String feed = '<?xml version=\'1.0\' encoding=\'UTF-8\'?><feed xmlns=\'http://www.w3.org/2005/Atom\' xmlns:openSearch=\'http://a9.com/-/spec/opensearchrss/1.0/\' xmlns:gCal=\'http://schemas.google.com/gCal/2005\' xmlns:gd=\'http://schemas.google.com/g/2005\'><id>http://www.google.com/calendar/feeds/default/allcalendars/full</id><updated>2008-06-11T17:28:38.768Z</updated><title type=\'text\'>Nick Tran\'s Calendar List</title><link rel=\'http://schemas.google.com/g/2005#feed\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><link rel=\'http://schemas.google.com/g/2005#post\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><link rel=\'self\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><author><name>Nick Tran</name><email>sforcedemos@gmail.com</email></author><generator version=\'1.0\' uri=\'http://www.google.com/calendar\'>Google Calendar</generator><openSearch:startIndex>1</openSearch:startIndex>' + 
        '<entry><id>http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com</id><published>2008-06-11T17:28:38.789Z</published><updated>2008-06-11T14:24:25.000Z</updated><title type=\'text\'>force.com Team Demo</title><link rel=\'alternate\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/sforcedemos%40gmail.com/private/full\'/><link rel=\'http://schemas.google.com/acl/2007#accessControlList\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/sforcedemos%40gmail.com/acl/full\'/><link rel=\'self\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com\'/><link rel=\'edit\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com\'/><author><name>Nick Tran</name><email>sforcedemos@gmail.com</email></author><gCal:timezone value=\'America/Los_Angeles\'/><gCal:hidden value=\'false\'/>'+ 
        '<gCal:color value=\'#2952A3\'/><gCal:selected value=\'true\'/><gCal:accesslevel value=\'owner\'/></entry></feed>';
        
        xmldom d = new xmldom(feed);  
        list<xmldom.element> tmp ;  
        d.dumpAll();
        XMLdom.Element e2 = d.ownerDocument().getElementByTagName('entry');
        e2.dumpAll();   
        system.assert( d.getElementByTagName('gCal:selected') != null , ' missing gcal');
    }
}