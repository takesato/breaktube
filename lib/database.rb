require 'sqlite3'

class DataBase
  def initialize
    @dbenv = "breaktube-prod.db"
  end

  def youtube_id_search?(youtube_id)
    db = SQLite3::Database.new @dbenv
    db.execute("SELECT youtube_id FROM playlists WHERE youtube_id = \"#{youtube_id}\"").empty?
  end

  def playlist_id_search(youtube_id)
    db = SQLite3::Database.new @dbenv
    db.execute("SELECT id FROM playlists WHERE youtube_id = \"#{youtube_id}\"")
  end

  def playlists_insert(user_name,youtube_id)
    c_at = Time.now.to_i
    db = SQLite3::Database.new @dbenv
    db.execute("INSERT INTO playlists (user_name, youtube_id, created_at) VALUES (?, ?, ?)",
               [user_name, youtube_id, c_at])
  end

  def playlists_count
    db = SQLite3::Database.new @dbenv
    db.execute("SELECT COUNT(1) FROM playlists").flatten[0].to_i
  end

  def rand_pick(range: 0)
    db = SQLite3::Database.new @dbenv
    sql = <<EOS
SELECT youtube_id
FROM(
  SELECT id, youtube_id
  FROM playlists
EOS
sql << "ORDER BY id DESC limit #{range}" if range != 0
sql << ")"
    db.execute(sql).flatten.sample
  end
end
