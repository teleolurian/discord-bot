class SisterMercy::Commands::ChanAn < ChanCommand
  def self.name; :an; end

  def random_an_post
    board       = get_board('an')
    threadlist  = board.threads
    threadlist.shift

    thread      = threadlist.random
    post        = thread.posts.random
    +post.com.gsub(/<br[^>]*>/, "\n").gsub(/<a.*?href=(\S+)[^>]+>(.*?)<\/a>/, "\\2 (\\1)").gsub(/<[^>]+>/, '')
    if post.tim
      +"http://i.4cdn.org/an/#{post.tim}#{post.ext}"
    end
  end

  def description
    '/an/ posts'
  end

  def execute(event)
    random_an_post
  end
end


