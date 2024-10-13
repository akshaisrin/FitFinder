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
import boto3
import botosettings
from bedrock import *

s3 = boto3.resource(    
    "s3",
    aws_access_key_id=botosettings.ACCESS_KEY,
    aws_secret_access_key=botosettings.SECRET_KEY
)


base = os.path.dirname(os.path.abspath(__file__))
os.chdir(base)

with open("captions.json") as f:
    filenames = json.load(f).keys()

with open("classifications.txt") as f:
    c = f.read()
    lines = c.split("\n")
    classifications = {}
    for l in lines:
        c, tags = l.split(":")
        classifications[c] = tags.split(",")

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


@app.route("/api/get_image/<id_>", methods=["POST"])
def get_image(id_):

    # if not fe.validate({
    #     "token": str
    # }, request.json):
    #     return fe.invalid_data()
    
    # token = request.json["token"]
    # if token not in tokens:
    #     return jsonify({"status": "error", "message": "Invalid token"})
    
    # id_ = request.json["id"]

    for item in filenames:
        if id_ + "_1" in item:
            break
    
    bucket = s3.Bucket("fitfinder")
    obj = bucket.Object(item)
    response = obj.get()
    base64_image = base64.b64encode(response["Body"].read()).decode()
    return jsonify({"status": "success", "image": base64_image})

@app.route("/api/do_ai_styling", methods=["POST"])
def do_ai_styling():
    if not fe.validate({
        "token": str
    }, request.json):
        return fe.invalid_data()
    
    token = request.json["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"}), 400
    
    cursor.execute("""select * from "UserPreferenceMapping" where user_id = %s""", (tokens[token],))
    data = cursor.fetchone()[1:]

    classes = {}

    for i in range(len(data)):
        maximum = max(data[i])
        classes[list(classifications.keys())[i]] = classifications[list(classifications.keys())[i]][data[i].index(maximum)]
    
    query="I want you to return a short, 3-4 word fashion style that encompasses these attributes: "
    for key in classes:
        query+=key + ": " + classes[key] + ", "

    query=query[0:-1] 
    style=query_bedrock(query)
        
    return jsonify({"status": "success", "style": style})

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
    cursor.execute("""INSERT INTO "UserInfo" (user_id, user_email, username, user_password, follower_ids, following_ids, style_description) VALUES (%s, %s, %s, %s, array[]::text[], array[]::text[], %s)""", (userid, useremail, username, pwdhash, ""))
    
    # im so sorry
    cursor.execute("""INSERT INTO "UserPreferenceMapping" (user_id, 
                   sleeve_length, lower_clothing_length, socks, hat, glasses, neckwear, wrist_wearing, ring, waist_accessories,
                   neckline, outer_clothing, upper_clothing, upper_fabric, lower_fabric, outer_fabric,
                   upper_color, lower_color, outer_color) VALUES (
                   %s, ARRAY[0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0], ARRAY[0, 0, 0],
                   ARRAY[0, 0, 0, 0, 0], ARRAY[0, 0, 0], ARRAY[0, 0, 0], ARRAY[0, 0, 0], 
                   ARRAY[0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0], ARRAY[0, 0, 0], 
                   ARRAY[0, 0, 0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0, 0, 0, 0], 
                   ARRAY[0, 0, 0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0, 0, 0, 0], ARRAY[0, 0, 0, 0, 0, 0, 0, 0])""", (userid,))
    
    
    
    token = str(uuid.uuid4())
    tokens[token] = userid
    return jsonify({"status": "success", "token": token})

@app.route("/api/send_message", methods=["POST"])
def send_message():

    data = request.json

    if not fe.validate({
        "token": str,
        # "receiver_id":str,
        "message_text":str,
        "chat_id":str,
        "timestamp":float
    }, request.json):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    
    sender_id = tokens[token]
    # receiver_id=request.json["receiver_id"]
    message_text=request.json["message_text"]
    chat_id=request.json["chat_id"]
    timestamp=request.json["timestamp"]

    message_id=str(uuid.uuid4())

    cursor.execute("""INSERT INTO "MessageInfo" (message_id, sender_id, chat_id, message_text, timestamp) 
                   VALUES (%s, %s, %s, %s, %s)""", (message_id, sender_id, chat_id, message_text, timestamp))
    return jsonify({"status": "success"})  
    
@app.route("/api/create_chat", methods=["POST"])
def create_chat():

    data = request.json

    if not fe.validate({
        "token": str,
        "other_person_id":str
    }, request.json):
        return fe.invalid_data()

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    
    user_id = tokens[token]
    other_user_id=request.json["other_person_id"]
    members=[user_id, other_user_id]

    chat_id=str(uuid.uuid4())

    cursor.execute("""INSERT INTO "ChatInfo" (chat_id, chat_members) 
                   VALUES (%s, %s)""", (chat_id, members))
    return jsonify({"status": "success"})  
    

mapped_labels = {
    "length": "sleeve_length",
    "lclength": "lower_clothing_length",
    "socks": "socks",
    "hat": "hat",
    "glasses": "glasses",
    "neck": "neckwear",
    "wrist": "wrist_wearing",
    "ring": "ring",
    "waist": "waist_accessories",
    "neckline": "neckline",
    "cardigan": "outer_clothing",
    "navel": "upper_clothing",
    "upper_fabric": "upper_fabric",
    "lower_fabric": "lower_fabric",
    "outer_fabric": "outer_fabric",
    "upper_color": "upper_color",
    "lower_color": "lower_color",
    "outer_color": "outer_color"
}



recents = {}



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
    for key, value in mapped_labels.items():
        cursor.execute("""select %s from "UserPreferenceMapping" where user_id = %s""", (value, user_id))
        data = cursor.fetchone()[0]
        data[
            clothes_data[key]
        ] += 1
        cursor.execute("""update "UserPreferenceMapping" set %s = %s where user_id = %s""", (value, data, user_id))

    if user_id not in recents:
        recents[user_id] = []
    recents[user_id].append(clothes_id)
    if len(recents[user_id]) > 20:
        recents[user_id].pop(0)

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
    for key, value in mapped_labels.items():
        cursor.execute("""select %s from "UserPreferenceMapping" where user_id = %s""", (value, user_id))
        data = cursor.fetchone()[0]
        data[
            clothes_data[key]
        ] -= 1
        cursor.execute("""update "UserPreferenceMapping" set %s = %s where user_id = %s""", (value, data, user_id))



    if user_id not in recents:
        recents[user_id] = []
    recents[user_id].append(clothes_id)
    if len(recents[user_id]) > 20:
        recents[user_id].pop(0)

    return jsonify({"status": "success"})


def match(userdata, clothes_id):
    # userdata = user_data[user_id]
    
    clothes_data = realclothesdata[clothes_id]

    score = 0
    for i, item in enumerate(list(clothes_data.keys())[1:]):
        score += userdata[i][clothes_data[item]]

    return score

@app.route("/api/next", methods=["POST"])
def getnext():
    data = request.json
    # user_id = data["user_id"]

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]

    cursor.execute("""SELECT * FROM "UserPreferenceMapping" WHERE user_id = %s""", (user_id,))
    userdata = cursor.fetchone()[1:]


    ids = sorted(realclothesdata.keys(), key=lambda x: match(userdata, x), reverse=True)
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

@app.route("/api/get_user_info", methods=["POST"])
def get_user_info():
    data = request.json
    # user_id = data["user_id"]

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    
    user_id = data["user_id"]

    cursor.execute("""SELECT username, user_id, user_bio_text, follower_ids, following_ids,\
                   style_description, top_style_pics FROM "UserInfo" WHERE user_id = %s""", (user_id,))
    data = cursor.fetchone()
    if data is None:
        return fe.invalid_credentials()

    data_dict={"username":data[0], "user_id": data[1], \
               "user_bio_text":data[2], "follower_ids": data[3], \
                "following_ids":data[4], "style_description":data[5], \
                "top_style_pics":data[6]}

    return jsonify(data_dict)

@app.route("/api/whoami", methods=["POST"])
def whoami():
    data = request.json
    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]
    return user_id

@app.route("/api/get_user_chats", methods=["POST"])
def get_user_chats():
    data = request.json
    # user_id = data["user_id"]

    token = data["token"]
    if token not in tokens:
        return jsonify({"status": "error", "message": "Invalid token"})
    user_id = tokens[token]

    cursor.execute("""SELECT chat_id, chat_members FROM "ChatInfo" WHERE %s = ANY(chat_members)""", (user_id,))
    rows = cursor.fetchall()
    if rows is None:
        return fe.invalid_credentials()

    other_userids = []
    chat_ids=[]
        
    for row in rows:
        chat_id=row[0]
        chat_members = row[1]

        # Filter out the provided userid from the chat_members list
        other_members = [member for member in chat_members if member != user_id]

        # Add other members to the set
        other_userids.append(other_members[0])
        chat_ids.append(chat_id)

    return jsonify({"user_ids":other_userids, "chat_ids":chat_ids})


@app.route("/api/get_recent_messages", methods=["POST"])
def get_recent_messages():
    
    if not fe.validate({
        "chat_id":str
    }, request.json):
        return fe.invalid_data()

    chat_id=request.json["chat_id"]

    cursor.execute("""SELECT sender_id, message_text, timestamp FROM "MessageInfo" WHERE chat_id= %s \
                   ORDER BY message_id DESC LIMIT 20""", (chat_id,))
    rows = cursor.fetchall()[::-1]
    if rows is None:
        return fe.invalid_credentials()

    messages_list = []
    for message in rows:
        message_dict = {
            'sender_id': message[0],
            'message_text': message[1],
            'timestamp': message[2]
        }
        messages_list.append(message_dict)

    return jsonify({"message_info":messages_list})



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