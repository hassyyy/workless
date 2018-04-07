# About this gem

This is a forked version of the original [workless](https://github.com/lostboy/workless) gem.

Workless gem is used to start the worker dynos in heroku when a job is scheduled and stop the worker when all the jobs are processed and executed. In addition to this behavior, this gem start and stops the monitoring service to keep the worker dyno alive when ever it is running. 

To read more about the problem which this gem solves, click [here](https://medium.com/@mohamedrfhasan/run-heroku-workers-without-idling-in-free-plan-906bb1ab8432) 

# Installation

Add this to your ```Gemfile``` and update your bundle:
```
gem "workless", git: "https://github.com/hassyyy/workless.git"
```

# Configuration
- Add this to your ```config/environments/production.rb```:
```
  config.after_initialize do
    Delayed::Job.scaler = :heroku
  end
 ```
 
- Add your Heroku app name / [API key](https://devcenter.heroku.com/articles/authentication) as config vars to your Heroku App.
```
heroku config:add WORKLESS_API_KEY=your_heroku_api_key APP_NAME=your_heroku_app_nam
```

- Signup an [Uptime Robot](https://uptimerobot.com) Account. Create a new monitor with the following configurations:
```
Monitor Type: HTTPS
Friendly Name: your_heroku_app_name
URL: your_app_url
Monitoring Interval: 5-30 minutes (Recommended: 20 minutes)
```

- Add your Uptime Robot [API key](https://uptimerobot.com/api) as config vars to your Heroku App.
```
heroku config:add UPTIME_ROBOT_API_KEY=your_uptime_robot_api_key 
```

# Important Note

This gem can only be tested in Heroku and cannot be tested locally
