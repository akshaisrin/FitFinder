import io
from flask import Flask, request, jsonify
import json
import sys
import random
import os
import uuid
import settings
import psycopg2
import flaskerrors as fe
from PIL import Image
import base64

base = os.path.dirname(os.path.abspath(__file__))
os.chdir(base)

app = Flask(__name__)

with open("tagged.json") as f:
    realclothesdata = json.load(f)


connection = psycopg2.connect(
    user=settings.USER,
    password=settings.PASSWORD,
    host=settings.HOST,
    port=settings.PORT,
    database=settings.DB,
    sslmode="require"
)
connection.set_session(autocommit=True)
cursor = connection.cursor()
tokens = {}

@app.route("/api/login", methods=["POST"])
def login():

    if not fe.validate({
        "username": str,
        "password": str
    }, request.json):
        return fe.invalid_data()

    username = request.json["username"]
    pwdhash = request.json["password"]

    cursor.execute("""SELECT user_id FROM "UserInfo" WHERE username = %s AND user_password = %s""", (username, pwdhash))
    id_ = cursor.fetchone()
    if id_ is None:
        return fe.invalid_credentials()

    user_id = id_[0]
    if user_id in tokens.values():
        return {"status": "success", "token": [token for token, id in tokens.items() if id == user_id][0]}
    token = str(uuid.uuid4())
    tokens[token] = user_id
    return jsonify({"status": "success", "token": token})



@app.route("/api/register", methods=["POST"])
def register():

    if not fe.validate({
        "username": str,
        "password": str,
        "email": str
    }, request.json):
        return fe.invalid_data()

    username = request.json["username"]
    pwdhash = request.json["password"]
    useremail = request.json["email"]


    cursor.execute("""SELECT * FROM "UserInfo" WHERE username = %s""", (username,))
    if cursor.fetchone() is not None:
        return fe.already_exists()

    userid = str(uuid.uuid4())
    cursor.execute("""INSERT INTO "UserInfo" (user_id, user_email, username, user_password) VALUES (%s, %s, %s, %s)""", (userid, useremail, username, pwdhash))
    token = str(uuid.uuid4())
    tokens[token] = userid
    return jsonify({"status": "success", "token": token})

@app.route("/api/send_message", methods=["POST"])
def send_message():

    data = request.json

    if not fe.validate({
        "token": str,
        "receiver_id":str,
        "message_text":str,
        "chat_id":int,
        "timestamp":str
    }, request.json):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    
    sender_id = tokens[token]
    receiver_id=request.json["receiver_id"]
    message_text=request.json["message_text"]
    chat_id=request.json["chat_id"]
    timestamp=request.json["timestamp"]

    message_id=str(uuid.uuid4())

    cursor.execute("""INSERT INTO "MessageInfo" (message_id, sender_id, receiver_id, chat_id, message_text, timestamp) 
                   VALUES (%s, %s, %s, %s, %s)""", (message_id, sender_id, receiver_id, chat_id, message_text, timestamp))
    return jsonify({"status": "success"})  
    



user_data = {
    "1": {
        "gender": [0] * 2,
        "length": [0] * 6,
        "lclength": [0] * 5,
        "socks": [0] * 4,
        "hat": [0] * 3,
        "glasses": [0] * 5,
        "neck": [0] * 3,
        "wrist": [0] * 3,
        "ring": [0] * 3,
        "waist": [0] * 5,
        "neckline": [0] * 7,
        "cardigan": [0] * 3,
        "navel": [0] * 3,
        "upper_fabric": [0] * 8,
        "lower_fabric": [0] * 8,
        "outer_fabric": [0] * 8,
        "upper_color": [0] * 8,
        "lower_color": [0] * 8,
        "outer_color": [0] * 8,
        "recent": []
    }
}




@app.route("/api/swipe-right", methods=["POST"])
def swipe_right():
    data = request.json
    # user_id = data["user_id"]

    if not fe.validate({
        "token": str
    }, data):
        return fe.invalid_data()


    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]


    clothes_id = data["clothes_id"]

    clothes_data = realclothesdata[clothes_id]
    userdata = user_data[user_id]
    for item in clothes_data:
        userdata[item][clothes_data[item]] += 1

    user_data[user_id] = userdata
    user_data[user_id]["recent"].append(clothes_id)
    if len(user_data[user_id]["recent"]) > 20:
        user_data[user_id]["recent"].pop(0)

    return jsonify({"status": "success"})


@app.route("/api/swipe-left", methods=["POST"])
def swipe_left():
    data = request.json
    # user_id = data["user_id"]

    if not fe.validate({
        "token": str
    }, data):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]


    clothes_id = data["clothes_id"]

    clothes_data = realclothesdata[clothes_id]
    userdata = user_data[user_id]
    for item in clothes_data:
        userdata[item][clothes_data[item]] -= 1

    user_data[user_id] = userdata
    user_data[user_id]["recent"].append(clothes_id)
    if len(user_data[user_id]["recent"]) > 20:
        user_data[user_id]["recent"].pop(0)


    return jsonify({"status": "success"})


def match(user_id, clothes_id):
    userdata = user_data[user_id]
    clothes_data = realclothesdata[clothes_id]

    score = 0
    for item in clothes_data:
        score += userdata[item][clothes_data[item]]

    return score

@app.route("/api/next", methods=["POST"])
def getnext():
    data = request.json
    # user_id = data["user_id"]

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]



    ids = sorted(realclothesdata.keys(), key=lambda x: match(user_id, x), reverse=True)
    chosen = []
    i = 0
    while len(chosen) < 50:
        newid = ids[i]
        if newid in user_data[user_id]["recent"]:
            i += 1
            continue
        chosen.append(newid)
        i += 1

    chosenid = random.choice(chosen)
    return jsonify({"clothes_id": chosenid})


@app.route("/api/user", methods=["POST"])
def getuser():
    data = request.json
    # user_id = data["user_id"]

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]



    return jsonify(user_data[user_id])


@app.route("/api/set-pfp", methods=["POST"])
def setpfp():
    data = request.json
    if not all(key in data for key in ["token", "pfp"]):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]

    pfp = data["pfp"]
    # convert from base64 to image
    image_data = base64.b64decode(pfp)
    image_path = f"{user_id}.png"

    image = Image.open(io.BytesIO(image_data))
    image = image.resize((256, 256))
    image = image.convert("RGB")

    fullpath = os.path.join(base, "pfps", image_path)
    image.save(fullpath)

    return jsonify({"status": "success", "message": "Profile picture uploaded successfully"})


@app.route("/api/get-pfp", methods=["POST"])
def getpfp():
    data = request.json
    if not all(key in data for key in ["token"]):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]

    if os.path.exists(os.path.join(base, "pfps", f"{user_id}.png")):
        fullpath = os.path.join(base, "pfps", f"{user_id}.png")
    else:
        fullpath = os.path.join(base, "pfps", "default.png")


    try:
        with open(fullpath, "rb") as f:
            return jsonify({"status": "success", "pfp": base64.b64encode(f.read()).decode()})
    except FileNotFoundError:
        return jsonify({"status": "error", "message": "Profile picture not found"}), 500
        




@app.route("/")
def index():
    return "This is a webserver for FitFinder.<br><br>Made with 🧡 by <a href=\"https://github.com/trigtbh\">trig</a>"


def main():
    app.run(host=settings.HTTP_HOST, port=settings.HTTP_PORT, ssl_context=settings.SSL_CONTEXT)

if __name__ == "__main__":
    main()