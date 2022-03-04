from flask import render_template, redirect, url_for, request

from flask import Flask, jsonify, request
import json, os, signal

from application import app, db
from application.models import Movies, Review
from application.forms import MoviesForm, ReviewForm

@app.route('/', methods= ['GET', 'POST'])
def index():
    all_movies = Movies.query.all()
    return render_template('index.html', all_movies=all_movies)

@app.route('/add', methods= ['GET', 'POST'])
def add():
    form = MoviesForm()
    if form.validate_on_submit():
        new_movie = Movies(name=form.name.data)
        db.session.add(new_movie)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('add.html', form=form)

@app.route('/update/<int:idnum>', methods= ['GET', 'POST'])
def update(idnum):
    form = MoviesForm()
    movies_update = Movies.query.get(idnum)
    if form.validate_on_submit():
        movies_update.name = form.name.data
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('update.html', form=form)

@app.route('/delete/<int:idnum>')
def delete(idnum):
    movies_delete = Movies.query.get(idnum)
    db.session.delete(movies_delete)
    db.session.commit()
    return redirect(url_for('index'))

@app.route('/add_review/<int:idnum>', methods= ['GET', 'POST'])
def add_review(idnum):
    form = ReviewForm()
    if form.validate_on_submit():
        new_review = Review(rev=form.rev.data, rating=form.rating.data, movies_id=idnum)
        db.session.add(new_review)
        db.session.commit()
        return redirect(url_for('reviews', idnum=idnum))
    return render_template('add_review.html', form=form, movies= Movies.query.get(idnum))

@app.route('/reviews/<int:idnum>', methods=['GET', 'POST'])
def reviews(idnum):
    reviews = Review.query.filter_by(movies_id=idnum).all()
    return render_template ('reviews.html', reviews=reviews)

@app.route('/stopServer', methods=['GET'])
def stopServer():
    os.kill(os.getpid(), signal.SIGINT)
    return jsonify({ "success": True, "message": "Server is shutting down..." })

# @app.route('/stopServer', methods=['GET'])
# def stopServer():
#     os.kill(os.getpid(), signal.SIGINT)
#     return jsonify({ "success": True, "message": "Server is shutting down..." })
