Branch
======

**Run blocks asynchronously with little effort. A Ruby equivalent for JS `setTimeout`.**

This tiny lib was written to slightly reduce the amount of scaffolding required to do threads in Ruby. It is aimed at simpler use cases, for more complicated scenarios using vanilla thread syntax is recommended.

I hope Branch can save some frustration for people who discover that implementing a straightforward JS `setTimeout(function() { ... }, 0)` with Ruby is much more complicated and less intuitive. On the other hand, Branch is not an escape from getting to know how threads work.


How it works
------------

1. First of all, wrap your code with the `Branch.new { ... }` wrapper.
2. Within that wrapper, the `branch { ... }` method is available. It starts the passed block in a new asynchronous thread.
3. The end of the `Branch.new { ... }` wrapper will wait for all the threads to finish. In other words, the end of wrapper synchonizes your code. If you start another `Branch.new { ... }` afterwards, it will start sequentially after the previous branch is complete.
4. To start a thread with a delay, use `branch(2) { ... }`. This example will be executed after two seconds, without blocking the main thread.
5. If you need to synchronize a certain operation in order to prevent a race condition (JS coders beware!), you can use a mutex like this:
  
  ```rb
  branch do |mutexes|
    mutexes[:meaningful_mutex_name].synchronize { ... }
  end
  ```

6. You don't need to instantiate mutexes manually. To reuse a mutex in another thread, simply access the `mutexes` hash with the same key. You can use anything for keys, e. g. integers, but a meaningful symbol is recommended.
7. Within a `branch`, you can use as many mutexes as you need.



Example usage
-------------

Please look into these pieces of code to see how Branch usage compares to vanilla syntax


### Simple example

#### Vanilla threads

Requires a fair amount of scaffolding:

* A thread array is to be defined manually.
* Each thread should be added to that array.
* Threads should be joined so that the main script doesn't exit before all threads finish.

```rb
threads = []
puts "Starting threads"
threads << Thread.new { sleep 5; puts "Thread 1 finished." }
threads << Thread.new { sleep 2; puts "Thread 2 finished." }
threads << Thread.new { sleep 1; puts "Thread 3 finished." }
puts "All threads started."
threads.each { |t| t.join }
puts "All threads complete."
```


#### Branch equivalent

All the scaffolding you need is you need is a `Branch.new { }` wrapper.

```ruby
Branch.new do
  puts "Starting threads"
  branch { sleep 5; puts "Thread 1 finished." }
  branch { sleep 2; puts "Thread 2 finished." }
  branch { sleep 1; puts "Thread 3 finished." }
  puts "All threads started."
end
puts "All threads complete."
```




### Thread synchronization with multiple mutexes

All mutexes have to be instantiated manually.

#### Vanilla threads

```rb
threads = []

mutex_array_access         = Mutex.new
mutex_database_transaction = Mutex.new
mutex_coffee_brewing       = Mutex.new

10.times do
  threads << Thread.new do
    
    # Imitating a time-consuming operation
    sleep rand(1..5)
    
    mutex_array_access        .synchronize { shared_array << 'foo' if shared_array.length < 5 }
    mutex_database_transaction.synchronize { DB::send('foo', 888) { |foo| foo.bar }}
    mutex_coffee_brewing      .synchronize { coffee_machine.clean.fill('water').make_coffee }
     
  end
end

threads.each { |t| t.join }
```


#### Branch equivalent

Mutexes are instantiated automatically when they're first used and will persist throughuout the `Branch.new{ }` wrapper.

```ruby
Branch.new do
  10.times do
    branch do |mutexes|
      
      # Imitating a time-consuming operation
      sleep rand(1..5)
    
      mutexes[:array_access]        .synchronize { shared_array << 'foo' if shared_array.length < 5 }
      mutexes[:database_transaction].synchronize { DB::send('foo', 888) { |foo| foo.bar }}
      mutexes[:coffee_brewing]      .synchronize { coffee_machine.clean.fill('water').make_coffee }
      
    end
  end
end
```
