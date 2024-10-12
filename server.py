from flask import Flask, request, jsonify
import json
import sys
import random
import os
import uuid

base = os.path.dirname(os.path.abspath(__file__))
os.chdir(base)

app = Flask(__name__)

with open("tagged.json") as f:
    realclothesdata = json.load(f)


tokens = {}

@app.route("/login", methods=["POST"])
def login():
    username = request.json["username"]
    pwdhash = request.json["password"]

    # TODO: check if username and password match

    user_id = ... # TODO: grab user id from database
    token = str(uuid.uuid4())
    tokens[token] = user_id
    return jsonify({"token": token})



@app.route("/register", methods=["POST"])
def register():
    username = request.json["username"]
    pwdhash = request.json["password"]


    # TODO: check if username already exists


    userid = str(uuid.uuid4())
    # TODO: add to database






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




@app.route("/")
def index():
    return "This is a webserver for FitFinder."


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
