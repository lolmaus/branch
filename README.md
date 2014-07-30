branch
======

Run blocks asynchronously with little effort, a Ruby equivalent for JS setTimeout


Simple example
--------------

### JS

```js
setTimeout( function() {
  console.log('world');
}, 0);

console.log('hello');
```

### Ruby

```rb
Thread.new {puts "world!" }
puts "Hello, "
```


### Ruby + branch

```ruby
Branch.new do
  branch { puts "world!" }
  puts "Hello, "
end
```
