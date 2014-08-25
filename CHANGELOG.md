# Branch Changelog

## Pending

* Changed the style of block invocation, now the outer block accepts an argument, and the `branch` method is to be called on the argument. This allows passing the argument to other blocks.

  Before:
  
        Branch.new do
          puts "Starting threads"
          branch { sleep 5; puts "Thread 1 finished." }
          branch { sleep 2; puts "Thread 2 finished." }
          branch { sleep 1; puts "Thread 3 finished." }
          puts "All threads started."
        end

  After:
  
        Branch.new do |b|
          puts "Starting threads"
          b.branch { sleep 5; puts "Thread 1 finished." }
          b.branch { sleep 2; puts "Thread 2 finished." }
          b.branch { sleep 1; puts "Thread 3 finished." }
          puts "All threads started."
        end



## v0.1.0

**August 11, 2014**

* `new` Initial version
