# NtaRuby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/nta_ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nta_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nta_ruby

## Usage

国税庁へのAPIのリクエストを送りたいファイルで、まずこの行を追加し、国税庁とのネットワークを確立してください。

```ruby
# AAAAAAAA: あなたの国税庁APIの認証ID
# 4: 利用したい国税庁APIのバージョン
conn = NtaRuby.new(id: 'AAAAAAAAA', version: 4)
```

接続できたら、検索条件を指定するとそれに応じたレスポンスが加工されて返却されます。
```ruby
resp = conn.throw_request(type: :diff, divide: 2, from: Time.zone.local(2019, 9, 1), to: Time.zone.local(2019, 10, 1))
resp.first.name # => '株式会社○△□'
```

### 法人番号検索

法人番号が「1111111111111」のもので検索したい場合
```ruby
resp = conn.throw_request(type: :number, divide: false, number: 1111111111111)
resp.first.name # => '株式会社○△□'
```

法人番号が「1111111111111」のもので検索したい場合(履歴付き)
```ruby
resp = conn.throw_request(type: :number, divide: false, number: 1111111111111, history: true)
resp.first.name # => '株式会社○△□'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nta_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NtaRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nta_ruby/blob/master/CODE_OF_CONDUCT.md).
