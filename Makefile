install_ = install
name_ = grml-crypt

etc = ${DESTDIR}/etc/
usr = ${DESTDIR}/usr
usrbin = $(usr)/bin
usrsbin = $(usr)/sbin
usrshare = $(usr)/share/$(name_)
usrdoc = $(usr)/share/doc/$(name_)
man8 = $(usr)/share/man/man8/


%.html : %.txt ;
	asciidoc -b xhtml11 $^

%.gz : %.txt ;
	asciidoc -d manpage -b docbook $^
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/g' `echo $^ |sed -e 's/.txt/.xml/'`
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl `echo $^ |sed -e 's/.txt/.xml/'`
	gzip -f --best `echo $^ |sed -e 's/.txt//'`


all: doc

doc: doc_man doc_html

doc_html: $(name_).8.html
grml-crypt.8.html: $(name_).8.txt

doc_man: $(name_).8.gz
grml-crypt.8.gz: $(name_).8.txt


install: all
	$(install_) -d -m 755 $(usrdoc)
	$(install_) -m 644 $(name_).8.html $(usrdoc)

	$(install_) -d -m 755 $(man8)
	$(install_) -m 644 $(name_).8.gz $(man8)

	$(install_) -m 755 -d $(usrsbin)
	$(install_) -m 755 $(name_) $(usrsbin)

clean:
	rm -rf $(name_).8.xml $(name_).8

cleanall: clean
	rm -rf $(name_).8.html $(name_).8.gz
