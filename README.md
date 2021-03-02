# WaitForMe
If before executing a task, it is beneficial but not required for other tasks to complete, then 
`wait_for_me` could be helpful.

### An example scenario
A website has multiple web servers in different regions. 
All of these servers are commanded to refresh their website
code. It is desired to invalidate Cloudfront cache after the 
web servers have refreshed, but if something goes wrong
with one of the web servers, Cloudfront should still be refreshed.

## Usage
For the above example, execute the following code every time
a website server completes
```ruby
WaitForMe.add_participant(participant_key:                 'website-server-host-name', # the id of a task
                          group_key:                       'deployment-id', 
                          number_of_participants_in_group: 6, 
                          execute_after_waiting:           'MyClass.a_method',
                          execute_after_waiting_params:    ['foo'], 
                          wait_time_in_seconds:            60) 
```
`participant_key` a unique key for a participant/task

`group_key` related participants are grouped around group-key

`number_of_participants_in_group` after this many different participant_keys are received for a given group_key, `execute_after_waiting` is called

`execute_after_waiting_params` optional parameters to `execute_after_waiting`

`wait_time_in_seconds` wait this long and then execute `execute_after_waiting` if `number_of_participants_in_group` "adds" have not already occurred.
Each time  participant is added, the wait time is reset to this value

The "wait" can programmatically be ended WITHOUT executing  `execute_after_waiting` by calling
```ruby
WaitForMe.remove_wait('deployment-id')
``` 

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'wait_for_me'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install wait_for_me
```
Install Migrations:
```bash 
$ rake wait_for_me:install:migrations && rake db:migrate
```
    
Also, add `wait_for_me` as a sidekiq queue
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
