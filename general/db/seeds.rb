# frozen_string_literal: true

# bundle exec rails db:seed
# bundle exec rails db:seed:replant

# DATA
if_poem_body = <<~BODY
  If you can keep your head when all about you
      Are losing theirs and blaming it on you,
  If you can trust yourself when all men doubt you,
      But make allowance for their doubting too;
  If you can wait and not be tired by waiting,
      Or being lied about, don’t deal in lies,
  Or being hated, don’t give way to hating,
      And yet don’t look too good, nor talk too wise:

  If you can dream—and not make dreams your master;
      If you can think—and not make thoughts your aim;
  If you can meet with Triumph and Disaster
      And treat those two impostors just the same;
  If you can bear to hear the truth you’ve spoken
      Twisted by knaves to make a trap for fools,
  Or watch the things you gave your life to, broken,
      And stoop and build ’em up with worn-out tools:

  If you can make one heap of all your winnings
      And risk it on one turn of pitch-and-toss,
  And lose, and start again at your beginnings
      And never breathe a word about your loss;
  If you can force your heart and nerve and sinew
      To serve your turn long after they are gone,
  And so hold on when there is nothing in you
      Except the Will which says to them: ‘Hold on!’

  If you can talk with crowds and keep your virtue,
      Or walk with Kings—nor lose the common touch,
  If neither foes nor loving friends can hurt you,
      If all men count with you, but none too much;
  If you can fill the unforgiving minute
      With sixty seconds’ worth of distance run,
  Yours is the Earth and everything that’s in it,
      And—which is more—you’ll be a Man, my son!
BODY

city_poem_body = <<~BODY
  Over the edge of the purple down,
    Where the single lamplight gleams,
  Know ye the road to the Merciful Town
    That is hard by the Sea of Dreams –
  Where the poor may lay their wrongs away,
    And the sick may forget to weep?
  But we – pity us! Oh, pity us!
    We wakeful; ah, pity us! –
  We must go back with Policeman Day –
    Back from the City of Sleep!

  Weary they turn from the scroll and crown,
    Fetter and prayer and plough –
  They that go up to the Merciful Town,
    For her gates are closing now.
  It is their right in the Baths of Night
    Body and soul to steep,
  But we – pity us! ah, pity us!
    We wakeful; oh, pity us! –
  We must go back with Policeman Day –
    Back from the City of Sleep!

  Over the edge of the purple down,
    Ere the tender dreams begin,
  Look – we may look – at the Merciful Town,
    But we may not enter in!
  Outcasts all, from her guarded wall
    Back to our watch we creep:
  We – pity us! ah, pity us!
    We wakeful; ah, pity us! –
  We that go back with Policeman Day –
    Back from the City of Sleep!
BODY

charge_poem_body = <<~BODY
  Half a league, half a league,
  Half a league onward,
  All in the valley of Death
    Rode the six hundred.
  “Forward, the Light Brigade!
  Charge for the guns!” he said.
  Into the valley of Death
    Rode the six hundred.

  “Forward, the Light Brigade!”
  Was there a man dismayed?
  Not though the soldier knew
    Someone had blundered.
    Theirs not to make reply,
    Theirs not to reason why,
    Theirs but to do and die.
    Into the valley of Death
    Rode the six hundred.

  Cannon to right of them,
  Cannon to left of them,
  Cannon in front of them
    Volleyed and thundered;
  Stormed at with shot and shell,
  Boldly they rode and well,
  Into the jaws of Death,
  Into the mouth of hell
    Rode the six hundred.

  Flashed all their sabres bare,
  Flashed as they turned in air
  Sabring the gunners there,
  Charging an army, while
    All the world wondered.
  Plunged in the battery-smoke
  Right through the line they broke;
  Cossack and Russian
  Reeled from the sabre stroke
    Shattered and sundered.
  Then they rode back, but not
    Not the six hundred.

  Cannon to right of them,
  Cannon to left of them,
  Cannon behind them
    Volleyed and thundered;
  Stormed at with shot and shell,
  While horse and hero fell.
  They that had fought so well
  Came through the jaws of Death,
  Back from the mouth of hell,
  All that was left of them,
    Left of six hundred.

  When can their glory fade?
  O the wild charge they made!
    All the world wondered.
  Honour the charge they made!
  Honour the Light Brigade,
    Noble six hundred!
BODY

ActiveRecord::Base.transaction do
  # USERS
  martins_kruze = User.create!(username: 'martins.kruze')
  neo = User.create!(username: 'Neo')
  kipling = User.create!(username: 'Rudyard Kipling')
  tennyson = User.create!(username: 'ALFRED, LORD TENNYSON')
  great_commenter = User.create!(username: 'CommentMan')

  # ARTICLES
  arel_story = Article.create!(
    subject: 'Arel is great',
    body: 'Be very, very careful!',
    author: martins_kruze
  )
  matrix = Article.create!(
    subject: 'Pills - do not take them!',
    body: 'The red one made me see things...',
    author: neo
  )
  if_poem = Article.create!(
    subject: 'If - (1910)',
    body: if_poem_body,
    author: kipling
  )
  if_poem = Article.create!(
    subject: 'The City of Sleep (1895)',
    body: city_poem_body,
    author: kipling
  )
  charge_poem = Article.create!(
    subject: 'Charge (1854)',
    body: charge_poem_body,
    author: tennyson
  )

  # COMMENTS
  arel_story.comments.create!(commenter: neo, content: "I'm not sure about that...")
  arel_story.comments.create!(commenter: martins_kruze, content: 'Do not do this ;)')

  Article.all.each do |article|
    article.comments.create!(
      commenter: great_commenter,
      content: 'spam comment level 0'
    )
  end
  Comment.where(parent_id: nil).find_each do |comment|
    comment.children.create!(
      commenter: great_commenter,
      article: comment.article,
      content: 'spam comment level 1'
    )
  end
  Comment.where.not(parent_id: nil).find_each do |comment|
    comment_level_2 = comment.children.create!(
      commenter: great_commenter,
      content: 'spam comment level 2',
      article: comment.article
    )
    comment_level_2.children.create!(
      commenter: great_commenter,
      content: 'spam comment level 3',
      article: comment.article
    )
  end
  # deep discussion
  matrix_comment_0 = matrix.comments.create!(
    commenter: martins_kruze,
    content: '0 Blue then?'
  )
  matrix_comment_1 = matrix_comment_0.children.create!(
    commenter: neo,
    content: '1 No!',
    article: matrix
  )
  matrix_comment_2 = matrix_comment_1.children.create!(
    commenter: martins_kruze,
    content: '2 But if you have to?',
    article: matrix
  )
  matrix_comment_3 = matrix_comment_2.children.create!(
    commenter: neo,
    content: '3 Just run away!',
    article: matrix
  )
  matrix_comment_4 = matrix_comment_3.children.create!(
    commenter: martins_kruze,
    content: '4 It is time to challenge!',
    article: matrix
  )
  matrix_comment_5 = matrix_comment_4.children.create!(
    commenter: neo,
    content: '5 OK, do what you like',
    article: matrix
  )
  matrix_comment_6 = matrix_comment_5.children.create!(
    commenter: martins_kruze,
    content: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    article: matrix
  )
end
