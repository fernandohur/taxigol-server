git push heroku master
heroku run rake db:migrate
heroku run rake assets:precompile
