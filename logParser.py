# Author: Boven Yan
# Date: Jan 20, 2016
# Purpose of this script: parse Jvb log
import sys
import xml.dom.minidom as xmlParser


def parseLog(options, fileIn="Jvb.log", fileOut="pJvb.log"):
    origLog = open(fileIn, 'r')
    parsedLog = open(fileOut, 'w')

    lines = origLog.readlines()

    for line in lines:
        if ("<iq" in line and
           ("all" in options or "xmpp" in options)):  # this is an xmpp msg
            startIdx = line.find("<iq")
            linePref = line[:startIdx]  # records who record this
            xmppMsg = line[startIdx:]

            parsedLog.write("\n")
            parsedLog.write(" ------------XMPP ----- by " + linePref + "\n")

            xml = xmlParser.parseString(xmppMsg)
            parsedLog.write(xml.toprettyxml())

            continue

        if ("Boven" in line and
           ("all" in options or "Boven" in options)):
            parsedLog.write("\n")
            parsedLog.write(line)
            parsedLog.write("\n")
            continue

        if ("all" in options or "orig" in options):
            parsedLog.write("\n")
            parsedLog.write(line)
            parsedLog.write("\n")

    origLog.close()
    parsedLog.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        options = set()
        for option in sys.argv[1:]:
            if ((option == "all") or (option == "Boven") or
               option == "orig" or (option == "xmpp")):
                options.add(option)

        if len(options) > 0:
            parseLog(options)
            sys.exit(0)

    print "Please insert arguments:"
    print "\"all\" for formatting all log info"
    print "\"Boven\" for printing only customized log"
    print "\"XMPP\" for printing only xmpp log"
