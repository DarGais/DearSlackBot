# SlackBot

## Setting
* Installation of gem
  * In your terminal, install necessary gems:
    ```
    $ bundle install --path vendor/bundle
    ```
* Setup 「Incoming WebHooks」
  * Login Slack with your account
  * Access to [Custome Integrations](https://nomlab.slack.com/apps/manage/custom-integrations)
    * Open Menu at the upper-left corner:
      * TEAMNAME -> Gets Slack Apps -> Configure Apps -> Custom Integrations
  * Click Incoming WebHooks
  * Open 「add Configuration」, add new incoming WebHook
  * Select your destination channel, click 「Add Incoming WebHooks integration」，check Webhook URL
    * Setup 「Customize Name」 or 「Customize Icon」
* Setup 「Outgoing WebHooks」
  * Access to [Custome Integrations](https://nomlab.slack.com/apps/manage/custom-integrations) and Click 「Outgoing WebHooks」
  * From 「Add Configuration」, add new 「Outgoing WebHook」
  * Click 「Add Outgoing WebHooks integration」
  * Setup details of Outgoing WebHook:
    * Channel: which channel you want to watch
    * Trigger Word(s): Word or phrase by which WebHook is kicked
    * URL(s): POST URL on WebHook
  * Setup 「Customize Name」 or 「Customize Icon」
* copy settings.yml template
  ```
  $ cp settings.yml.sample settings.yml
  ```
* Add 「Incomming WebHook URL」 to  your settings.yml
  * incoming_webhook_url: https://XXXXXXXXXXXX

## Run
* Exec MySlackBot.rb in terminal:
  ```
  $ bundle exec rackup config.ru
  ```

## Test
* If you want to test Outgoing WebHooks, post_test.rb in test would be useful.
* Run MySlackBot.rb locally, use post_test.rb to emulate outgoing webhook.
  ```
  $ ruby test/post_test.rb http://localhost:<port>/<path> test/test.json
  ```  
* first argument is POST-URL, second is filename of JSON which you want to post

## Detail
* In this MySlackBot.rb is currency coverter bot.To use this in chat please type:
  ```
  @<bottrigger> convert <number> <currency> to <currency>
  ``` 
  for example:
  ```
  @Dbot convert 1 USD to JPY
  ```
