from flask import Flask, request, jsonify

def already_exists():
    return jsonify({"error": "Username already exists"}), 400

def invalid_credentials():
    return jsonify({"error": "Invalid credentials"}), 400

def validate(schema, data):
    for key in schema:
        if key not in data:
            return False
        if not isinstance(data[key], schema[key]):
            return False
    return True

def invalid_data():
    return jsonify({"error": "Invalid data"}), 400