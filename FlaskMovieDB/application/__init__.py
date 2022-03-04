from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
db = SQLAlchemy(app)

#app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///C:\\workspaceBackup\\DevOps\\BasicProjectExample\\FlaskMovieDB\\flask.sqlite3'
#app.config['SECRET_KEY'] = '123456789'

#SECRET_KEY = '123456789'

#BASEDIR = os.path.dirname(os.path.abspath(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = \
    f'MySQL://' \
    f'{os.getenv("MYSQL_USER")}:' \
    f'{os.getenv("MYSQL_PASSWORD")}@' \
    f'{os.getenv("MYSQL_HOSTNAME")}:' \
    f'{os.getenv("MYSQL_PORT")}/' \
    f'{os.getenv("MYSQL_DATABASE")}'
app.config['SECRET_KEY'] = '123456789'

