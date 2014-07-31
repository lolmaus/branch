branch
======

Run blocks asynchronously with little effort, a Ruby equivalent for JS setTimeout.

This tiny lib was written to help save some typing when doing threads with Ruby.



Simple example
--------------

### Vanilla Ruby

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


### Ruby + branch equivalent

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




Thread synchronization with multiple mutexes
--------------------------------------------

Mutexes have all be instantiated manually.

### Vanilla Ruby

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


### Ruby + branch equivalent

Mutexes are instantiated the moment they're first used and will persist throughuout the `Branch.new{ }` wrapper.

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
