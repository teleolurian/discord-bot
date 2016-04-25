class SisterMercy::Commands::FourChan < SisterMercy::Command
  def self.name; :chan; end

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

  def page_list(event, board, page=1)
    get_board(board, page).threads.each do |thread|
      op = thread.posts[0]
      sub = op['sub'] ? 'Anon' : op['sub']
      fp = op.com.gsub(/<br[^>]*>/i, $/).gsub(/<[^>]+>/,'') rescue ""
      fp = fp.length > 255 ? (fp[0..255] + "...") : fp
      event << "#{sub} - #{fp}"
    end
  end

  def description
    '4chan posts'
  end

  def execute(event, board, post=nil)
    page_list(event, board, 1)
  end
end


