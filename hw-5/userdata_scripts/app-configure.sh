#!/bin/sh
mkdir /opt/flask-alb-app
export PATH="/home/ubuntu/.local/bin:$PATH"
git clone https://github.com/saaverdo/flask-alb-app -b alb /opt/flask-alb-app
pip3 install -r /opt/flask-alb-app/requirements.txt
gunicorn -b 0.0.0.0 app:app
