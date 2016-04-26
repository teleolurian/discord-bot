class ChanCommand < SisterMercy::Command
  def get_board(board, page=1)
    get_json_from "http://api.4chan.org/#{board}/#{page}.json"
  end

  def get_post(board, thread_number)
    get_json_from "http://api.4chan.org/#{board}/res/#{thread_number}.json"
  end

  def get_raw_board(board, page=1)
    get_raw_json_from "http://api.4chan.org/#{board}/#{page}.json"
  end

  def get_raw_post(board, thread_number)
    get_raw_json_from "http://api.4chan.org/#{board}/res/#{thread_number}.json"
  end

end


class SisterMercy::Commands::ChanR9kRee < ChanCommand
  def self.name; :reee; end

  def random_r9k_post
    board       = get_board('r9k')
    threadlist  = board.threads
    threadlist.shift

    thread      = threadlist.random
    post        = thread.posts.random
    +post.com.gsub(/<br[^>]*>/, "\n").gsub(/<a.*?href=(\S+)[^>]+>(.*?)<\/a>/, "\\2 (\\1)").gsub(/<[^>]+>/, '')

  end

  def description
    '/r9k/ posts'
  end

  def execute(event)
    random_r9k_post
  end
end


