require './commands/4chan'
class SisterMercy::Commands::ChanAn < ChanCommand
  def self.name; :4chan; end

  def random_post(b = 'an')
    board       = get_board(b)
    threadlist  = board.threads
    threadlist.shift

    thread      = threadlist.random
    post        = thread.posts.random
    result = +post.com.gsub(/<br[^>]*>/, "\n").gsub(/<a.*?href=(\S+)[^>]+>(.*?)<\/a>/, "\\2 (\\1)").gsub(/<[^>]+>/, '')
    if post.tim
      result += "  http://i.4cdn.org/#{b}/#{post.tim}#{post.ext}"
    end
    result
  end

  def description
    'random 4chan posts with picture'
  end

  def execute(event, board = 'an')
    random_post(board)
  end
end


