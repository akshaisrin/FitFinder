import json

import os
base = os.path.dirname(os.path.abspath(__file__))
os.chdir(base)


with open("captions.json") as f:
    data = json.load(f)

keys = set(d for d in data.keys() if "_1_" in d)

data = {
    key.split("_")[-3]: {
        "gender": 0 if key.split("-")[0] == "MEN" else 1
    } for key in keys
}

with open("labels/shape/shape_anno_all.txt") as f:
    lines = f.readlines()

for line in lines:
    values = line.split(" ")
    clothes_id = values[0].split("_")[-3]
    if clothes_id not in data:
        continue

    mapped = ["length", "lclength", "socks", "hat", "glasses", "neck", "wrist", "ring", "waist", "neckline", "cardigan", "navel"]
    for i, value in enumerate(values[1:]):
        data[clothes_id][mapped[i]] = int(value)


with open("labels/texture/fabric_ann.txt") as f:
    lines = f.readlines()

for line in lines:
    values = line.split(" ")
    clothes_id = values[0].split("_")[-3]
    if clothes_id not in data:
        continue

    mapped = ["upper_fabric", "lower_fabric", "outer_fabric"]
    for i, value in enumerate(values[1:]):
        data[clothes_id][mapped[i]] = int(value)

with open("labels/texture/pattern_ann.txt") as f:
    lines = f.readlines()

for line in lines:
    values = line.split(" ")
    clothes_id = values[0].split("_")[-3]
    if clothes_id not in data:
        continue

    mapped = ["upper_color", "lower_color", "outer_color"]
    for i, value in enumerate(values[1:]):
        data[clothes_id][mapped[i]] = int(value)



with open("tagged.json", "w") as f:
    json.dump(data, f, indent=4)