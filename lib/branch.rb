class Branch

  VERSION = "0.1.0"
  DATE = "2014-07-31"
  
  def initialize(&block)
    @threads = []
    @mutexes = Hash.new { |hash, key| hash[key] = Mutex.new }
    
    # Executing the passed block within the context
    # of this class' instance.
#     instance_eval &block if block_given?
    yield self
    
    # Waiting for all threads to finish
    @threads.each { |thr| thr.join }
  end
  
  # This method will be available within a block
  # passed to `Branch.new`.
  def branch(delay = false, &block)
    
    # Starting a new thread 
    @threads << Thread.new do
    
      # Implementing the timeout functionality
      sleep delay if delay.is_a? Numeric
      
      # Executing the block passed to `branch`,
      # providing mutexes into the block.
      block.call @mutexes
    end
  end
end
