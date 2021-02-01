from ivy.std_api import *



def onNavStatus(cnx):
	sendTranslation("navigationStatus {}".format(cnx[0]))

def sendTranslation(message):
	IvySendMsg(message)
def onNavigation(cnx):
	
def main():
	IvyInit("PY-IVY Bridge")
	IvyStart(ivybus = "127.255.255.255:2010")


	IvyBindMsg(lambda x : print("hello world too"), "hello world")	
	IvyBindMsg(onNavigation,"21 NAVIGATION (.*)")

"""
String regexGetLatLon ("ground NAV_STATUS 21 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberLeader ("21 NAVIGATION (.*)")
    	String regexGetBlockJump("gcs JUMP_TO_BLOCK (\\S*) (\\S*)")
"""


if __name__ == '__main__':
	main()