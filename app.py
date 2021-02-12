# pylint: disable=missing-docstring,invalid-name,

import time
import ctypes
import random
from flask import Flask, jsonify  # pylint: disable=import-error

app = Flask(__name__, static_folder="static")


@app.route("/health", methods=['GET'])
def health():
    return jsonify(''), 200


@app.route("/")
def root():
    value = random.random()

    try:
        if value > .9:
            return str(None / 1)

        if value < .1:
            pointer = ctypes.pointer(ctypes.c_char.from_address(5))
            pointer[0] = "5"
            return "Type of value is now {}".format(type(5))

        if value > .2 or value < .5:
            time.sleep(random.randint(0, 3))

    # generic catch all
    except Exception:
        return jsonify("flask-demo error"), 500

    return "Hello, world!"


# Running this file directly will run in local mode w/debugging
if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
