branch
======

Run blocks asynchronously with little effort, a Ruby equivalent for JS setTimeout.

This tiny lib was written to help save some typing when doing threads with Ruby.



Simple example
--------------

### Vanilla Ruby

```rb
threads = []
puts "Starting threads"
threads << Thread.new { sleep 5; puts "Thread 1 finished. }
threads << Thread.new { sleep 2; puts "Thread 2 finished. }
threads << Thread.new { sleep 1; puts "Thread 3 finished. }
puts "All threads started."
threads.each { |t| t.join }
puts "All threads complete."
```


### Ruby + branch

```ruby
Branch.new do
  puts "Starting threads"
  branch { sleep 5; puts "Thread 1 finished. }
  branch { sleep 2; puts "Thread 2 finished. }
  branch { sleep 1; puts "Thread 3 finished. }
  puts "All threads started."
end
puts "All threads complete."
```



Thread synchronization
----------------------

### Vanilla Ruby

```rb
shared_var = true

threads = []
mutex = Mutex.new

10.times do
  threads << Thread.new do
    
    # Imitating a time-consuming operation
    sleep rand(1..5)
    
    # After the operation is complete, writing the result synchronously
    mutex.synchronize do
      # Assuming this would cause a race condition without a mutex
      puts "test" if shared_var
    end
    
  end
end

threads.each { |t| t.join }
```


### Ruby + branch

```ruby
shared_var = true

Branch.new do
  10.times do
    branch do |mutex|
      
      # Imitating a time-consuming operation
      sleep rand(1..5)
      
      # After the operation is complete, writing the result synchronously
      mutex.synchronize do
        # Assuming this would cause a race condition without a mutex
        puts "test" if shared_var
      end
      
    end
  end
end
```
