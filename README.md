# sandbox-sidekiq

```sh
$ bundle install
$ sidekiq -r ./worker.rb
```

別ターミナルで

```sh
$ irb -r ./worker.rb 
irb(main):001:0> MyWorker.perform_async("")
=> "7c2317947169923586e71e4a"
```

sidekiq を見ると

```
2020-05-26T07:48:17.918Z pid=27320 tid=lhg class=MyWorker jid=7c2317947169923586e71e4a INFO: start
Job-Context-Example-A
this is a metadata
Job-Context-Example-B
this is another metadata
did a light job
```