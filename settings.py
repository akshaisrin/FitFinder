URI = "postgres://avnadmin:AVNS_dwg92kzx-ZaoNu1_01g@fitfinder-terminal-suite-discord.b.aivencloud.com:15025/defaultdb?sslmode=require"

DB = "FitFinderDB"
USER = "avnadmin"
PASSWORD = "AVNS_dwg92kzx-ZaoNu1_01g"
HOST = "fitfinder-terminal-suite-discord.b.aivencloud.com"
PORT = 15025




import os, sys

HTTP_HOST = "0.0.0.0"
HTTP_PORT = 5000
SOCKET_PORT = 5001
VOICE_PORT = 5002
VIDEO_PORT = 5003
URI = f"http://{HOST}:{HTTP_PORT}"

SSL_CONTEXT = None

if len(sys.argv) == 3: # assumes it's running on trigtbh.dev - don't mess around with this pleaseeee
    # SSL_CERT = os.environ["SSL_CERT"]
    # SSL_KEY = os.environ["SSL_KEY"]

    SSL_CERT = sys.argv[1]
    SSL_KEY = sys.argv[2]


    SSL_CONTEXT = (SSL_CERT, SSL_KEY)
    URI = f"https://trigtbh.dev:{HTTP_PORT}"

