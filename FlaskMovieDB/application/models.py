from application import db

class Movies(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    
class Review(db.Model): # customise
    id = db.Column(db.Integer, primary_key=True)
    rev = db.Column(db.String(255))
    rating = db.Column(db.Integer)
    movies_id = db.Column(db.Integer, db.ForeignKey('movies.id'), nullable=True)

