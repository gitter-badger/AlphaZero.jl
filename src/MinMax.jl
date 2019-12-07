#####
##### A simple minmax player to be used as a baseline
#####

module MinMax

import ..GI

function current_player_value(white_reward, white_playing) :: Float64
  if iszero(white_reward)
    return 0.
  else
    v = Inf * sign(white_reward)
    return white_playing ? v : - v
  end
end

# Return the value of a state for the player playing
function value(game, depth)
  wr = GI.white_reward(game)
  wp = GI.white_playing(game)
  if isnothing(wr)
    if depth == 0
      return GI.heuristic_value(game)
    else
      return maximum(qvalue(game, a, depth)
        for a in GI.available_actions(game))
    end
  else
    return current_player_value(wr, wp)
  end
end

# Return a Q-value and an action
function qvalue(game, action, depth)
  @assert isnothing(GI.white_reward(game))
  wp = GI.white_playing(game)
  game = copy(game)
  GI.play!(game, action)
  pswitch = wp != GI.white_playing(game)
  nextv = value(game, depth - 1)
  return pswitch ? - nextv : nextv
end

minmax(game, actions, depth) = argmax([qvalue(game, a, depth) for a in actions])

struct AI <: GI.Player
  depth :: Int
  AI(;depth) = new(depth)
end

function GI.select_move(ai::AI, game)
  actions = GI.available_actions(game)
  aid = minmax(game, actions, ai.depth)
  return actions[aid]
end

end