class Game < ActiveRecord::Base
  belongs_to :player_1, class_name: "Player"
  belongs_to :player_2, class_name: "Player"
  has_many :held_cards

  def player_1
    Player.find_by_id(player_1_id)
  end

  def player_2
    Player.find_by_id(player_2_id)
  end

  def game_action(move, player_id, card_num)
    #card_num = 1..5
    player = Player.find(player_id)

    c = player.show_cards(id)
    c_id = c[card_num - 1]["id"]

    card = Card.find(c_id)

    case move
    when "play"
      #perform card action, discard card, create new card
      player.play_card(card, id)
      player.destroy_card(card_num, id)
      player.generate_card(id)
    when "discard"
      #discard card, create new card
      player.destroy_card(card_num, id)
      player.generate_card(id)
    when "pass"
      #do nothing
    end

    return win_condition(player, player.find_opp(id))

  end

  def turn_tracker
    a = player_1
    b = player_2

    if last_turn_player_id == a.id
      last_turn_player_id = b.id
      game.update
    else
      last_turn_player_id = a.id
      game.update
    end
  end

  def first_player_setter
    if last_turn_player_id == nil
      last_turn_player_id = randomize_first_turn_player
    end
  end

  def randomize_first_turn_player
    a = player_1
    b = player_2
    if a && b
      num = rand(1..50)
      num > 25 ? a.id : b.id
    end
  end

end
