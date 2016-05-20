require './commands/4chan'
class SisterMercy::Commands::ChanAn < ChanCommand
  def self.name; :an; end

  def random_an_post
    board       = get_board('an')
    threadlist  = board.threads
    threadlist.shift

    thread      = threadlist.random
    post        = thread.posts.random
    result = +post.com.gsub(/<br[^>]*>/, "\n").gsub(/<a.*?href=(\S+)[^>]+>(.*?)<\/a>/, "\\2 (\\1)").gsub(/<[^>]+>/, '')
    if post.tim
      result += "  http://i.4cdn.org/an/#{post.tim}#{post.ext}"
    end
    result
  end

  def description
    '/an/ posts'
  end

  def execute(event)
    random_an_post
  end
end


