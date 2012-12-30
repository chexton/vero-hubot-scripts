# Description:
#   Github issue creation via Hubot. Eg. "@hubot create issue Adjust phone number on home page assign to User"
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER_JOHN // Set this to John's Github name, e.g. @john123. You can then do 'create issue blah assign to john' and it will assign to his/her Github account
#
# Commands:
#   Listens for 'create issue' and creates an issue for the dedicated repository
#
# Author:
#   chexton

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /create issue? (.*) assign to (.*)/i, (msg) ->

    # bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
    issue_title = msg.match[1]
    issue_number = msg.match[1].replace /#/, ""

    assignee = msg.match[2]
    assignee = assignee.replace("@", "")
    # Try resolving the name to a GitHub username using full, then first name:
    resolve = (n) -> process.env["HUBOT_GITHUB_USER_#{n.replace(/\s/g, '_').toUpperCase()}"]
    assignee = resolve(assignee) or resolve(name.split(' ')[0]) or 'default_github_user_goes_here' # Insert your own default username here

    data = { title: issue_title, assignee: assignee}

    github.post "https://api.github.com/repos/#{process.env.HUBOT_GITHUB_USER}/#{process.env.HUBOT_GITHUB_REPO}/issues", data, (issue_obj) ->
      # issue_number = issue_obj.number
      msg.send "Issue " + issue_obj.number + "created: " + issue_obj.title  + "  https://github.com/" + bot_github_repo + '/issues/' + issue_obj.number + 'and assigned to ' + assignee

