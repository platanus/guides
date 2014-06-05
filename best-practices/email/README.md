## Subcribing to hear bounces and complaints.

In general terms, any app that sends emails should know when the destinataries are not receiving their emails and/or when they are complaining (spam notices).

Amazon's aws-sdk lets us subscribe to events such as a bounce using SNS.

```ruby

require('aws-sdk')

sns = AWS::SNS.new(
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

# We choose a name for the topic, in this case MyApp-Bounces

arn = sns.client.create_topic({name:'MyApp-Bounces'}).topic_arn

# we retrieve the topic we just created

topic = sns.topics[arn]

# we subscribe our own url to the topic

topic.subscribe('http://example.com/messages')

# TODO: continue this documentation, check if we are already subscribed.

# Also remember to add this SNS Topic to our SES configuration for Bounces.
```
