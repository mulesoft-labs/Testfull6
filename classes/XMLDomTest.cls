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
public class XMLDomTest { 
    
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
        XMLdom.Element ee  = new xmldom.Element(); 
        
        
        string testListBucketResponse = 
             '<?xml version="1.0" encoding="UTF-8"?>'+ 
            '<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Name>12gkzwnp21m8nw02-test-bucket</Name><Prefix>'+
            '</Prefix><Marker></Marker><MaxKeys>1000</MaxKeys><IsTruncated>false</IsTruncated><Contents><Key>/apex/adnDevSignup</Key>'+
            '<LastModified>2008-01-27T21:13:58.000Z</LastModified><ETag>&quot;630581ddc40fa0a3b7e521c67962baba&quot;</ETag><Size>27411</Size>'+
            '<Owner><ID>173ea00b3418d9a715d5f5a0d85290c3be11135ecf9a085504a4b1bbb6ea1</ID><DisplayName>vnehess</DisplayName></Owner>'+
            '<StorageClass>STANDARD</StorageClass></Contents><Contents><Key>apex/adnDevSignup</Key><LastModified>2008-01-31T09:50:41.000Z</LastModified>'+
            '<ETag>&quot;2d9ab36295e58d32db358aae0195c164&quot;</ETag><Size>27410</Size><Owner><ID>owner_id</ID><DisplayName>vnehess</DisplayName></Owner>'+
            '<StorageClass>STANDARD</StorageClass></Contents><Contents><Key>apex/adnRoot</Key><LastModified>2008-01-31T09:50:40.000Z</LastModified>'+
            '<ETag>&quot;f956a9612c95c206f3208f023d1edefb&quot;</ETag><Size>20036</Size><Owner><ID>owner_id</ID><DisplayName>vnehess</DisplayName></Owner>'+
            '<StorageClass>STANDARD</StorageClass></Contents><Contents><Key>test-key-public</Key><LastModified>2008-02-02T04:02:59.000Z</LastModified>'+
            '<ETag>&quot;12f3e46f80c24c997c4304953edc3612&quot;</ETag><Size>32</Size><Owner><ID>173ea00891b39a715d5f5a0d85290c3be11135ecf9a085504a4b1bbb6ea1</ID>'+
            '<DisplayName>vnehess</DisplayName></Owner><StorageClass>STANDARD</StorageClass></Contents><Contents><Key>test-two</Key>'+
            '<LastModified>2008-02-02T00:40:29.000Z</LastModified><ETag>&quot;327b6f07435811239bc47e1544353273&quot;</ETag><Size>7</Size>'+
            '<Owner><ID>173</ID><DisplayName>vnehess</DisplayName></Owner><StorageClass>STANDARD</StorageClass></Contents></ListBucketResult>';
        d = new xmldom(testListBucketResponse); 
        d.dumpAll();
        List<xmldom.Element> keys = d.getElementsByTagName('Key');
         
        //system.debug ( keys ); 
        for(XMLdom.Element e2:keys) { system.debug( 'Key is '  + e2.nodeValue ); }
        
        integer count= keys.size();
        system.assert(count>1);
        system.debug(count);
        
        XMLdom.Element p = keys[0].parentNode;
        p.removeChild(p.firstChild());
        
        keys = d.getElementsByTagName('Key');
        system.assert(keys.size() == count-1);
        
        keys = d.root.getElementsByTagName('Key');
        for(XMLdom.Element e2: keys ) { system.debug( 'Key is ' + e2.nodeValue ); 
         e2.dump(); 
         }
        count= keys.size();
        system.assert(count>1);
        system.debug(count);
        
        string testErrorResponse = 
         '<?xml version="1.0" encoding="UTF-8"?>'+ 
         '<Error><Code>NoSuchKey</Code><Message>The specified key does not exist.</Message><Key>test-key</Key><RequestId>49D135F2DD55EBD</RequestId>'+
         '<HostId>PB4hNZso0IhimzQOoVMMoPOt0BRE3QRHcNp5Ua98tOl9hv0e677fmEA0dhr4oz</HostId></Error>';
    
        d = new xmldom(testErrorResponse); 
        d.root.dumpAll();
        
        // uses namespaces
         string testACLResponse = 
     '<?xml version="1.0" encoding="UTF-8"?>'+ 
     '<AccessControlPolicy xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>owner_id</ID><DisplayName>vnehess</DisplayName></Owner>'+
     '<AccessControlList><Grant><Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser" foo="bar" ><ID>owner_id</ID>'+
     '<DisplayName>vnehess</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>';
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

    public static testmethod void testRSS() { 
        
        String feed = '<?xml version="1.0" encoding="UTF-8"?>'+
            '<feed xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" version="0.3">'+
            '<title>Force.com Blog</title>' +
            '<link rel="alternate" type="text/html" href="http://blog.sforce.com/sforce/" />' +
            '<id>tag:typepad.com,2003:weblog-125619</id>' +
            '<link rel="service.post" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619" title="Force.com Blog" />' +
            '<modified>2008-01-23T20:27:30Z</modified>' +
            '<tagline></tagline>' +
            '<generator url="http://www.typepad.com/">TypePad</generator>' +
            '<info type="application/xhtml+xml">' +
            '<div xmlns="http://www.w3.org/1999/xhtml">This is an Atom formatted XML site feed. It is intended to be viewed in a Newsreader or syndicated to another site. Please visit <a href="http://blog.sforce.com/sforce/">Force.com Blog</a> for more info.</div>' +
            '</info><entry>' +
            '<title>Tour de Force Global Kickoff - it\'s a wrap!</title>' +
            '<link rel="alternate" type="text/html" href="http://feeds.feedburner.com/~r/SforceBlog/~3/221839184/tour-de-force-g.html" />' +
            '<link rel="service.edit" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619/entry_id=44564390" title="Tour de Force Global Kickoff - it\'s a wrap!" />' +
            '<id>tag:typepad.com,2003:post-44564390</id>' +
            '<issued>2008-01-23T12:27:30-08:00</issued>' +
            '<modified>2008-01-23T20:27:30Z</modified>' +
            '<created>2008-01-23T20:27:30Z</created>' +
            '<summary>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - we\'re delighted that you were able help us launch the Tour de Force roadshow to unleash the Force.com platform around...</summary>' +
            '<author><name>Mark Trang</name></author>' +
            '<content type="application/xhtml+xml" xml:lang="en-US" xml:base="http://blog.sforce.com/sforce/"><div xmlns="http://www.w3.org/1999/xhtml">'+
            '<p>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - </p></div></content>'+
            '<feedburner:origLink>http://blog.sforce.com/sforce/2008/01/tour-de-force-g.html</feedburner:origLink></entry></feed>';
        xmldom d = new xmldom(feed);  
        list<xmldom.element> tmp ;  
        d.dumpAll();
        XMLdom.Element e2 = d.ownerDocument().getElementByTagName('entry');
        e2.dumpAll();   
        system.assertEquals('entry', e2.nodeName );         
        system.assertEquals( e2.getValue('title'), 'Tour de Force Global Kickoff - it\'s a wrap!');
        
        
        XMLdom.Element[] el = d.ownerDocument().getElementsByTagName('link');
        for(XMLdom.Element ee:el) { 
            system.debug( ee.path() );
            ee.dump(); 
        }
        
        e2 = d.ownerDocument().getElementByTagName('name');
        System.assertEquals('Mark Trang', e2.nodeValue);
        
        e2 = d.ownerDocument().getElementsByPath('/feed/title')[0];
        e2.dump();
        
        /* 
         * experimental path based patern matching, sort of like xpath, 
         * but simpler, just matches a path() string with 
         * the pattern supplied
         */
        // children of entry
        el= d.ownerDocument().getElementsByPath('/feed/entry/.*');
        d.dumpList(el);
        system.assertEquals( 14, el.size() );
        
        // just the entry node
        el= d.ownerDocument().getElementsByPath('/feed/entry');
        system.assertEquals( 1, el.size() );
        
        // entry and children
        el= d.ownerDocument().getElementsByPath('/.*/entry.*');
        system.assertEquals( 15, el.size() );
    }        

    /* google data elements have a prefix that is parsed differently, make sure we can 
     * deliver that intact 
     */
    public static testmethod void testWithPrefix() { 
        
        String feed = '<?xml version=\'1.0\' encoding=\'UTF-8\'?><feed xmlns=\'http://www.w3.org/2005/Atom\' xmlns:openSearch=\'http://a9.com/-/spec/opensearchrss/1.0/\' xmlns:gCal=\'http://schemas.google.com/gCal/2005\' xmlns:gd=\'http://schemas.google.com/g/2005\'><id>http://www.google.com/calendar/feeds/default/allcalendars/full</id><updated>2008-06-11T17:28:38.768Z</updated><title type=\'text\'>Nick Tran\'s Calendar List</title><link rel=\'http://schemas.google.com/g/2005#feed\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><link rel=\'http://schemas.google.com/g/2005#post\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><link rel=\'self\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full\'/><author><name>Nick Tran</name><email>sforcedemos@gmail.com</email></author><generator version=\'1.0\' uri=\'http://www.google.com/calendar\'>Google Calendar</generator><openSearch:startIndex>1</openSearch:startIndex>' + '<entry><id>http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com</id><published>2008-06-11T17:28:38.789Z</published><updated>2008-06-11T14:24:25.000Z</updated><title type=\'text\'>force.com Team Demo</title><link rel=\'alternate\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/sforcedemos%40gmail.com/private/full\'/><link rel=\'http://schemas.google.com/acl/2007#accessControlList\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/sforcedemos%40gmail.com/acl/full\'/><link rel=\'self\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com\'/><link rel=\'edit\' type=\'application/atom+xml\' href=\'http://www.google.com/calendar/feeds/default/allcalendars/full/sforcedemos%40gmail.com\'/><author><name>Nick Tran</name><email>sforcedemos@gmail.com</email></author><gCal:timezone value=\'America/Los_Angeles\'/><gCal:hidden value=\'false\'/>'+ '<gCal:color value=\'#2952A3\'/><gCal:selected value=\'true\'/><gCal:accesslevel value=\'owner\'/></entry></feed>';
        
        xmldom d = new xmldom(feed);  
        list<xmldom.element> tmp ;  
        d.dumpAll();
        XMLdom.Element e2 = d.ownerDocument().getElementByTagName('entry');
        e2.dumpAll();   
        system.assert( d.getElementByTagName('gCal:selected') != null , ' missing gcal');
    }
}