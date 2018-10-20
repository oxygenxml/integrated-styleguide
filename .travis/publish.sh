#!/bin/bash

echo "Publish $TRAVIS_BRANCH !"

REPONAME=`basename $PWD`
PARENTDIR=`dirname $PWD`
USERNAME=`basename $PARENTDIR`

java -version

echo "====================================="
echo "download DITA-OT"
echo "====================================="
wget https://github.com/dita-ot/dita-ot/releases/download/2.5.2/dita-ot-2.5.2.zip >> download.log 2>>download.log
echo "..."
tail -n 2 download.log

echo "====================================="
echo "extract DITA-OT"
echo "====================================="
unzip dita-ot-2.5.2.zip >> extract.log 2>>extract.log
head -n 10 extract.log
echo "..."

echo "====================================="
echo "download WebHelp plugin"
echo "====================================="

wget https://www.oxygenxml.com/InstData/WebHelp/oxygen-webhelp-dot-2.x.zip  >> download.log 2>>download.log
echo "..."
tail -n 2 download.log

echo "====================================="
echo "extract WebHelp to DITA-OT"
echo "====================================="
unzip oxygen-webhelp-dot-2.x.zip >> extract.log 2>>extract.log
head -n 10 extract.log
echo "..."
cp -R com.oxygenxml.* dita-ot-2.5.2/plugins/

echo $WEBHELP_LICENSE | tr " " "\n" | head -3 | tr "\n" " " > licensekey.txt
echo "" >> licensekey.txt
echo $WEBHELP_LICENSE | tr " " "\n" | tail -8  >> licensekey.txt

echo "****"
cat licensekey.txt | head -8
echo "****"

cp licensekey.txt dita-ot-2.5.2/plugins/com.oxygenxml.webhelp.responsive/licensekey.txt


echo "====================================="
echo "Add Edit Link to DITA-OT"
echo "====================================="

# Add the editlink plugin
git clone https://github.com/oxygenxml/dita-reviewer-links plugins/
cp -R plugins/com.oxygenxml.editlink dita-ot-2.5.2/plugins/

echo "====================================="
echo "integrate plugins"
echo "====================================="
cd dita-ot-2.5.2/
bin/ant -f integrator.xml 
cd ..


echo "====================================="
echo "download Saxon9"
echo "====================================="
wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/SaxonHE9-9-0-1J.zip >> download.log 2>>download.log
echo "..."
tail -n 2 download.log

echo "====================================="
echo "extract Saxon9"
echo "====================================="
unzip SaxonHE9-9-0-1J.zip -d saxon9/ >> extract.log 2>>extract.log
head -n 10 extract.log
echo "..."



echo "====================================="
echo "generate Schematron rules"
echo "====================================="
java -cp saxon9/saxon9he.jar:dita-ot-2.5.2/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -s:src/styleguide.ditamap -xsl:src/rules/extractRules.xsl -catalog:dita-ot-2.5.2/catalog-dita.xml publishedBaseURL=$USERNAME.github.io/$REPONAME/

head -n 10 src/rules/rules.sch
echo "..."


mkdir -p out/rules
cp src/rules/blockElements.xml out/rules/blockElements.xml
cp src/rules/library.sch out/rules/library.sch
cp src/rules/quickFix-library.xml out/rules/quickFix-library.xml
cp src/rules/rules.sch out/rules/rules.sch


echo "====================================="
echo "Publish the style guide as WebHelp"
echo "====================================="


# Send some parameters to the "editlink" plugin as system properties
export ANT_OPTS="$ANT_OPTS -Deditlink.remote.ditamap.url=github://getFileContent/$USERNAME/$REPONAME/$TRAVIS_BRANCH/src/styleguide.ditamap"
# Send parameters for the Webhelp styling.
export ANT_OPTS="$ANT_OPTS -Dwebhelp.fragment.welcome='$WELCOME'"

#export ANT_OPTS="$ANT_OPTS -Dwebhelp.responsive.template.name=bootstrap" 
#export ANT_OPTS="$ANT_OPTS -Dwebhelp.responsive.variant.name=tiles"
export ANT_OPTS="$ANT_OPTS -Dwebhelp.publishing.template=dita-ot-2.5.2/plugins/com.oxygenxml.webhelp.responsive/templates/$TEMPLATE/$TEMPLATE-$VARIANT.opt"

dita-ot-2.5.2/bin/dita -i src/styleguide.ditamap -f webhelp-responsive -o out
echo "====================================="
echo "index.html"
echo "====================================="
cat out/index.html
